local function get_comment_spec()
  local ok, ts_comments = pcall(require, "ts-comments.comments")
  if not ok then
    vim.notify("ts-comments.nvim is required for commenting", vim.log.levels.WARN)
    return
  end

  local cs = ts_comments.get(vim.bo.filetype)
  if not cs or cs == "" then
    vim.notify("ts-comments.nvim: no commentstring available", vim.log.levels.WARN)
    return
  end

  local left, right = cs:match("^(.*)%%s(.*)$")
  if not left then
    vim.notify("ts-comments.nvim: invalid commentstring " .. cs, vim.log.levels.WARN)
    return
  end

  return cs, left, right
end

local function is_commented(line, left, right)
  local _, rest = line:match("^(%s*)(.*)$")
  rest = rest or ""
  if rest == "" then
    return false
  end
  if right ~= "" and rest:sub(-#right) ~= right then
    return false
  end
  return rest:sub(1, #left) == left
end

local function apply_comment(line, cs, left, right, uncomment)
  local indent, rest = line:match("^(%s*)(.*)$")
  indent = indent or ""
  rest = rest or ""

  if uncomment then
    if not is_commented(line, left, right) then
      return line
    end
    local new_rest = rest
    if right ~= "" then
      new_rest = new_rest:sub(1, #new_rest - #right)
    end
    new_rest = new_rest:sub(#left + 1)
    return indent .. new_rest
  end

  if is_commented(line, left, right) then
    return line
  end

  return indent .. cs:gsub("%%s", rest)
end

local function toggle_lines(start_line, end_line)
  local cs, left, right = get_comment_spec()
  if not cs then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  if #lines == 0 then
    return
  end

  local should_uncomment = true
  for _, line in ipairs(lines) do
    if not is_commented(line, left, right) then
      should_uncomment = false
      break
    end
  end

  for idx, line in ipairs(lines) do
    lines[idx] = apply_comment(line, cs, left, right, should_uncomment)
  end

  vim.api.nvim_buf_set_lines(0, start_line, end_line, false, lines)
end

local function toggle_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  toggle_lines(row, row + 1)
end

local function toggle_visual_lines()
  local start_mark = vim.api.nvim_buf_get_mark(0, '<')
  local end_mark = vim.api.nvim_buf_get_mark(0, '>')

  if start_mark[1] == 0 or end_mark[1] == 0 then
    return
  end

  local start_line = math.min(start_mark[1], end_mark[1]) - 1
  local end_line = math.max(start_mark[1], end_mark[1])

  local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'nx', false)

  toggle_lines(start_line, end_line)
end

local function floating_rename()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local supports = false
  for _, client in ipairs(clients) do
    if client.server_capabilities and client.server_capabilities.renameProvider then
      supports = true
      break
    end
  end

  if not supports then
    vim.notify('No attached LSP server supports rename', vim.log.levels.WARN)
    return
  end

  local current_name = vim.fn.expand('<cword>')
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'prompt')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'lsp_rename_prompt')

  local float_opts = {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = math.max(30, #current_name + 12),
    height = 1,
    style = 'minimal',
    border = 'rounded',
    title = ' Rename Symbol ',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, float_opts)
  vim.fn.prompt_setprompt(buf, 'New name: ')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { current_name })
  vim.api.nvim_win_set_cursor(win, { 1, #current_name })

  local function close_window()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.fn.prompt_setcallback(buf, function(new_name)
    new_name = vim.trim(new_name or '')
    close_window()
    if new_name == '' or new_name == current_name then
      return
    end
    vim.schedule(function()
      vim.lsp.buf.rename(new_name)
    end)
  end)

  vim.fn.prompt_setinterrupt(buf, function()
    close_window()
  end)

  vim.keymap.set('n', '<Esc>', close_window, { buffer = buf, nowait = true })
  vim.keymap.set('i', '<Esc>', close_window, { buffer = buf, nowait = true })

  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = buf,
    once = true,
    callback = close_window,
  })

  vim.cmd('startinsert!')
end

return {
  -- LSP operations and code actions
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>;", toggle_current_line, desc = "Comment out line" },
      { "<leader>;", toggle_visual_lines, mode = "x", desc = "Comment out lines" },
      { "<leader>cc", "<cmd>make<cr>", desc = "Compile" },
      { "<leader>cd", vim.lsp.buf.definition, desc = "Jump to definition" },
      { "<leader>cD", vim.lsp.buf.references, desc = "See references" },
      { "<leader>ck", vim.lsp.buf.hover, desc = "Jump to documentation" },
      { "<leader>cr", floating_rename, desc = "Rename all references" },
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
      { "]e", function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, desc = "Next error" },
      { "[e", function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, desc = "Previous error" },
      { "]w", function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
      end, desc = "Next warning/spell issue" },
      { "[w", function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
      end, desc = "Previous warning/spell issue" },
      { "]h", function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.HINT })
      end, desc = "Next hint/spell issue" },
      { "[h", function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.HINT })
      end, desc = "Previous hint/spell issue" },
    },
  },
}
