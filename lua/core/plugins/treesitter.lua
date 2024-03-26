local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
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
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ib"] = "@block.inner",
            ["ab"] = "@block.outer",
            ["ir"] = "@parameter.inner",
            ["ar"] = "@parameter.outer",
          },
        },
      },
      -- context_commentstring = { -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#getting-started
      --   enable = true,
      --   enable_autocmd = false,
      --   config = {
      --     sql = "-- %s",
      --     tpl = "// %s",
      --   },
      -- },
    })

    vim.g.skip_ts_context_commentstring_module = true -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#getting-started
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })

    require("nvim-ts-autotag").setup()
  end,
}

return M
