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

  { "neanias/everforest-nvim", lazy = true, name = "everforest", opts = {
    background = "hard",
  } },
}
