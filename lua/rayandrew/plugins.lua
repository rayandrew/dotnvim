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
        "latex",
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
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
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

  -- {
  --   "stevearc/oil.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   cmd = { "Oil" },
  --   keys = {
  --     {
  --       "<leader>e",
  --       function()
  --         -- disable in oil filetype
  --         if vim.bo.filetype == "oil" then
  --           return
  --         end
  --         require("oil").open_float()
  --       end,
  --       desc = "Open current directory",
  --     },
  --     {
  --       "<leader>E",
  --       function()
  --         -- disable in oil filetype
  --         if vim.bo.filetype == "oil" then
  --           return
  --         end
  --         require("oil").open(".")
  --       end,
  --       desc = "Open current directory",
  --     },
  --   },
  --   opts = {
  --     columns = {
  --       -- "icon",
  --       -- "permissions",
  --       -- "size",
  --       -- "mtime",
  --     },
  --     default_file_explorer = true,
  --     restore_win_options = true,
  --     float = {
  --       padding = 2,
  --       max_width = 240,
  --       max_height = 70,
  --       -- width = 0.2,
  --       -- max_height = 0.5,
  --       border = "rounded",
  --       win_options = {
  --         winblend = 10,
  --       },
  --     },
  --     keymaps = {
  --       ["<C-i>"] = {
  --         callback = function()
  --           if vim.bo.filetype == "oil" then
  --             local oil = require("oil")
  --             vim.g.oil_show_info = not vim.g.oil_show_info
  --             if vim.g.oil_show_info then
  --               oil.set_columns({
  --                 "permissions",
  --                 "size",
  --                 "mtime",
  --                 "icon",
  --               })
  --             else
  --               oil.set_columns({})
  --             end
  --             return
  --           end
  --         end,
  --         desc = "Toggle info",
  --       },
  --       ["q"] = "actions.close",
  --       ["<C-h>"] = "actions.toggle_hidden",
  --       ["?"] = "actions.show_help",
  --     },
  --   },
  --   init = function()
  --     vim.g.oil_show_info = false
  --     -- if vim.fn.argc() == 1 then
  --     --   local stat = vim.loop.fs_stat(vim.fn.argv(0))
  --     --   if stat and stat.type == "directory" then
  --     --     require("oil")
  --     --   end
  --     -- end
  --   end,
  -- },

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
          { name = "neorg", group_index = 2 },
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
        -- local opts = { buffer = bufnr, remap = false }

        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, remap = false })
        end

        lsp.default_keymaps({ buffer = bufnr })

        -- stylua: ignore start
        nmap("gd", function() vim.lsp.buf.definition() end, "Goto Definition")
        nmap("<leader>ws", function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, "Workspace Symbol")
        nmap("<leader>ds", function() require('telescope.builtin').lsp_document_symbols() end, "Document Symbol")
        nmap("<leader>df", function() vim.diagnostic.open_float() end, "Diagnostic Float")
        nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
        nmap("[d", function() vim.diagnostic.goto_next() end, "Next Diagnostic")
        nmap("]d", function() vim.diagnostic.goto_prev() end, "Prev Diagnostic")
        nmap("<leader>ca", function() vim.lsp.buf.code_action() end, "Code Action")
        nmap("<leader>vrr", function() vim.lsp.buf.references() end, "References")
        nmap("<leader>rn", function() vim.lsp.buf.rename() end, "Rename")

        nmap("K", function() vim.lsp.buf.hover() end, "Hover")
        -- nmap("<C-k>", function() vim.lsp.buf.signature_help() end, "Signature Help")

        nmap("gD", function() vim.lsp.buf.declaration() end, "Goto Declaration")
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
        -- stylua: ignore end
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
          ["null-ls"] = { "javascript", "typescript", "lua", "python", "nix" },
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

          -- "black",
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
          -- nls.builtins.formatting.black,
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
}
