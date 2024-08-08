return {
  {
    'hedyhli/outline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>to', '<cmd>Outline<cr>', desc = '[T]oggle [O]utline' },
    },
    config = function()
      require('outline').setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end,
  },
}
