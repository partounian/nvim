local conf = vim.g.config.plugins.colorful_winsep
return {
  "nvim-zh/colorful-winsep.nvim",
  enabled = conf.enabled,
  config = true,
  event = { "WinNew" },
}
