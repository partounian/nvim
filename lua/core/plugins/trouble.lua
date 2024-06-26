local user_config = vim.g.config.plugins.trouble or {}

local default_config = {
  enabled = false,
  opts = {
    modes = {
      preview_diagnostics = {
        mode = "diagnostics",
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.3,
        },
      },
    },
  },
  groups = {
    ["<leader>x"] = { name = "Trouble" },
  },
  keys = {
    {
      "<leader>xl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}

local config = vim.tbl_deep_extend("force", default_config, user_config)

return {
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = config.enabled,
    opts = config.opts,
    keys = config.keys,
  },
  -- which key integration
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      groups = config.groups,
    },
  },
}
