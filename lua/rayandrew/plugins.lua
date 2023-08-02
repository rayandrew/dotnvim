local load_textobjects = false

return {
  { "folke/lazy.nvim", version = "*" },
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup.
    -- Configuration for vim plugins typically should be set in an init function
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
    dependencies = { "nvim-lua/plenary.nvim" },
    version = false,
    keys = {
      -- add a keymap to browse plugin files
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
      -- {
      --   "<c-p>",
      --   function()
      --     local Util = require("rayandrew.util")
      --     local fun = Util.telescope("git_files")
      --     fun()
      --   end,
      --   desc = "Find Git Files",
      -- },
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
          -- disable rtp plugin, as we only need its queries for mini.ai
          -- In case other textobject modules are enabled, we will load them
          -- once nvim-treesitter is loaded
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

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>fE",
        function()
          local Util = require("rayandrew.util")
          require("neo-tree.command").execute({
            toggle = true,
            dir = Util.get_root(),
          })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = vim.loop.cwd(),
          })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>E",
        "<leader>fE",
        desc = "Explorer NeoTree (root dir)",
        remap = true,
      },
      {
        "<leader>e",
        "<leader>fe",
        desc = "Explorer NeoTree (cwd)",
        remap = true,
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = {
        "terminal",
        "Trouble",
        "qf",
        "Outline",
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
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
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
      cmdline = {
        enabled = true,
        view = "cmdline",
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },

  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete non-pinned buffers",
      },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("rayandrew.theme").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

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

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local Util = require("rayandrew.util")
      local icons = require("rayandrew.theme").icons

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
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
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              path = 1,
              symbols = { modified = "  ", readonly = "", unnamed = "" },
            },
            -- stylua: ignore
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = Util.fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = Util.fg("Special"),
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
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

  -- lsp symbol navigation for lualine. This shows where
  -- in the code structure you are - within functions, classes,
  -- etc - in the statusline.
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      local Util = require("rayandrew.util")
      vim.g.navic_silence = true
      Util.on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("rayandrew.theme").icons.kinds,
      }
    end,
  },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

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
    -- config = function(_, opts)
    --   require("mason-lspconfig").setup(opts)
    -- end,
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

  -- Copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   build = ":Copilot auth",
  --   opts = {
  --     suggestion = { enabled = false },
  --     panel = { enabled = false },
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --     },
  --   },
  -- },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      -- {
      --   "zbirenbaum/copilot-cmp",
      --   dependencies = "copilot.lua",
      --   enabled = false,
      --   opts = {},
      --   config = function(_, opts)
      --     local Util = require("rayandrew.util")
      --     local copilot_cmp = require("copilot_cmp")
      --     copilot_cmp.setup(opts)
      --     -- attach cmp source whenever copilot attaches
      --     -- fixes lazy-loading issues with the copilot cmp source
      --     Util.on_attach(function(client)
      --       if client.name == "copilot" then
      --         copilot_cmp._on_insert_enter({})
      --       end
      --     end)
      --   end,
      -- },
    },
    config = function()
      require("lsp-zero.cmp").extend()

      local cmp = require("cmp")
      local cmp_action = require("lsp-zero.cmp").action()
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local sorting = require("cmp.config.default")().sorting

      cmp.setup({
        sources = {
          -- { name = "copilot", group_index = 2 },
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
          -- ["<Tab>"] = cmp_action.luasnip_supertab(),
          -- ["<S-Tab>"] = cmp_action.luasnip_supertab(),
          ["<CR>"] = cmp.mapping.confirm({
            -- documentation says this is important.
            -- I don't know why.
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
        }),
        sorting,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
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
      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

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
        -- sources = {
        -- 	nls.builtins.formatting.fish_indent,
        -- 	nls.builtins.diagnostics.fish,
        -- 	nls.builtins.formatting.stylua,
        -- 	nls.builtins.formatting.shfmt,
        -- 	-- nls.builtins.diagnostics.flake8,
        -- },

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
        automatic_installation = false, -- You can still set this to `true`
        handlers = {},
        -- handlers = {
        -- function() end, -- disables automatic setup of all null-ls sources
        --   stylua = function(source_name, methods)
        --     nls.register(nls.builtins.formatting.stylua)
        --   end,
        -- },
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
          -- Match an equals sign and any character after it.
          -- This can also be a table of patterns to cloak,
          -- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
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
        width = 90,
      },
      plugins = {
        tmux = {
          enabled = true,
        },
      },
      on_open = function(_win)
        vim.wo.wrap = false
        vim.wo.number = false
        vim.wo.rnu = false
      end,
      on_close = function()
        vim.wo.wrap = true
        vim.wo.number = true
        vim.wo.rnu = true
      end,
    },
    keys = {
      {
        "<leader>z",
        function()
          -- require("zen-mode").setup({
          --   window = {
          --     width = 90,
          --     options = {},
          --   },
          -- })
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
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
  },

  -- Copilot Lualine
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   -- optional = true,
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     local Util = require("rayandrew.util")
  --     local colors = {
  --       [""] = Util.fg("Special"),
  --       ["Normal"] = Util.fg("Special"),
  --       ["Warning"] = Util.fg("DiagnosticError"),
  --       ["InProgress"] = Util.fg("DiagnosticWarn"),
  --     }
  --     table.insert(opts.sections.lualine_x, 2, {
  --       function()
  --         local icon = require("rayandrew.themes").icons.kinds.Copilot
  --         local status = require("copilot.api").status.data
  --         return icon .. (status.message or "")
  --       end,
  --       cond = function()
  --         local ok, clients =
  --           pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
  --         return ok and #clients > 0
  --       end,
  --       color = function()
  --         if not package.loaded["copilot"] then
  --           return
  --         end
  --         local status = require("copilot.api").status.data
  --         return colors[status.status] or colors[""]
  --       end,
  --     })
  --   end,
  -- },
}
