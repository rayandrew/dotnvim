local M = {}

local create_lazygit = function(direction)
  local Terminal = require('toggleterm.terminal').Terminal
  local utils = require 'rayandrew.utils'

  local lazygit = Terminal:new {
    cmd = 'lazygit',
    hidden = true,
    direction = direction,
    dir = utils.get_project_root(),
    float_opts = {
      border = 'double',
    },

    on_open = function(term)
      vim.cmd 'startinsert!'
      vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<esc>', '<esc>', { noremap = true, silent = true, nowait = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-[>', '<esc>', { noremap = true, silent = true, nowait = true })

      -- vim.keymap.set('t', '<esc>', '<esc>', { buffer = buf, nowait = true })
    end,
    -- function to run on closing the terminal
    on_close = function(_)
      vim.cmd 'startinsert!'
    end,
  }
  return lazygit
end

function M.lazygit()
  local lazygit = create_lazygit 'vertical'
  lazygit:toggle()
end

function M.lazygit_float()
  local lazygit = create_lazygit 'float'
  lazygit:toggle()
  -- require('rayandrew.utils').float_term({ 'lazygit' }, { esc_esc = false, ctrl_hjkl = false })
end

return M
