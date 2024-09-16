--- [[ Conform ]] commands

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#format-command
vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format { async = true, lsp_fallback = true, range = range }
end, { range = true })

local function run_command(cmd)
  local job_id
  local output = {}

  local function on_stdout(_, data, _)
    if data then
      for _, line in ipairs(data) do
        table.insert(output, line)
      end
    end
  end

  local function on_exit(_, exit_code, _)
    if exit_code == 0 then
      vim.fn.setqflist({}, ' ', {
        title = 'Command Output',
        lines = output,
        efm = '%f:%l:%c: %m',
      })
      vim.cmd 'copen'
    else
      print('Command exited with code ' .. exit_code)
    end
  end

  job_id = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = on_stdout,
    on_exit = on_exit,
  })

  if job_id <= 0 then
    print 'Failed to start job'
  end
end

local function run_shell_command(shell_cmd)
  local job_id
  local output = {}

  local function on_stdout(_, data, _)
    if data then
      for _, line in ipairs(data) do
        -- Trim leading and trailing whitespace
        line = line:gsub('^%s*(.-)%s*$', '%1')
        if line ~= '' then
          table.insert(output, 'shell_output:1:1: ' .. line)
        end
      end
    end
  end

  local function on_exit(_, exit_code, _)
    if exit_code == 0 then
      vim.fn.setqflist({}, ' ', {
        title = 'Shell Command Output',
        lines = output,
        efm = '%f:%l:%c: %m',
      })
      vim.cmd 'copen'
    else
      print('Shell command exited with code ' .. exit_code)
    end
  end

  -- Run the command using a shell
  job_id = vim.fn.jobstart({ 'sh', '-c', shell_cmd }, {
    stdout_buffered = true,
    on_stdout = on_stdout,
    on_exit = on_exit,
  })

  if job_id <= 0 then
    print 'Failed to start job'
  end
end

-- create compile command similar to emacs
vim.api.nvim_create_user_command('Compile', function(args)
  -- get command from args
  -- print(vim.inspect(args))
  local cmd = args.args
  local oil = require 'oil'
  local get_current_dir = oil.get_current_dir(vim.api.nvim_get_current_buf())
  -- local ok, get_current_dir = pcall(require('oil').get_current_dir, vim.api.nvim_get_current_buf())
  -- if not ok then
  --   get_current_dir = vim.fn.getcwd()
  -- end
  local cmd = {
    'cd',
    get_current_dir,
    '&&',
  }

  -- append args.fargs table to cmd_table
  vim.list_extend(cmd, args.fargs)

  local shell_cmd = table.concat(cmd, ' ')
  print('Executing command: ' .. shell_cmd)

  run_shell_command(shell_cmd)

  -- print('Executing command: ' .. table.concat(cmd, ''))

  -- run_command(cmd)
end, {
  nargs = '*',
  desc = 'Run compile command',
})

-- https://www.reddit.com/r/neovim/comments/vnodft/comment/ie87z9r/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
local wr_group = vim.api.nvim_create_augroup('WinResize', { clear = true })

vim.api.nvim_create_autocmd('VimResized', {
  group = wr_group,
  pattern = '*',
  command = 'wincmd =',
  desc = 'Automatically resize windows when the host window size changes.',
})
