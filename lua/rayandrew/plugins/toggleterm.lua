return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.5
        end
      end,
      on_open = function(_)
        vim.cmd 'startinsert!'
        -- vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<esc>', '<esc>', { noremap = true, silent = true, nowait = true })
        -- vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-[>', '<esc>', { noremap = true, silent = true, nowait = true })
      end,
    },
    config = true,
  },
}
