require("project_nvim").setup({
  patterns = {
    ".git",
    -- ".terraform",
  },
  -- detection_methods = { "lsp", "pattern" },
  detection_methods = { "pattern" },
})
