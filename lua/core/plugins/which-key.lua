local user_config = vim.g.config.plugins.which_key or {}
local icons = require("utils.icons")

local default_config = {
  opts = {
    preset = "modern",
    icons = {
      mappings = false, -- disable icons in keymaps
      breadcrumb = icons.arrows.DoubleArrowRight, -- symbol used in the command line area that shows your active key combo
      separator = icons.arrows.SmallArrowRight, -- symbol used between a key and it's label
      group = icons.ui.Plus, -- symbol prepended to a group
    },
    layout = {
      width = { min = 5, max = 50 }, -- min and max width of the columns
      spacing = 10, -- spacing between columns
      align = "center", -- align columns left, center or right
    },
    win = {
      no_overlap = false,
    },
    spec = {
      { "<leader>b", group = "Buffers" },
      { "<leader>f", group = "Files" },
      { "<leader>l", group = "LSP" },
      { "<leader>m", group = "Misc" },
      { "<leader>q", group = "Quickfix" },
      { "<leader>r", group = "RoR" },
      { "<leader>R", group = "Replace" },
      { "<leader>mS", group = "TreeSJ" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Toggles" },
      { "<leader>w", group = "Window" },
      { "<leader>z", group = "Spelling" },
    },
  },
}

local config = vim.tbl_deep_extend("force", default_config, user_config)

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = config.opts,
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
