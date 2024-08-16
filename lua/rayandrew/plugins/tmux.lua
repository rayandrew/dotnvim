return {
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
    },
    keys = {
      '<C-h>',
      '<C-j>',
      '<C-k>',
      '<C-l>',
      -- { '<leader>wh', '<cmd>TmuxNavigateLeft<cr>', desc = 'Navigate to the left' },
      -- { '<leader>wj', '<cmd>TmuxNavigateDown<cr>', desc = 'Navigate down' },
      -- { '<leader>wk', '<cmd>TmuxNavigateUp<cr>', desc = 'Navigate up' },
      -- { '<leader>wl', '<cmd>TmuxNavigateRight<cr>', desc = 'Navigate to the right' },
    },
    config = function()
      vim.g.tmux_navigator_no_wrap = 1
    end,
  },
}
