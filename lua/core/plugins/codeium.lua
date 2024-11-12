local config = vim.g.config.plugins.codeium or {}

return {
  "Exafunction/codeium.nvim",
  enabled = config.enabled,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  event = "BufEnter",
  opts = {
    virtual_text = {
      enabled = true,
    },
  },
}
