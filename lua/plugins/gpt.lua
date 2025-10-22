return {
  "robitx/gp.nvim",
  config = function()
    local conf = {
      providers = {
        openrouter = {
          disable = false,
          endpoint = os.getenv("OPENROUTER_API_BASE"),
          secret = os.getenv("OPENROUTER_API_KEY"),
        },
      },
      agents = {
        {
          name = "Chat",
          provider = "openrouter",
          chat = true,
          command = true,
          model = { model = "openai/chatgpt-4o-latest" },
          system_prompt = "You explain and theorise about coding related topics",
        },
        {
          name = "Coding",
          provider = "openrouter",
          chat = true,
          command = true,
          model = { model = "openai/gpt-5-codex" },
          system_prompt = "You are an coding assistant focused on code completion and comment to code transformation",
        },
      },

      default_chat_agent = "Chat",
      --
      -- For customization, refer to Install > Configuration in the Documentation/Readme
    }

    require("gp").setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}
