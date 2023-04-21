local M = {
  "olimorris/persisted.nvim",
  config = function()
    require("persisted").setup({
      use_git_branch = true, -- create session files based on the branch of the git enabled repository
    })
  end,
}

return M