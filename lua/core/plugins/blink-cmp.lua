return {
  {
    "saghen/blink.compat",
    cond = vim.g.config.plugins.blink_cmp.enabled,
    opts = {
      -- impersonate_nvim_cmp = true,
      enable_events = true,
    },
  },
  {
    "saghen/blink.cmp",
    cond = vim.g.config.plugins.blink_cmp.enabled,
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "supermaven-inc/supermaven-nvim" },
      { "mikavilpas/blink-ripgrep.nvim" },
    },

    -- use a release tag to download pre-built binaries
    version = "v0.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = {
        preset = "default",

        ["<Tab>"] = {
          function(cmp)
            if cmp.is_in_snippet() then
              return cmp.accept()
            else
              return cmp.select_next()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },

      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },

      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",

      -- experimental auto-brackets support
      accept = { auto_brackets = { enabled = true } },

      -- experimental signature help support
      trigger = { signature_help = { enabled = true } },

      sources = {
        completion = {
          -- there are more providers in other files
          enabled_providers = {
            "lsp",
            "path",
            "snippets",
            -- "buffer",
            "supermaven",
            "ripgrep",
          },
        },

        providers = {
          supermaven = {
            name = "supermaven",
            module = "blink.compat.source",
            score_offset = 1,
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = -3,
          },
          lsp = {
            score_offset = -4,
          },
          ripgrep = {
            name = "Ripgrep",
            module = "blink-ripgrep",

            score_offset = -5,

            -- the options below are optional, some default values are shown
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {
              -- the minimum length of the current word to start searching
              -- (if the word is shorter than this, the search will not start)
              prefix_min_len = 3,
              -- The number of lines to show around each match in the preview window
              context_size = 5,
            },
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.snippets",
            score_offset = -6,
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = -10,
          },
        },
      },
      kind_icons = {
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
        Supermaven = "",
      },

      windows = {
        autocomplete = {
          -- docs recommend setting this to "manual" or "auto_insert" when using "super-tab" or "enter" config
          selection = "manual",
        },
      },
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { "sources.completion.enabled_providers" },
  },
}
