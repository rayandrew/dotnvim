------------------------------
--         Telescope        --
------------------------------

return {

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    version = false,
    opts = {
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                actions.delete_buffer(prompt_bufnr)
                actions.move_to_top(prompt_bufnr)
              end,
              ["<c-u>"] = false,
            },
            n = {
              ["d"] = "delete_buffer",
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>sp",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("live_grep")
          fn()
        end,
        desc = "Find in Files (Grep)",
      },
      {
        "<leader>ps",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("grep_string", {
            search = vim.fn.input("Grep > "),
          })
          fn()
        end,
        desc = "Find in Files (Grep)",
      },
      {
        "<leader>bb",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("buffers")
          fn()
        end,
        desc = "List all opened buffers",
      },
      {
        "<leader>fF",
        function()
          local utils = require("telescope.utils")
          local Util = require("rayandrew.util")
          local fn = Util.telescope("files", { cwd = utils.buffer_dir() })
          fn()
        end,
        desc = "Find Files (root dir)",
      },
      {
        "<leader>ff",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("files", { cwd = false })
          fn()
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fh",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("files", { cwd = false, hidden = true })
          fn()
        end,
        desc = "Find Files with Hidden (cwd)",
      },
      {
        "<space>sm",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("man_pages")
          fn()
        end,
        desc = "Find Manual",
      },
      {
        "<space>sh",
        function()
          local Util = require("rayandrew.util")
          local fun = Util.telescope("help_tags")
          fun()
        end,
        desc = "Find Help Tags",
      },
      {
        "<space>/",
        function()
          -- require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          --   winblend = 10,
          --   previewer = false,
          -- }))
          local Util = require("rayandrew.util")
          local fn = Util.telescope("current_buffer_fuzzy_find", {
            winblend = 10,
            previewer = false,
          })
          fn()
        end,
      },
      {
        "<space>sd",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("diagnostics")
          fn()
        end,
      },
    },
  },
}
