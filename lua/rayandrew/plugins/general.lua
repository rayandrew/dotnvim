return {
  { "folke/lazy.nvim", version = "*" },
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  ------------------------------
  --      Color Scheme
  ------------------------------
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },

  {
    "davidosomething/vim-colors-meh",
    name = "meh",
    lazy = true,
  },

  {
    "kvrohit/rasmus.nvim",
    name = "rasmus",
    lazy = true,
  },

  {
    "neanias/everforest-nvim",
    lazy = true,
    name = "everforest",
    opts = {
      background = "hard",
    },
  },

  { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },

  -- {
  --   "f-person/auto-dark-mode.nvim",
  --   config = {
  --     update_interval = 1000,
  --     set_dark_mode = function()
  --       vim.o.background = "dark"
  --       -- vim.api.nvim_set_option("background", "dark")
  --       -- vim.cmd("colorscheme gruvbox")
  --     end,
  --     set_light_mode = function()
  --       vim.o.background = "light"
  --       -- vim.api.nvim_set_option("background", "light")
  --       -- vim.cmd("colorscheme gruvbox")
  --     end,
  --   },
  -- },
}
