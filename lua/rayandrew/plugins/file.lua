return {
  ------------------------------
  --     File Management
  ------------------------------

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
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
    keys = {
      -- {
      --   "<leader>E",
      --   function()
      --     vim.cmd("Neotree toggle position=current")
      --   end,
      --   desc = "Toggle NeoTree as Buffer",
      -- },
      {
        "<leader>fe",
        function()
          vim.cmd("Neotree toggle")
        end,
        desc = "Toggle NeoTree",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    -- init = function()
    --   if vim.fn.argc(-1) == 1 then
    --     local stat = vim.loop.fs_stat(vim.fn.argv(0))
    --     if stat and stat.type == "directory" then
    --       require("neo-tree")
    --     end
    --   end
    -- end,
    config = function(_, opts)
      local function on_move(data)
        Util.lsp.on_rename(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
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

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Oil" },
    keys = {
      -- {
      --   "<leader>e",
      --   function()
      --     -- disable in oil filetype
      --     if vim.bo.filetype == "oil" then
      --       return
      --     end
      --     require("oil").open_float()
      --   end,
      --   desc = "Open current directory",
      -- },
      {
        "<leader>fE",
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
      columns = {
        -- "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      default_file_explorer = true,
      restore_win_options = true,
      float = {
        padding = 2,
        max_width = 240,
        max_height = 70,
        -- width = 0.2,
        -- max_height = 0.5,
        border = "rounded",
        win_options = {
          winblend = 10,
        },
      },
      keymaps = {
        ["<C-i>"] = {
          callback = function()
            if vim.bo.filetype == "oil" then
              local oil = require("oil")
              vim.g.oil_show_info = not vim.g.oil_show_info
              if vim.g.oil_show_info then
                oil.set_columns({
                  "permissions",
                  "size",
                  "mtime",
                  "icon",
                })
              else
                oil.set_columns({})
              end
              return
            end
          end,
          desc = "Toggle info",
        },
        ["q"] = "actions.close",
        ["<C-h>"] = "actions.toggle_hidden",
        ["?"] = "actions.show_help",
      },
    },
    init = function()
      vim.g.oil_show_info = false
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("oil")
        end
      end
    end,
  },
}
