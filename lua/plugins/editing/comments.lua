return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      enable_autocmd = false,
    },
    config = function(_, opts)
      vim.g.skip_ts_context_commentstring_module = true

      local ok, ts_cc = pcall(require, "ts_context_commentstring")
      if not ok then
        return
      end

      ts_cc.setup(opts or {})

      local update_fn
      local success, internal = pcall(require, "ts_context_commentstring.internal")
      if success then
        update_fn = function()
          pcall(internal.update_commentstring, {})
        end
      elseif type(ts_cc.update_commentstring) == "function" then
        update_fn = function()
          pcall(ts_cc.update_commentstring, {})
        end
      else
        return
      end

      local group = vim.api.nvim_create_augroup("ContextCommentString", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave", "FileType" }, {
        desc = "Update commentstring based on treesitter context",
        group = group,
        callback = function()
          if vim.bo.buftype == "" then
            update_fn()
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        desc = "Update commentstring after comment actions",
        pattern = "ToggleComment",
        group = group,
        callback = update_fn,
      })

      update_fn()
    end,
  },
}
