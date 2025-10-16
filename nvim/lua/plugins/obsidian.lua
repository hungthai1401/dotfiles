local function dir_exists(path)
  local f = io.popen('[ -d "' .. path .. '" ] && echo "yes"')
  local result = f:read("*l")
  f:close()
  return result == "yes"
end

local workspaces = {}
if dir_exists("/Users/khunglong/Documents/2-Areas/Self/knowledge-vault/") then
  table.insert(workspaces, {
    name = "personal-mac-mini",
    path = "/Users/khunglong/Documents/2-Areas/Self/knowledge-vault/",
  })
end
if dir_exists("~/knowledge-vault/") then
  table.insert(workspaces, {
    name = "personal-omarchy",
    path = "~/knowledge-vault/",
  })
end

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
  -- see below for full list of options 👇
  opts = {
    workspaces = workspaces,
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
  },
}
