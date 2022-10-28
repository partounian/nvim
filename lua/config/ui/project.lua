require("project_nvim").setup({
  patterns = {
    ".git",
    ".terraform",
    -- "package.json",
    ".terraform",
    "go.mod",
    "requirements.yml",
    "pyrightconfig.json",
    "pyproject.toml",
  },
  -- detection_methods = { "lsp", "pattern" },
  detection_methods = { "pattern" },
})
