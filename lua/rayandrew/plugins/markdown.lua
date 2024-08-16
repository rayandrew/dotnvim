return {
  -- {
  --   'OXY2DEV/markview.nvim',
  --   lazy = true,
  --   ft = 'markdown',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   opts = {
  --     modes = { 'n', 'no', 'i', 'c' },
  --     hybrid_modes = { 'i' },
  --     callbacks = {
  --       on_enable = function(_, win)
  --         vim.wo[win].conceallevel = 2
  --         vim.wo[win].concealcursor = ''
  --       end,
  --     },
  --   },
  -- },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    lazy = true,
    ft = 'markdown',
    opts = {
      enabled = true,
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
}
