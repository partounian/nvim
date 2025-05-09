local catppuccin = require("catppuccin")
local utils = require("utils.functions")

local harpoon_enabled = utils.safe_nested_config(vim.g.config.plugins, "harpoon", "enabled")
local trouble_enabled = utils.safe_nested_config(vim.g.config.plugins, "trouble", "enabled")

catppuccin.setup({
  flavour = "auto", -- latte, frappe, macchiato, mocha
  background = { -- :h background https://github.com/catppuccin/nvim/blob/637d99e638bc6f1efedac582f6ccab08badac0c6/lua/catppuccin/types.lua#L45-L51
    light = "latte",
    dark = "macchiato",
  },
  default_integrations = false,
  integrations = {
    alpha = false,
    cmp = true,
    dap = true,
    dap_ui = true,
    dropbar = { enabled = true },
    fidget = false,
    fzf = true,
    gitsigns = true,
    harpoon = harpoon_enabled,
    headlines = true,
    lsp_trouble = trouble_enabled,
    markdown = true,
    mason = true,
    mini = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
      inlay_hints = {
        background = true,
      },
    },
    neogit = true,
    neotree = true,
    noice = true,
    notify = true,
    overseer = true,
    symbols_outline = true,
    telescope = true,
    treesitter = true,
    which_key = true,
    window_picker = true,
  },
})

-- vim.cmd("colorscheme " .. vim.g.config.theme.catppuccin.variant)
vim.cmd.colorscheme("catppuccin")
