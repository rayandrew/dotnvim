return {
  {
    'stevearc/aerial.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>ta', '<cmd>AerialToggle<cr>', desc = '[T]oggle [A]erial' },
    },
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
}
