local conf = vim.g.config

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "onsails/lspkind-nvim" },
      { "folke/neoconf.nvim", config = true, ft = "lua" }, -- must be loaded before lsp
      -- { "saghen/blink.cmp" },
    },
    config = function(_, opts)
      require("core.plugins.lsp.lsp")

      if vim.g.config.plugins.blink_cmp.enabled then
        -- for blink.cmp
        local lspconfig = require("lspconfig")
        for server, config in pairs(opts.servers or {}) do
          config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
          lspconfig[server].setup(config)
        end
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = "Mason",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim", module = "mason" },
    },
    config = function()
      -- install_root_dir = path.concat({ vim.fn.stdpath("data"), "mason" }),
      require("mason").setup()

      -- ensure tools (except LSPs) are installed
      local mr = require("mason-registry")
      local function install_ensured()
        for _, tool in ipairs(conf.tools) do
          local package_name, package_version
          if tool:find("@") then
            package_name, package_version = tool:match("([^@]+)@([^@]+)")
          end
          local p
          if package_name then
            p = mr.get_package(package_name)
          else
            p = mr.get_package(tool)
          end
          if not p:is_installed() then
            if package_name then
              p:install({ version = package_version })
            else
              p:install()
            end
          end
        end
      end
      if mr.refresh then
        mr.refresh(install_ensured)
      else
        install_ensured()
      end

      -- install LSPs
      require("mason-lspconfig").setup({ ensure_installed = conf.lsp_servers })
    end,
  },
}
