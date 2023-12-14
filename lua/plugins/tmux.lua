return {
  -- Tmux
  {
    "mrjones2014/smart-splits.nvim",
    lazy = true,
    -- event = "VeryLazy",
    dependencies = {
      {
        "kwkarlwang/bufresize.nvim",
        opts = {},
      },
    },
    config = function()
      require("smart-splits").setup({
        resize_mode = {
          hooks = {
            on_leave = require("bufresize").register,
          },
        },
      })
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    config = function()
      vim.g.tmux_navigator_no_wrap = 1
    end,
  },
}
