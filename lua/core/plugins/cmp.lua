-- GitHub Copilot
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-calc",
    "lukas-reineke/cmp-rg",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "zbirenbaum/copilot.lua",
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
    require("copilot_cmp").setup()

    cmp.setup({
      formatting = {
        format = lspkind.cmp_format({
          with_text = false,
          maxwidth = 50,
          mode = "symbol",
          menu = {
            buffer = "BUF",
            copilot = "",
            rg = "RG",
            nvim_lsp = "LSP",
            path = "PATH",
            luasnip = "SNIP",
            calc = "CALC",
          },
        }),
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          end
        end, { "i", "s" }),
      },
      sources = {
        { name = "copilot" },
        { name = "nvim_lsp", group_index = 2 },
        { name = "nvim_lsp_signature_help" },
        { name = "buffer", keyword_length = 5 },
        { name = "luasnip", group_index = 2 },
        { name = "calc" },
        { name = "path" },
        { name = "rg", keyword_length = 5 },
        -- { omni = true }, -- completion for vimtex - is this necessary?
      },
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}

return M
