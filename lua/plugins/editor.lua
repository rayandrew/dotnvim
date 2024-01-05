return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- stylua: ignore
    keys = {{"<leader>E",function() vim.cmd("Neotree toggle position=current") end, desc = "Toggle NeoTree as Buffer" }},
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_current",
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          -- ["C"] = "copy",
          ["C"] = {
            "copy",
            config = {
              show_path = "absolute", -- "none", "relative", "absolute"
            },
          },
          ["r"] = "refresh",
          ["R"] = "rename",
          ["y"] = function(state)
            local node = state.tree:get_node()
            -- get relative path
            local filepath = node:get_id()
            local filename = vim.fn.fnamemodify(filepath, ":.")
            -- local filename = node.name
            vim.fn.setreg("+", filename)
            vim.notify("Copied: " .. filename)
          end,
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            vim.fn.setreg("+", filepath)
            vim.notify("Copied: " .. filepath)
          end,
          ["O"] = {
            command = function(state)
              local node = state.tree:get_node()
              local filepath = node.path
              local osType = os.getenv("OS")

              local command

              if osType == "Windows_NT" then
                command = "start " .. filepath
              elseif osType == "Darwin" then
                command = "open " .. filepath
              else
                command = "xdg-open " .. filepath
              end
              os.execute(command)
            end,
            desc = "open_with_system_defaults",
          },
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

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })

      -- local has_words_before = function()
      --   unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      -- end
      --
      -- local luasnip = require("luasnip")
      -- local cmp = require("cmp")

      -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
      --   ["<Tab>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       -- cmp.select_next_item()
      --       cmp.confirm({ select = true })
      --     elseif luasnip.expand_or_jumpable() then
      --       luasnip.expand_or_jump()
      --     elseif has_words_before() then
      --       cmp.complete()
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      --   ["<S-Tab>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       cmp.select_prev_item()
      --     elseif luasnip.jumpable(-1) then
      --       luasnip.jump(-1)
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      -- })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
}
