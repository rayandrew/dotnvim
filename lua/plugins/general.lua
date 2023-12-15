return {
  {
    "kvrohit/rasmus.nvim",
    name = "rasmus",
    lazy = true,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rasmus",
    },
  },

  { "tpope/vim-rsi" },

  {
    "mbbill/undotree",
    cmnd = "UndotreeToggle",
    keys = {
      {
        "<leader>u",
        "<cmd>UndotreeToggle<cr>",
        desc = "Open Undo Tree",
      },
    },
  },

  -- {
  --   "folke/noice.nvim",
  --   opts = {
  --     presets = {
  --       bottom_search = false, -- use a classic bottom cmdline for search
  --       command_palette = false, -- position the cmdline and popupmenu together
  --       long_message_to_split = true, -- long messages will be sent to a split
  --       inc_rename = false, -- enables an input dialog for inc-rename.nvim
  --       lsp_doc_border = false, -- add a border to hover docs and signature help
  --     },
  --   },
  -- },

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
