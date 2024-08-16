return {
  {
    'stevearc/oil.nvim',
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    cmd = { 'Oil' },
    opts = {
      columns = {},
      default_file_explorer = true,
      restore_win_options = true,
      use_default_keymaps = false,
      float = {
        padding = 2,
        max_width = 240,
        max_height = 70,
        -- width = 0.2,
        -- max_height = 0.5,
        border = 'rounded',
        win_options = {
          winblend = 10,
        },
      },
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        -- ['<C-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
        -- ['<C-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
        ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-[>'] = 'actions.close',
        ['<C-r>'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
        ['<C-i>'] = {
          callback = function()
            if vim.bo.filetype == 'oil' then
              local oil = require 'oil'
              vim.g.oil_show_info = not vim.g.oil_show_info
              if vim.g.oil_show_info then
                oil.set_columns {
                  'permissions',
                  'size',
                  'mtime',
                  -- 'icon',
                }
              else
                oil.set_columns {}
              end
              return
            end
          end,
          desc = 'Toggle info',
        },
        ['q'] = 'actions.close',
        -- ['<C-h>'] = 'actions.toggle_hidden',
        ['?'] = 'actions.show_help',
      },
    },
    keys = {
      { '<leader>fm', '<cmd>Oil<cr>', desc = '[F]ile [M]anager' },
      { '<leader>fM', '<cmd>Oil --float<cr>', desc = '[F]ile [M]anager' },
    },
    init = function()
      vim.g.oil_show_info = false
    end,
  },
}
