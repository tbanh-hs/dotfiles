local disabled_filetypes = {
  "markdown",
}

local function dismiss()
  vim.lsp.inline_completion.enable(false, { bufnr = 0 })
  vim.lsp.inline_completion.enable(true, { bufnr = 0 })
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      copilot = {
        enabled = false,
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
        root_dir = function(bufnr, on_dir)
          if not vim.tbl_contains(disabled_filetypes, vim.bo[bufnr].filetype) then
            on_dir(vim.fs.root(bufnr, ".git"))
          end
        end,
        keys = {
          {
            "<C-e>",
            dismiss,
            mode = "i",
            desc = "Dismiss Copilot suggestion",
          },
          {
            "<C-c>",
            dismiss,
            mode = "i",
            desc = "Dismiss Copilot suggestion",
          },
        },
      },
    },
  },
}
