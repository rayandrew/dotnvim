local load_textobjects = false

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

  ------------------------------
  --      User Interface
  ------------------------------

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("rayandrew.theme").icons
      local Util = require("rayandrew.util")

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str:sub(1, 1)
              end,
            },
          },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_x = {
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {},
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      indent = {
        char = "│",
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "qf",
        },
        buftypes = {
          "terminal",
          "nofile",
          "quickfix",
          "prompt",
        },
      },
      scope = {
        enabled = true,
      },
      -- show_trailing_blankline_indent = false,
    },
  },

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  ------------------------------
  --     LSP Configuration
  ------------------------------

  -- -- Mason
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   name = "mason-lspconfig",
  --   dependencies = {
  --     { "williamboman/mason.nvim", lazy = true },
  --     { "neovim/nvim-lspconfig", lazy = true },
  --   },
  --   opts = {
  --     ensure_installed = {
  --       "clangd",
  --       "pyright",
  --       -- "rnix",
  --       "rust_analyzer",
  --       "texlab",
  --       "lua_ls",
  --       "tsserver",
  --     },
  --   },
  -- },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  ------------------------------
  --      Formatter
  ------------------------------
  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "jose-elias-alvarez/null-ls.nvim",
  --   },
  --   opts = function()
  --     local nls = require("null-ls")
  --
  --     return {
  --       ensure_installed = {
  --         "taplo",
  --
  --         "prettier",
  --         "eslint_d",
  --
  --         "black",
  --         "isort",
  --
  --         "shfmt",
  --         "jq",
  --
  --         "stylua",
  --
  --         "nixpkgs_fmt",
  --
  --         "latexindent",
  --       },
  --       automatic_installation = false,
  --       handlers = {},
  --     }
  --   end,
  --   config = function(_, opts)
  --     local nls = require("null-ls")
  --     nls.setup({
  --       root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
  --       sources = {
  --         nls.builtins.completion.spell,
  --         nls.builtins.code_actions.gitsigns,
  --
  --         -- web
  --         nls.builtins.formatting.prettier.with({
  --           extra_filetypes = { "svelte" },
  --         }), -- js/ts formatter
  --         nls.builtins.diagnostics.eslint_d.with({
  --           -- js/ts linter
  --           -- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
  --           condition = function(utils)
  --             return utils.root_has_file(".eslintrc.js") or utils.root_has_file(".eslintrc.cjs")
  --           end,
  --           filetypes = {
  --             "javascript",
  --             "javascriptreact",
  --             "typescript",
  --             "typescriptreact",
  --             "vue",
  --             "svelte",
  --           },
  --         }),
  --         nls.builtins.code_actions.eslint_d.with({
  --           filetypes = {
  --             "javascript",
  --             "javascriptreact",
  --             "typescript",
  --             "typescriptreact",
  --             "vue",
  --             "svelte",
  --           },
  --         }),
  --
  --         -- python
  --         -- nls.builtins.formatting.black,
  --         nls.builtins.formatting.isort,
  --
  --         -- shell
  --         nls.builtins.formatting.shfmt,
  --         nls.builtins.formatting.jq,
  --
  --         -- rust
  --         nls.builtins.formatting.rustfmt,
  --
  --         -- nix
  --         nls.builtins.formatting.nixpkgs_fmt,
  --
  --         -- config
  --         nls.builtins.formatting.taplo,
  --
  --         -- lua
  --         nls.builtins.formatting.stylua,
  --
  --         -- latex
  --         nls.builtins.formatting.latexindent,
  --       },
  --     })
  --     require("mason-null-ls").setup(opts)
  --   end,
  -- },

  ------------------------------
  --      Utilities
  ------------------------------

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
    "simrat39/symbols-outline.nvim",
    opts = {},
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    keys = {
      { "<leader>so", "<cmd>SymbolsOutline<CR>", desc = "Symbols Outline" },
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
  {
    "tpope/vim-rsi",
  },
  -- {
  --   "assistcontrol/readline.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     {
  --       "<M-f>",
  --       function()
  --         require("readline").forward_word()
  --       end,
  --       mode = "!",
  --     },
  --     {
  --       "<M-b>",
  --       function()
  --         require("readline").backward_word()
  --       end,
  --       mode = "!",
  --     },
  --     {
  --       "<M-d>",
  --       function()
  --         require("readline").kill_word()
  --       end,
  --       mode = "!",
  --     },
  --     {
  --       "<M-BS>",
  --       function()
  --         require("readline").backward_kill_word()
  --       end,
  --       mode = "!",
  --     },
  --     {
  --       "<C-w>",
  --       function()
  --         require("readline").unix_word_rubout()
  --       end,
  --       mode = "!",
  --     },
  --     {
  --       "<C-k>",
  --       function()
  --         require("readline").kill_line()
  --       end,
  --       mode = "!",
  --     },
  --     {
  --       "<C-u>",
  --       function()
  --         require("readline").backward_kill_line()
  --       end,
  --       mode = "!",
  --     },
  --     {
  --       "<C-a>",
  --       function()
  --         require("readline").beginning_of_line()
  --       end,
  --       mode = "!",
  --     },
  --     {
  --       "<C-e>",
  --       function()
  --         require("readline").end_of_line()
  --       end,
  --       mode = "!",
  --     },
  --     { "<C-f>", "<Right>", mode = "!" }, -- forward-char
  --     { "<C-b>", "<Left>", mode = "!" }, -- backward-char
  --     { "<C-n>", "<Down>", mode = "!" }, -- next-line
  --     { "<C-p>", "<Up>", mode = "!" }, -- previous-line
  --     { "<C-d>", "<Delete>", mode = "!" }, -- delete-char
  --     { "<C-h>", "<BS>", mode = "!" }, -- backward-delete-char
  --   },
  -- },

  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
  },

  {
    "laytan/cloak.nvim",
    event = {
      "BufEnter .env",
      "BufEnter .env.*",
    },
    cmd = {
      "CloakEnable",
      "CloakDisable",
      "CloakToggle",
    },
    opts = {
      enabled = true,
      cloak_character = "*",
      -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
      highlight_group = "Comment",
      patterns = {
        {
          file_pattern = {
            ".env",
            ".env.*",
            ".dev.vars",
          },
          cloak_pattern = "=.+",
        },
      },
    },
    config = function(_, opts)
      require("cloak").setup(opts)
    end,
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
    "theprimeagen/refactoring.nvim",
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
    "eandrju/cellular-automaton.nvim",
  },

  {
    "laytan/cloak.nvim",
  },

  {
    "mbbill/undotree",
  },

  -- {
  --   "skywind3000/asyncrun.vim",
  --   cmd = { "AsyncRun", "AsyncStop" },
  --   keys = {
  --     {
  --       "<leader>cc",
  --       function()
  --         local input = vim.fn.input("Command: ")
  --         vim.cmd("AsyncRun " .. input)
  --         -- vim.cmd("sleep 1")
  --         -- vim.cmd("copen")
  --       end,
  --       desc = "AsyncRun",
  --     },
  --     { "<leader>ck", desc = "AsyncStop" },
  --   },
  --   config = function()
  --     vim.g.asyncrun_open = 6
  --   end,
  -- },

  -- Folke
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>xx",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
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

  ------------------------------
  --        Note Taking
  ------------------------------

  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
    },
    cond = function()
      return vim.fn.isdirectory(vim.fn.expand("~/Notes")) == 1
    end,
    event = "VeryLazy",
    cmd = { "Neorg" },
    keys = {
      {
        "<leader>na",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("files", {
            prompt_title = "Neorg",
            cwd = "~/Notes",
          })
          fn()
        end,
        desc = "Find Notes",
      },
      {
        "<leader>fn",
        function()
          vim.cmd("Telescope neorg find_norg_files")
        end,
        desc = "Find Notes",
      },
      {
        "<leader>nf",
        "<leader>fn",
        desc = "Find Notes",
        remap = true,
      },
      {
        "<leader>sn",
        function()
          local Util = require("rayandrew.util")
          local fn = Util.telescope("live_grep", {
            prompt_title = "Neorg Grep",
            cwd = "~/Notes",
          })
          fn()
        end,
        desc = "Search Notes",
      },
    },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/Notes",
            },
            default_workspace = "notes",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.clipboard"] = {},
        ["core.clipboard.code-blocks"] = {},
        ["core.integrations.telescope"] = {},
      },
    },
    config = function(_, opts)
      require("neorg").setup(opts)
      local neorg_callbacks = require("neorg.core.callbacks")

      neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
        keybinds.map_event_to_mode("norg", {
          n = {
            { "<c-f>", "core.integrations.telescope.find_linkable" },
            { "<c-o>", "core.integrations.telescope.insert_link" },
            { "<c-s>", "core.integrations.telescope.search_headings" },
            { "<c-p>", "core.integrations.telescope.insert_file_link" },
          },

          i = {},
        }, {
          silent = true,
          noremap = true,
        })
      end)
    end,
  },

  {
    "jbyuki/venn.nvim",
    keys = {
      {
        "<leader>nv",
        function()
          function Toggle_venn()
            local venn_enabled = vim.inspect(vim.b.venn_enabled)
            if venn_enabled == "nil" then
              vim.b.venn_enabled = true
              vim.cmd([[setlocal ve=all]])
              -- draw a line on HJKL keystokes
              vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
              vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
              vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
              vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
              -- draw a box by pressing "f" with visual selection
              vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
            else
              vim.cmd([[setlocal ve=]])
              vim.cmd([[mapclear <buffer>]])
              vim.b.venn_enabled = nil
            end
          end

          Toggle_venn()
        end,
        desc = "Open Venn panel",
      },
    },
  },

  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
    ft = "markdown",
    keys = {
      {
        "<leader>pm",
        "<cmd>Glow<cr>",
        desc = "Preview Markdown",
      },
    },
  },

  {
    "jbyuki/nabla.nvim",
    lazy = true,
    -- ft = { "tex", "latex", "markdown" },
    -- opts = {
    --   autogen = true, -- auto-regenerate ASCII art when exiting insert mode
    --   silent = true, -- silents error messages
    -- },
    -- config = function()
    --   local nabla = require("nabla")
    --   nabla.enable_virt()
    -- end,
    keys = {
      {
        "<leader>pe",
        function()
          require("nabla").toggle_virt()
        end,
        desc = "Preview Math Equation",
      },
    },
  },

  {
    "lervag/vimtex",
    config = function()
      -- vim.g.vimtex_compiler_progname = "nvr"
      -- vim.g.vimtex_view_method = "zathura"
    end,
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

  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    config = function()
      require("distant"):setup()
    end,
  },

  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
    },
    config = true,
  },
}
