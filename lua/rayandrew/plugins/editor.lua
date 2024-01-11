return {
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
              -- draw a line on HJKL keystrokes
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
    "3rd/image.nvim",
    enabled = not vim.g.neovide,
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
}
