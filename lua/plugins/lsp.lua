return {
  -- LSP operations and code actions
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>;", function()
        require("Comment.api").toggle.linewise.current()
      end, desc = "Comment out line" },
      { "<leader>;", function()
        local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'nx', false)
        require("Comment.api").toggle.linewise(vim.fn.visualmode())
      end, mode = "x", desc = "Comment out lines" },
      { "<leader>cc", "<cmd>make<cr>", desc = "Compile" },
      { "<leader>cd", vim.lsp.buf.definition, desc = "Jump to definition" },
      { "<leader>cD", vim.lsp.buf.references, desc = "See references" },
      { "<leader>cf", vim.lsp.buf.format, desc = "Format region" },
      { "<leader>ck", vim.lsp.buf.hover, desc = "Jump to documentation" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename all references" },
      { "<leader>cs", function()
        -- Send to REPL - implementation depends on REPL plugin
        vim.notify("Send to REPL not configured")
      end, desc = "Send to repl" },
      { "<leader>cx", vim.diagnostic.open_float, desc = "LSP diagnostics" },
      { "<leader>ct", vim.lsp.buf.type_definition, desc = "Find type definition" },
      { "<leader>co", function()
        vim.lsp.buf.code_action({
          filter = function(action)
            return action.kind and action.kind:match("source.organizeImports")
          end,
          apply = true,
        })
      end, desc = "Organize imports" },
      { "<leader>cw", function()
        vim.cmd([[%s/\s\+$//e]])
      end, desc = "Remove trailing whitespace" },
      { "<leader>cW", function()
        vim.cmd([[%s/\n\+\%$//e]])
      end, desc = "Remove trailing newlines" },
      { "<leader>ce", vim.diagnostic.goto_next, desc = "Next error" },
      { "<leader>cE", vim.diagnostic.goto_prev, desc = "Previous error" },
    },
  },
}