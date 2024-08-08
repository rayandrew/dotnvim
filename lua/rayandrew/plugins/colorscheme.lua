return {
  {
    'thimc/gruber-darker.nvim',
    lazy = true,
    -- priority = 1000,
    opts = {
      transparent = true,
    },
    config = function(_, opts)
      require('gruber-darker').setup(opts)
      vim.cmd.colorscheme 'gruber-darker'
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  {
    'Mofiqul/adwaita.nvim',
    lazy = true,
    -- priority = 1000,
    -- configure and set on startup
    config = function()
      vim.g.adwaita_darker = true -- for darker version
      vim.g.adwaita_disable_cursorline = true -- to disable cursorline
      vim.g.adwaita_transparent = true -- makes the background transparent
      -- vim.cmd.colorscheme 'adwaita'
    end,
  },

  {
    'HoNamDuong/hybrid.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'hybrid'
    end,
  },

  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    -- priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'kanagawa-dragon'
    end,
  },
}
