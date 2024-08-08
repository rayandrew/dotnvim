return {
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
    },
    keys = { '<C-h>', '<C-j>', '<C-k>', '<C-l>' },
    config = function()
      vim.g.tmux_navigator_no_wrap = 1
    end,
  },
}
