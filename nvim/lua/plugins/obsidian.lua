return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "personal-mac-mini",
        path = "$HOME/Documents/2-Areas/Self/knowledge-vault/",
      },
      {
        name = "personal-omarchy",
        path = "~/knowledge-vault/",
      }
    },
    daily_notes = {
      folder = "4 - Journal/Daily",
      date_format = "%Y%m%d",
      template = "Daily Note",
    },
    templates = {
      folder = "99 - Meta/Templates",
      date_format = "%Y%m%d",
      time_format = "%H:%M",
    },
    -- see below for full list of options 👇
  },
}
