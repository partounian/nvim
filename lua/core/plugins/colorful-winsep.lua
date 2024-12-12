local conf = vim.g.config.plugins.colorful_winsep

return {
  {
    "nvim-zh/colorful-winsep.nvim",
    enabled = conf.enabled,
    config = true,
    event = { "WinNew" },
  },
  -- catppuccin integration
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = {
        colorful_winsep = {
          enabled = conf.enabled,
        },
      },
    },
  },
}
