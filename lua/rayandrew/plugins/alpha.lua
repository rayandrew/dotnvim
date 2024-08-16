return {
  {
    'goolord/alpha-nvim',
    lazy = false,
    priority = 100,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('alpha').setup(require('alpha.themes.theta').config)
    end,
  },
}
