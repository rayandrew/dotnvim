return {
  -- lazy.nvim:
  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvimtools/hydra.nvim',
    },
    opts = {
      normal_keys = {
        -- to change default lhs of key mapping change the key
        ['<C-[>'] = {
          method = nil,
          opts = { desc = 'Exit' },
        },
      },
      insert_keys = {
        -- to change default lhs of key mapping change the key
        ['<C-[>'] = {
          method = nil,
          opts = { desc = 'Exit' },
        },
      },
      extend_keys = {
        -- to change default lhs of key mapping change the key
        ['<C-[>'] = {
          method = nil,
          opts = { desc = 'Exit' },
        },
      },
    },
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>m',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },
}
