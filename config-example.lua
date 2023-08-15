-- see ./lua/core/config/defaults.lua for all
-- possible values and a short description
return {
  options = {
    -- grepprg = "rg --hidden --vimgrep --smart-case --", -- use rg instead of grep
    pumblend = 0, -- Popup blend
  },
  plugins = {
    alpha = {
      -- disable_dashboard_header = true,
    },
    git = {
      -- which tool to use for handling git merge conflicts
      -- choose between "git-conflict" and "diffview" or "both"
      merge_conflict_tool = "both",
    },
    telescope = {
      fzf_native = {
        enable = true,
      },
    },
  },
  theme = {
    name = "catppuccin",
    catppuccin = {
      -- dark
      variant = "catppuccin-macchiato",
      -- light
      -- variant = "catppuccin-latte",
    },
  },

  -- treesitter parsers to be installed
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  treesitter_ensure_installed = {
    "bash",
    "cmake",
    "css",
    "dockerfile",
    "go",
    "graphql",
    "hcl",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "query",
    "python",
    "regex",
    "ruby",
    "sql",
    "rust",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },

  -- LSPs that should be installed by Mason-lspconfig
  lsp_servers = {
    "bashls",
    "cssls",
    "dockerls",
    "jsonls",
    "gopls",
    "marksman",
    "pylsp", -- might be python-lsp-server
    "pyright",
    "ruby_ls",
    "solargraph",
    "tailwindcss",
    "tsserver",
    "typst_lsp",
    "yamlls",
  },

  -- Tools that should be installed by Mason
  tools = {
    -- Formatter
    "black",
    "prettier",
    "prettierd",
    "stylua",
    "shfmt",
    -- Linter
    "eslint_d",
    "shellcheck",
    "yamllint",
    "ruff",
    -- DAP
    "debugpy",
    "codelldb",
  },
}
