local nls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local h = require("null-ls.helpers")
local u = require("null-ls.utils")

nls.setup({
  sources = {
    nls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
    nls.builtins.diagnostics.eslint.with({
      cwd = h.cache.by_bufnr(function(params)
        return u.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.yml", ".eslintrc.json")(params.bufname)
      end),
    }),
    -- can't use eslint_d until the above works with it
    -- nls.builtins.diagnostics.eslint_d.with({
    --   cwd = h.cache.by_bufnr(function(params)
    --     return u.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.yml", ".eslintrc.json")(params.bufname)
    --   end),
    -- }),
    nls.builtins.diagnostics.fish,
    -- nls.builtins.formatting.prettier.with({
    --   extra_args = { "--single-quote", "false" },
    -- }),
    nls.builtins.formatting.prettierd.with({
      cwd = h.cache.by_bufnr(function(params)
        return u.root_pattern(
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.js",
          "prettier.config.js"
        )(params.bufname)
      end),
    }),
    nls.builtins.formatting.terraform_fmt,
    nls.builtins.formatting.black,
    nls.builtins.formatting.goimports,
    nls.builtins.formatting.gofumpt,
    -- tailwind class organizer
    -- nls.builtins.formatting.rustywind.with({
    --   cwd = h.cache.by_bufnr(function(params)
    --     return u.root_pattern("tailwind.config.js")(params.bufname)
    --   end),
    -- }),
    nls.builtins.diagnostics.staticcheck,
    -- nls.builtins.formatting.latexindent.with({
    --   extra_args = { "-g", "/dev/null" }, -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
    -- }),
    nls.builtins.code_actions.shellcheck,
    nls.builtins.code_actions.gitsigns,
    nls.builtins.formatting.shfmt,
    nls.builtins.diagnostics.ruff,
    -- https://github.com/ray-x/go.nvim#integrate-null-ls
    nls.builtins.diagnostics.revive,
    nls.builtins.formatting.golines.with({
      extra_args = {
        "--max-len=180",
        "--base-formatter=gofumpt",
      },
    }),
  },
  on_attach = function(client, bufnr)
    vim.keymap.set(
      "n",
      "<leader>tF",
      "<cmd>lua require('core.plugins.lsp.utils').toggle_autoformat()<cr>",
      { desc = "Toggle format on save" }
    )
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
