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

  ------------------------------
  --         Telescope
  ------------------------------
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
          local fun = Util.telescope("live_grep")
          fun()
        end,
        desc = "Find in Files (Grep)",
      },
      {
        "<leader>ps",
        function()
          local Util = require("rayandrew.util")
          local fun = Util.telescope("grep_string", {
            search = vim.fn.input("Grep > "),
          })
          fun()
        end,
        desc = "Find in Files (Grep)",
      },
      {
        "<leader>bb",
        function()
          local Util = require("rayandrew.util")
          local fun = Util.telescope("buffers")
          fun()
        end,
        desc = "List all opened buffers",
      },
      {
        "<leader>fF",
        function()
          local Util = require("rayandrew.util")
          local fun = Util.telescope("files")
          fun()
        end,
        desc = "Find Files (root dir)",
      },
      {
        "<leader>ff",
        function()
          local Util = require("rayandrew.util")
          local fun = Util.telescope("files", { cwd = false })
          fun()
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fh",
        function()
          local Util = require("rayandrew.util")
          local fun = Util.telescope("files", { cwd = false, hidden = true })
          fun()
        end,
        desc = "Find Files with Hidden (cwd)",
      },
      {
        "<space>sm",
        function()
          local Util = require("rayandrew.util")
          local fun = Util.telescope("man_pages")
          fun()
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
          local fun = Util.telescope("current_buffer_fuzzy_find", {
            winblend = 10,
            previewer = false,
          })
          fun()
        end,
      },
      {
        "<space>sd",
        function()
          local Util = require("rayandrew.util")
          local fun = Util.telescope("diagnostics")
          fun()
        end,
      },
    },
  },

  ------------------------------
  --         TreeSitter
  ------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          load_textobjects = true
        end,
      },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "query",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    cmd = { "TSUpdateSync" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)

      if load_textobjects then
        -- PERF: no need to load the plugin, if we only need its queries for mini.ai
        if opts.textobjects then
          for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
            if opts.textobjects[mod] and opts.textobjects[mod].enable then
              local Loader = require("lazy.core.loader")
              Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
              local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
              require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
              break
            end
          end
        end
      end
    end,
  },
  {
    "nvim-treesitter/playground",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },

  ------------------------------
  --      Color Scheme
  ------------------------------
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },

  ------------------------------
  --     File Management
  ------------------------------

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Oil" },
    keys = {
      {
        "<leader>e",
        function()
          -- disable in oil filetype
          if vim.bo.filetype == "oil" then
            return
          end
          require("oil").open()
        end,
        desc = "Open current directory",
      },
      {
        "<leader>E",
        function()
          -- disable in oil filetype
          if vim.bo.filetype == "oil" then
            return
          end
          require("oil").open(".")
        end,
        desc = "Open current directory",
      },
    },
    opts = {
      default_file_explorer = true,
      restore_win_options = true,
    },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("oil")
        end
      end
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
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = {
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
      buftype_exclude = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  { "kevinhwang91/nvim-bqf", ft = "qf" },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  ------------------------------
  --     LSP Configuration
  ------------------------------

  -- Mason
  {
    "williamboman/mason-lspconfig.nvim",
    name = "mason-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", lazy = true },
      { "neovim/nvim-lspconfig", lazy = true },
    },
    opts = {
      ensure_installed = {
        "clangd",
        "pyright",
        -- "rnix",
        "rust_analyzer",
        "texlab",
        "lua_ls",
        "tsserver",
      },
    },
  },

  -- LSP Zero
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    lazy = true,
    config = function()
      require("lsp-zero.settings").preset("recommended")
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        -- event = "InsertEnter",
        config = function()
          local luasnip = require("luasnip")
          require("luasnip.loaders.from_vscode").lazy_load()
          luasnip.config.setup({})
        end,
      },
      { "rafamadriz/friendly-snippets" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
    },
    config = function()
      require("lsp-zero.cmp").extend()

      local cmp = require("cmp")
      local cmp_action = require("lsp-zero.cmp").action()
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local sorting = require("cmp.config.default")().sorting

      cmp.setup({
        sources = {
          { name = "nvim_lsp", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "luasnip", group_index = 2 },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = nil,
          ["<S-Tab>"] = nil,
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
        }),
        sorting,
        snippet = {
          expand = function(args)
            local luasnip = require("luasnip")
            luasnip.lsp_expand(args.body)
          end,
        },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      { "williamboman/mason.nvim" },
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      { "folke/neodev.nvim", opts = {} },
      {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        opts = {},
      },
    },
    config = function()
      local lsp = require("lsp-zero")

      lsp.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }

        lsp.default_keymaps({ buffer = bufnr })

        vim.keymap.set("n", "gd", function()
          vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover()
        end, opts)
        vim.keymap.set("n", "<leader>vws", function()
          vim.lsp.buf.workspace_symbol()
        end, opts)
        vim.keymap.set("n", "<leader>vd", function()
          vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.goto_next()
        end, opts)
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.goto_prev()
        end, opts)
        vim.keymap.set("n", "<leader>ca", function()
          vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>vrr", function()
          vim.lsp.buf.references()
        end, opts)
        vim.keymap.set("n", "<leader>vrn", function()
          vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("i", "<C-h>", function()
          vim.lsp.buf.signature_help()
        end, opts)
      end)

      -- (Optional) Configure lua language server for neovim
      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      }))

      require("lspconfig").clangd.setup({
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
        },
      })

      lsp.set_preferences({
        suggest_lsp_servers = false,
        sign_icons = {
          error = "E",
          warn = "W",
          hint = "H",
          info = "I",
        },
      })

      lsp.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 10000,
        },
        servers = {
          ["null-ls"] = { "javascript", "typescript", "lua", "python" },
        },
      })

      lsp.set_server_config({
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
      })

      lsp.setup()

      vim.diagnostic.config({
        virtual_text = true,
      })
    end,
  },

  ------------------------------
  --      Formatter
  ------------------------------
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = function()
      local nls = require("null-ls")

      return {
        ensure_installed = {
          "taplo",

          "prettier",
          "eslint_d",

          "black",
          "isort",

          "shfmt",
          "jq",

          "stylua",

          "nixpkgs_fmt",

          "latexindent",
        },
        automatic_installation = false,
        handlers = {},
      }
    end,
    config = function(_, opts)
      local nls = require("null-ls")
      nls.setup({
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.completion.spell,
          nls.builtins.code_actions.gitsigns,

          -- web
          nls.builtins.formatting.prettier.with({
            extra_filetypes = { "svelte" },
          }), -- js/ts formatter
          nls.builtins.diagnostics.eslint_d.with({
            -- js/ts linter
            -- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
            condition = function(utils)
              return utils.root_has_file(".eslintrc.js") or utils.root_has_file(".eslintrc.cjs")
            end,
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "svelte",
            },
          }),
          nls.builtins.code_actions.eslint_d.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "svelte",
            },
          }),

          -- python
          nls.builtins.formatting.black,
          nls.builtins.formatting.isort,

          -- shell
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.jq,

          -- rust
          nls.builtins.formatting.rustfmt,

          -- nix
          nls.builtins.formatting.nixpkgs_fmt,

          -- config
          nls.builtins.formatting.taplo,

          -- lua
          nls.builtins.formatting.stylua,

          -- latex
          nls.builtins.formatting.latexindent,
        },
      })
      require("mason-null-ls").setup(opts)
    end,
  },

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
    "linty-org/readline.nvim",
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
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
  },

  {
    "laytan/cloak.nvim",
    event = {
      "BufEnter .env*",
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
            ".env*",
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

  {
    "skywind3000/asyncrun.vim",
    cmd = { "AsyncRun", "AsyncStop" },
    keys = {
      {
        "<leader>cc",
        function()
          local input = vim.fn.input("Command: ")
          vim.cmd("AsyncRun " .. input)
          -- vim.cmd("sleep 1")
          -- vim.cmd("copen")
        end,
        desc = "AsyncRun",
      },
      { "<leader>ck", desc = "AsyncStop" },
    },
    config = function()
      vim.g.asyncrun_open = 6
    end,
  },

  -- Folke
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

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

  -- Flash Telescope config
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
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
  },
}
