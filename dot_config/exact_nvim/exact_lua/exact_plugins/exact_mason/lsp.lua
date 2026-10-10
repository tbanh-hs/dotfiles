return {
  {
    "artemave/workspace-diagnostics.nvim",
    opts = {},
    config = function(_, opts)
      require("workspace-diagnostics").setup(opts)

      Snacks.util.lsp.on(function(buf, client)
        if client:supports_method("workspace/diagnostic", buf) then
          vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
        else
          require("workspace-diagnostics").populate_workspace_diagnostics(client, buf)
        end
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        ["*"] = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
        cssls = {
          settings = {
            css = { lint = { unknownAtRules = "ignore" } },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              hover = {
                previewFields = 200, -- default 50; raise to show more struct fields
                enumsLimit = 100, -- default 5; for large union/enum types
              },
            },
          },
        },
        vtsls = {
          keys = {
            {
              "<leader>cu",
              LazyVim.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused",
            },
          },
        },
        taplo = {
          enabled = false,
        },
        tombi = {},
      },
    },
  },
}
