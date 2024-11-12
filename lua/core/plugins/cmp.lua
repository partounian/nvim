local icons = require("utils.icons")

local M = {
  "iguanacucumber/magazine.nvim",
  cond = vim.g.config.plugins.cmp.enabled,
  name = "nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
    { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
    { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
    { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
    "https://codeberg.org/FelipeLema/cmp-async-path",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "lukas-reineke/cmp-rg",
    "saadparwaiz1/cmp_luasnip",
    -- { "petertriho/cmp-git", ft = { "gitcommit", "octo", "NeogitCommitMessage" } },
    { "mtoohey31/cmp-fish", ft = "fish" },
    { "David-Kunz/cmp-npm", ft = "json" },
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    local sources = {
      { name = "calc", priority = 200 },
      { name = "path", priority = 300 },
      { name = "rg", keyword_length = 3, priority = 400 },
      { name = "nvim_lsp", priority = 500 },
      { name = "luasnip", priority = 500 },
      { name = "nvim_lsp_signature_help" },
      -- { name = "git" },
      { name = "fish" },
      { name = "npm", keyword_length = 4 },
    }

    if vim.g.config.plugins.emoji.enable then
      table.insert(sources, { name = "emoji" })
    end

    local format = {
      mode = "symbol",
      max_width = 50,
      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
    }

    if vim.g.config.plugins.copilot.enable then
      table.insert(sources, { name = "copilot", group_index = 2 })
      table.insert(format.symbol_map, { Copilot = icons.apps.Copilot })
    end

    if vim.g.config.plugins.supermaven.enabled then
      table.insert(sources, { name = "supermaven" })
      format.symbol_map.Supermaven = icons.apps.Supermaven
    end

    if vim.g.config.plugins.codeium.enabled then
      table.insert(sources, { name = "codeium" })
      format.symbol_map.Codeium = icons.apps.Codeium
    end

    local has_words_before = function()
      if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    cmp.setup({
      formatting = {
        format = lspkind.cmp_format(format),
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      preselect = cmp.PreselectMode.None,
      mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
        -- TODO only when copilot is enabled
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
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
      sources = sources,
    })

    cmp.setup.cmdline("/", {
      sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
      }, {
        { name = "buffer" },
      }),
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })

    -- require("cmp_git").setup()
  end,
}

return M
