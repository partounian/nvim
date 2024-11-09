return {
  "weizheheng/ror.nvim",
  keys = {
    { "<leader>rc", ":lua require('ror.commands').list_commands()<CR>", desc = "Commands" },
    { "<leader>rf", ":lua require('ror.finders').select_finders()<CR>", desc = "Finders" },
    { "<leader>rr", ":lua require('ror.routes').list_routes()<CR>", desc = "List routes" },
    { "<leader>rs", ":lua require('ror.routes').sync_routes()<CR>", desc = "Sync routes" },
    { "<leader>rt", ":lua require('ror.test').run()<CR>", desc = "Test current file" },
    { "<leader>rl", ":lua require('ror.test').run('Line')<CR>", desc = "Test current line" },
  },
}
