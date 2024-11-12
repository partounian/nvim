local conf = vim.g.config.plugins.codeium

return {
  "Exafunction/codeium.nvim",
  enabled = conf.enabled,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  event = "BufEnter",
  opts = conf.opts,
}
