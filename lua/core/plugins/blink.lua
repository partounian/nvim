-- much was stolen from LazyVim :)
-- https://github.com/LazyVim/LazyVim/blob/475e3f32b82db0cc497f712953993dcce4f048c6/lua/lazyvim/plugins/extras/coding/blink.lua
-- TODO: copilot and supermaven itegration
local user_config = vim.g.config.plugins.blink or {}

local default_config = {
  enabled = false,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },

      ["<Tab>"] = {
        function(cmp)
          return cmp.select_next()
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          return cmp.select_prev()
        end,
        "snippet_backward",
        "fallback",
      },

      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },

      ["<C-up>"] = { "scroll_documentation_up", "fallback" },
      ["<C-down>"] = { "scroll_documentation_down", "fallback" },
    },

    sources = {
      -- compat = {},
      default = { "lsp", "path", "luasnip", "buffer" },
      providers = {
        lsp = {
          min_keyword_length = 2, -- Number of characters to trigger porvider
          score_offset = 0, -- Boost/penalize the score of the items
        },
        path = {
          min_keyword_length = 0,
        },
        luasnip = {
          min_keyword_length = 2,
        },
        buffer = {
          min_keyword_length = 5,
          max_items = 5,
        },
      },
    },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        treesitter_highlighting = true,
        window = { border = "rounded" },
      },
      list = {
        selection = "auto_insert",
      },
      trigger = {
        show_on_insert_on_trigger_character = false,
        show_on_accept_on_trigger_character = false,
      },
      menu = {
        border = "rounded",
        draw = {
          -- nvim-cmp look
          -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon" } },
          treesitter = true,
        },
      },
      ghost_text = {
        enabled = true,
      },
    },
  },
}

local config = vim.tbl_deep_extend("force", default_config, user_config)

return {
  {
    "saghen/blink.cmp",
    version = "v0.*",
    event = "InsertEnter",
    enabled = config.enabled,
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "saghen/blink.compat",
        optional = true,
        version = "*",
        lazy = true,
        opts = {},
      },
    },
    opts = config.opts,
    opts_extend = {
      "sources.compat",
      "sources.default",
    },
    config = function(_, opts)
      -- setup compat sources and provider
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- TODO: remove when blink made a new release > 0.7.6
      opts.sources.completion = opts.sources.completion or {}
      opts.sources.completion.enabled_providers = enabled

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          require("blink.cmp.types").CompletionItemKind[provider.kind] = provider.kind
          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = provider.kind or item.kind
            end
            return items
          end
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },

  -- add icons
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = {
        Array = " ",
        Boolean = "󰨙 ",
        Class = " ",
        Codeium = "󰘦 ",
        Color = " ",
        Control = " ",
        Collapsed = " ",
        Constant = "󰏿 ",
        Constructor = " ",
        Copilot = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = "󰊕 ",
        Interface = " ",
        Key = " ",
        Keyword = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Null = " ",
        Number = "󰎠 ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        String = " ",
        Struct = "󰆼 ",
        Supermaven = " ",
        TabNine = "󰏚 ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = "󰀫 ",
      }
    end,
  },

  -- lazydev integration
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lazydev" },
        providers = {
          lsp = {
            -- dont show LuaLS require statements when lazydev has items
            fallbacks = { "buffer" },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
          },
        },
      },
    },
  },
  -- catppucci
  -- lazydev integration
  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   opts = {
  --     sources = {
  --       completion = {
  --         -- add lazydev to your completion providers
  --         enabled_providers = { "lazydev" },
  --       },
  --       providers = {
  --         lsp = {
  --           -- dont show LuaLS require statements when lazydev has items
  --           fallback_for = { "lazydev" },
  --         },
  --         lazydev = {
  --           name = "LazyDev",
  --           module = "lazydev.integrations.blink",
  --         },
  --       },
  --     },
  --   },
  -- },
  -- luasnip integration
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
    },
  },
  -- catppuccin integration
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },

  -- supermaven integration
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      { "blink.compat" },
      { "supermaven-nvim" },
    },
    opts = {
      sources = {
        compat = { "supermaven" },
        providers = { supermaven = { kind = "Supermaven" } },
        -- completion = {
        --   enabled_providers = { "supermaven" },
        -- },
        -- providers = {
        --   supermaven = {
        --     name = "supermaven",
        --     module = "blink.compat.source",
        --     score_offset = 3,
        --   },
        -- },
      },
    },
  },
}
