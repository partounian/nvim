local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "RRethy/nvim-treesitter-endwise",
    "mfussenegger/nvim-ts-hint-textobject",
    "windwp/nvim-ts-autotag",
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    local conf = vim.g.config
    require("nvim-treesitter.configs").setup({
      ensure_installed = conf.treesitter_ensure_installed,
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          scope_incremental = "<CR>",
          node_incremental = "<TAB>",
          node_decremental = "<S-TAB>",
        },
      },
      endwise = {
        enable = true,
      },
      indent = { enable = true },
      autopairs = { enable = true },
    })

    -- TODO: move to plugin spec init(?)
    vim.g.skip_ts_context_commentstring_module = true -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#getting-started
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })
    local get_option = vim.filetype.get_option
    vim.filetype.get_option = function(filetype, option)
      return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
    end

    require("nvim-ts-autotag").setup()
  end,
}

return M
