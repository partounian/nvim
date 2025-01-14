local user_config = vim.g.config.plugins.noice or {}

local default_config = {
  enabled = true,
  opts = {
    cmdline = {
      view = "cmdline", -- classic cmdline at the botton
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      long_message_to_split = true, -- long messages will be sent to a split
      -- inc_rename = true, -- enables an input dialog for inc-rename.nvim
      -- lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  keys = {
    { "<leader>n", "", desc = "Noice" },
    { "<leader>nn", "<cmd>Noice all<cr>", desc = "Open Noice" },
    { "<leader>ne", "<cmd>Noice errors<cr>", desc = "Open Noice Errors" },
    { "<leader>sn", "<cmd>Noice fzf<cr>", desc = "Open Noice with fzf-lua" },
  },
}

local config = vim.tbl_deep_extend("force", default_config, user_config)

return {
  {
    "folke/noice.nvim",
    enabled = config.enabled,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          top_down = true,
        },
      },
    },
    keys = config.keys,
    opts = config.opts,
  },
}
