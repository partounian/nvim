return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  enabled = vim.g.config.plugins.supermaven.enable,
  dependencies = {
    {
      "zbirenbaum/copilot-cmp",
      event = { "InsertEnter", "LspAttach" },
      -- TODO: copied from lua/core/plugins/copilot.lua, determine if something like this is necessary
      --   config = function(_, opts)
      --     local function on_att(on_attach)
      --       vim.api.nvim_create_autocmd("LspAttach", {
      --         callback = function(args)
      --           local buffer = args.buf
      --           local client = vim.lsp.get_client_by_id(args.data.client_id)
      --           on_attach(client, buffer)
      --         end,
      --       })
      --     end
      --     -- local copilot_cmp = require("copilot_cmp")
      --     -- copilot_cmp.setup(opts)
      --     -- attach cmp source whenever copilot attaches
      --     -- fixes lazy-loading issues with the copilot cmp source
      --     -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/copilot.lua#L61
      --     on_att(function(client)
      --       if client.name == "supermaven" then
      --         copilot_cmp._on_insert_enter({})
      --       end
      --     end)
      --   end,
    },
  },

  config = function()
    local api = require("supermaven-nvim.api")
    -- TODO: fix if someone cares
    -- local utils = require("utils.functions")
    -- utils.map("n", "<leader>msm", api.start(), { desc = "Enable Supermaven" })
    require("supermaven-nvim").setup({
      disable_inline_completion = true, -- disables inline completion for use with cmp
      -- disable_keymaps = true -- disables built in keymaps for more manual control
    })

    if vim.g.config.plugins.supermaven.disable_autostart then
      -- If I want Supermaven to only be enabled when I ask for it
      api.stop()
    end
  end,
}
