return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- stylua: ignore
      {
        "<leader>sp",
        function() require("telescope.builtin").live_grep() end,
        desc = "Find in Files (Grep)",
      },
      {
        "<leader>ps",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Find in Files (Grep)",
      },

      {
        "<leader>bb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "List all opened buffers",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ cwd = false })
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find({
            winblend = 10,
            previewer = false,
          })
        end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
}
