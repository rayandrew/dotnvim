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
      -- vim.cmd.colorscheme 'gruber-darker'
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },

  {
    'Mofiqul/adwaita.nvim',
    lazy = true,
    -- priority = 1000,
    -- configure and set on startup
    config = function()
      -- vim.g.adwaita_darker = true -- for darker version
      -- vim.g.adwaita_disable_cursorline = true -- to disable cursorline
      -- vim.g.adwaita_transparent = true -- makes the background transparent
      -- vim.cmd.colorscheme 'adwaita'
    end,
  },

  {
    'HoNamDuong/hybrid.nvim',
    lazy = true,
    -- priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'hybrid'
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

  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = '', -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
    config = function(_, opts)
      vim.o.background = 'dark'
      vim.cmd.colorscheme 'gruvbox'
      require('gruvbox').setup(opts)
    end,
  },
}
