-- n8n-git-memory: keep a live shadow branch <repo>-<current>-n8n
-- Worktree lives OUTSIDE the repo (Git requirement): <parent>/.<repo>-n8n-sync

local M = {}

-- --- Config ---
local cfg = {
  patterns = "*", -- or { "*.ts","*.vue",... }
  remote = "origin",
  debounce_ms = 800,
  notify = true,
}

-- --- Utils ---
local function note(msg, lvl)
  if cfg.notify then
    vim.notify("[n8n-git] " .. msg, lvl or vim.log.levels.INFO)
  end
end
local function sh(args, cwd)
  local Job = require("plenary.job")
  local out, err = {}, {}
  local job = Job:new({
    command = args[1],
    args = vim.list_slice(args, 2),
    cwd = cwd,
    on_stdout = function(_, d)
      if d and #d > 0 then
        table.insert(out, d)
      end
    end,
    on_stderr = function(_, d)
      if d and #d > 0 then
        table.insert(err, d)
      end
    end,
  })
  local ok = pcall(function()
    job:sync()
  end)
  return out, (ok and job.code or 1), err
end
local function git(args, cwd)
  return sh(vim.list_extend({ "git" }, args), cwd)
end

local function repo_root()
  local o = { git({ "rev-parse", "--show-toplevel" }) }
  return (o[1] and o[1][1]) or nil
end

local function repo_name(root)
  return vim.fn.fnamemodify(root, ":t")
end

local function cur_branch(cwd)
  local o = { git({ "rev-parse", "--abbrev-ref", "HEAD" }, cwd) }
  return (o[1] and o[1][1]) or "detached"
end

local function sanitize_ref(s)
  -- allow [0-9A-Za-z._-], replace others with '-'
  s = s:gsub("[^0-9A-Za-z%._-]", "-")
  -- no leading dots or dashes
  s = s:gsub("^%.*", ""):gsub("^%-+", "")
  -- no slashes inside
  s = s:gsub("/+", "-")
  -- avoid ending with ".lock"
  s = s:gsub("%.lock$", "-lock")
  if s == "" then
    s = "repo"
  end
  return s
end

local function n8n_branch_name(root)
  local repo = sanitize_ref(vim.fn.fnamemodify(root, ":t"))
  local cur = sanitize_ref((function()
    local o = { git({ "rev-parse", "--abbrev-ref", "HEAD" }, root) }
    return (o[1] and o[1][1]) or "detached"
  end)())
  return string.format("%s-%s-n8n", repo, cur)
end

local function head_of(cwd)
  local o = { git({ "rev-parse", "--abbrev-ref", "HEAD" }, cwd) }
  return (o[1] and o[1][1]) or "unknown"
end
local function relpath(root, abs)
  return abs:sub(#root + 2)
end
local function now_utc()
  return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

-- Worktree path: outside the repo (sibling folder)
local function worktree_dir(root)
  local parent = vim.fn.fnamemodify(root, ":h")
  return ("%s/.%s-n8n-sync"):format(parent, repo_name(root))
end

local function copy_file(src, dst)
  vim.fn.mkdir(vim.fn.fnamemodify(dst, ":h"), "p")
  local lines = vim.fn.readfile(src, "")
  vim.fn.writefile(lines, dst)
end

-- Parse `git worktree list` to detect an existing worktree at path
local function find_worktree(root, wt_dir)
  local out = { git({ "worktree", "list", "--porcelain" }, root) }
  if not out[1] then
    return nil
  end
  local text = table.concat(out[1], "\n")
  local cur, br
  for line in text:gmatch("[^\n]+") do
    local w = line:match("^worktree%s+(.+)$")
    if w then
      cur = w
    end
    local b = line:match("^branch%s+(.+)$")
    if b and cur then
      if vim.fn.fnamemodify(cur, ":p") == vim.fn.fnamemodify(wt_dir, ":p") then
        br = b:gsub("^refs/heads/", "")
        return { path = cur, branch = br }
      end
    end
  end
  return nil
end

-- Ensure: branch exists & worktree at wt_dir is on that branch
local function ensure_branch_and_worktree(root, n8n_branch)
  local wt_dir = worktree_dir(root)

  -- If a normal dir is there, remove it (must not be inside repo anyway)
  if vim.fn.isdirectory(wt_dir) == 1 and vim.fn.isdirectory(wt_dir .. "/.git") ~= 1 then
    vim.fn.delete(wt_dir, "rf")
  end

  local existing = find_worktree(root, wt_dir)
  if existing and existing.branch ~= n8n_branch then
    note(("removing stale worktree (%s -> %s)"):format(existing.branch, n8n_branch))
    local _, rc, er = git({ "worktree", "remove", "--force", wt_dir }, root)
    if rc ~= 0 then
      note("worktree remove failed: " .. table.concat(er, "\n"), vim.log.levels.ERROR)
      return nil
    end
    existing = nil
  end

  if not existing then
    -- Create/reset branch while adding the worktree (compatible path)
    local _, rc, er = git({ "worktree", "add", "-B", n8n_branch, wt_dir, "HEAD" }, root)
    if rc ~= 0 then
      -- Fallback for older Git: branch -f + worktree add
      note("fallback: branch -f + worktree add")
      local _, rc1, er1 = git({ "branch", "-f", n8n_branch, "HEAD" }, root)
      if rc1 ~= 0 then
        note("branch -f failed: " .. table.concat(er1, "\n"), vim.log.levels.ERROR)
        return nil
      end
      local _, rc2, er2 = git({ "worktree", "add", wt_dir, n8n_branch }, root)
      if rc2 ~= 0 then
        note("worktree add failed: " .. table.concat(er2, "\n"), vim.log.levels.ERROR)
        return nil
      end
    end
  end

  -- Enforce correct branch inside worktree
  if head_of(wt_dir) ~= n8n_branch then
    git({ "switch", "-C", n8n_branch }, wt_dir)
  end

  return wt_dir
end

-- One-time: copy all tracked files so shadow starts complete
local function bootstrap_if_empty(root, wt_dir)
  local wt_files = { git({ "ls-files", "-z" }, wt_dir) }
  if wt_files[1] and table.concat(wt_files[1]) ~= "" then
    return
  end
  local root_files = { git({ "ls-files", "-z" }, root) }
  if not root_files[1] then
    return
  end
  for path in (table.concat(root_files[1])):gmatch("([^\0]+)") do
    local src = root .. "/" .. path
    if vim.loop.fs_stat(src) and vim.fn.isdirectory(src) ~= 1 then
      copy_file(src, wt_dir .. "/" .. path)
    end
  end
  git({ "add", "-A" }, wt_dir)
  git({ "commit", "-m", "n8n-bootstrap: initial snapshot" }, wt_dir)
  note("bootstrapped initial snapshot")
end

-- Debounced staging/commit/push
local timer, queue = nil, {} -- repo_root -> { wt_dir, n8n_branch, files={rel=true,...} }
local function enqueue(root, wt_dir, n8n_branch, rel)
  queue[root] = queue[root] or { wt_dir = wt_dir, n8n_branch = n8n_branch, files = {} }
  queue[root].files[rel] = true
end
local function commit_and_push(wt_dir, n8n_branch, count)
  if count == 0 then
    return
  end
  git({ "commit", "-m", ("n8n-sync: %d file(s) @ %s"):format(count, now_utc()) }, wt_dir)
  git({ "push", "--force-with-lease", cfg.remote, n8n_branch }, wt_dir)
end
local function flush()
  for _, e in pairs(queue) do
    local wt, br, files = e.wt_dir, e.n8n_branch, vim.tbl_keys(e.files)
    if #files > 0 then
      local root = repo_root()
      for _, rel in ipairs(files) do
        copy_file(root .. "/" .. rel, wt .. "/" .. rel)
      end
      git(vim.list_extend({ "add" }, files), wt)
      local _, changed = git({ "diff", "--cached", "--quiet" }, wt)
      if changed ~= 0 then
        commit_and_push(wt, br, #files)
      end
    end
  end
  queue = {}
end
local function schedule_flush()
  if timer then
    timer:stop()
    timer:close()
  end
  timer = vim.loop.new_timer()
  timer:start(cfg.debounce_ms, 0, vim.schedule_wrap(flush))
end

-- Public API
function M.setup(opts)
  cfg = vim.tbl_deep_extend("force", cfg, opts or {})
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = cfg.patterns,
    desc = "n8n-git-memory: snapshot on save",
    callback = function(args)
      local root = repo_root()
      if not root then
        return
      end
      local n8n_branch = n8n_branch_name(root)
      local wt_dir = ensure_branch_and_worktree(root, n8n_branch)
      if not wt_dir then
        return
      end
      bootstrap_if_empty(root, wt_dir)
      enqueue(root, wt_dir, n8n_branch, relpath(root, args.file))
      schedule_flush()
      note(("wt=%s  head=%s  n8n=%s"):format(wt_dir, head_of(wt_dir), n8n_branch))
    end,
  })
  note("hook registered")
end

return M
