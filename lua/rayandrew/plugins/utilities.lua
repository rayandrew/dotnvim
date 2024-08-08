------------------------------
--      Utilities
------------------------------

return {
  {
    "nvim-focus/focus.nvim",
    version = "*",
    opts = {},
    cmd = { "FocusToggle", "FocusSplitNicely", "FocusSplitCycle", "FocusSplitCycleReverse" },
    keys = {
      {
        "<space>wf",
        "<cmd>FocusToggle<CR>",
        desc = "Toggle Focus",
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, {
          desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference",
          buffer = buffer,
        })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- comments
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  -- RSI compatibility
  -- {
  --   "tpope/vim-rsi",
  -- },
  {
    "assistcontrol/readline.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<M-f>",
        function()
          require("readline").forward_word()
        end,
        mode = "!",
      },
      {
        "<M-b>",
        function()
          require("readline").backward_word()
        end,
        mode = "!",
      },
      {
        "<M-d>",
        function()
          require("readline").kill_word()
        end,
        mode = "!",
      },
      {
        "<M-BS>",
        function()
          require("readline").backward_kill_word()
        end,
        mode = "!",
      },
      {
        "<C-w>",
        function()
          require("readline").unix_word_rubout()
        end,
        mode = "!",
      },
      {
        "<C-k>",
        function()
          require("readline").kill_line()
        end,
        mode = "!",
      },
      {
        "<C-u>",
        function()
          require("readline").backward_kill_line()
        end,
        mode = "!",
      },
      {
        "<C-a>",
        function()
          require("readline").beginning_of_line()
        end,
        mode = "!",
      },
      {
        "<C-e>",
        function()
          require("readline").end_of_line()
        end,
        mode = "!",
      },
      { "<C-f>", "<Right>", mode = "!" }, -- forward-char
      { "<C-b>", "<Left>", mode = "!" }, -- backward-char
      { "<C-n>", "<Down>", mode = "!" }, -- next-line
      { "<C-p>", "<Up>", mode = "!" }, -- previous-line
      { "<C-d>", "<Delete>", mode = "!" }, -- delete-char
      { "<C-h>", "<BS>", mode = "!" }, -- backward-delete-char
      { "<C-g>", "<Esc>", mode = "!" }, -- abort
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
  },

  {
    "theprimeagen/harpoon",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ha",
        function()
          local mark = require("harpoon.mark")
          mark.add_file()
          vim.print("Added to Harpoon " .. vim.fn.expand("%"))
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>he",
        function()
          local ui = require("harpoon.ui")
          ui.toggle_quick_menu()
        end,
        desc = "Harpoon UI",
      },
      {
        "<leader>h1",
        function()
          local ui = require("harpoon.ui")
          ui.nav_file(1)
        end,
      },
      {
        "<leader>h2",
        function()
          local ui = require("harpoon.ui")
          ui.nav_file(2)
        end,
      },
      {
        "<leader>h3",
        function()
          local ui = require("harpoon.ui")
          ui.nav_file(3)
        end,
      },
      {
        "<leader>h4",
        function()
          local ui = require("harpoon.ui")
          ui.nav_file(4)
        end,
      },
      {
        "<leader>h5",
        function()
          local ui = require("harpoon.ui")
          ui.nav_file(5)
        end,
      },
    },
  },

  {
    "github/copilot.vim",
    init = function()
      -- vim.g.copilot_no_tab_map = true
      -- vim.g.copilot_assume_mapped = true
      -- vim.g.copilot_tab_fallback = ""
      vim.g.copilot_filetypes = {
        ["*"] = true,
        ["text"] = false,
      }
    end,
  },

  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>n"] = { name = "+note" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  -- zen
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 100,
      },
      plugins = {
        tmux = {
          enabled = true,
        },
      },
      on_open = function()
        vim.wo.wrap = false
        vim.wo.number = false
        vim.wo.rnu = false
        vim.wo.signcolumn = "no"
      end,
      on_close = function()
        vim.wo.wrap = true
        vim.wo.number = true
        vim.wo.rnu = true
        vim.wo.signcolumn = "yes"
      end,
    },
    keys = {
      {
        "<leader>z",
        function()
          require("zen-mode").toggle()
          require("rayandrew.theme").recolor()
        end,
      },
    },
  },

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

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Replace in files (Spectre)",
      },
    },
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  {
    "tpope/vim-dispatch",
    commands = { "Make", "Dispatch", "Copen" },
    keys = {
      {
        "<leader>cc",
        function()
          local input = vim.fn.input("Command: ")
          vim.cmd("Dispatch " .. input)
        end,
        desc = "AsyncRun",
      },
      { "<leader>ck", desc = "AsyncStop" },
    },
  },
}
