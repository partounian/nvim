local nls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local h = require("null-ls.helpers")
local u = require("null-ls.utils")

nls.setup({
  sources = {
    nls.builtins.code_actions.refactoring,
    nls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
    nls.builtins.diagnostics.eslint.with({
      cwd = h.cache.by_bufnr(function(params)
        return u.root_pattern(
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json"
        )(params.bufname)
      end),
    }),
    -- can't use eslint_d until the above works with it
    -- nls.builtins.diagnostics.eslint_d.with({
    --   cwd = h.cache.by_bufnr(function(params)
    --     return u.root_pattern(
    --       ".eslintrc",
    --       ".eslintrc.js",
    --       ".eslintrc.cjs",
    --       ".eslintrc.yaml",
    --       ".eslintrc.yml",
    --       ".eslintrc.json"
    --     )(params.bufname)
    --   end),
    -- }),
    nls.builtins.diagnostics.fish,
    nls.builtins.diagnostics.commitlint,
    nls.builtins.formatting.rustywind, -- tailwind class organizer
    nls.builtins.formatting.stylelint,
    nls.builtins.formatting.prettierd.with({
      cwd = h.cache.by_bufnr(function(params)
        return u.root_pattern(
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.json5",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.toml",
          "prettier.config.js",
          "prettier.config.cjs"
        )(params.bufname)
      end),
    }),
    nls.builtins.formatting.npm_groovy_lint,
    nls.builtins.formatting.terraform_fmt,
    nls.builtins.formatting.black,
    nls.builtins.formatting.goimports,
    nls.builtins.formatting.gofumpt,
    nls.builtins.formatting.latexindent.with({
      extra_args = { "-g", "/dev/null" }, -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
    }),
    nls.builtins.code_actions.shellcheck,
    nls.builtins.diagnostics.vale,
  },
  on_attach = function(client, bufnr)
    local wk = require("which-key")
    local default_options = { silent = true }
    wk.register({
      m = {
        F = { "<cmd>lua require('functions').toggle_autoformat()<cr>", "Toggle format on save" },
      },
    }, { prefix = "<leader>", mode = "n", default_options })
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          if AUTOFORMAT_ACTIVE then -- global var defined in functions.lua
            vim.lsp.buf.format({ bufnr = bufnr })
          end
        end,
      })
    end
  end,
})
