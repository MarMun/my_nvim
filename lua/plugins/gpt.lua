return {
  "robitx/gp.nvim",
  config = function()
    local conf = {
      -- openai_api_key = os.getenv("OPENAI_API_KEY"),
      -- openai_api_key = "YOUR_API_KEY",

      -- For customization, refer to Install > Configuration in the Documentation/Readme
    }
    require("gp").setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}
