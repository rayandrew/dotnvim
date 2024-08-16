return {
  {
    'akinsho/bufferline.nvim',
    cond = false,
    -- event = 'VimEnter',
    config = true,
    lazy = false,
    opts = {
      options = {
        view = 'multiwindow',
        numbers = function(opts)
          local harpoon = require 'harpoon.mark'
          local buf_name = vim.api.nvim_buf_get_name(opts.id)
          local harpoon_mark = harpoon.get_index_of(buf_name)
          return harpoon_mark
        end,
        modified_icon = '●',
        max_prefix_length = 5,
        tab_size = 18,
        diagnostics = 'nvim_lsp',
        separator_style = { '|', '' },
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'center',
          },
        },
        sort_by = function(buffer_a, buffer_b)
          local function get_local_mark(id)
            local harpoon = require 'harpoon.mark'
            local buf_name = vim.api.nvim_buf_get_name(id)
            local harpoon_mark = harpoon.get_index_of(buf_name)
            if harpoon_mark == nil then
              return 999999
            end
            return harpoon_mark
          end
          return get_local_mark(buffer_a.id) < get_local_mark(buffer_b.id)
        end,
      },
    },
    keys = {
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
    },
    -- config = function()
    --
    -- end,
  },
}
