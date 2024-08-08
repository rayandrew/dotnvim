return {
  {
    'assistcontrol/readline.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<M-f>',
        function()
          require('readline').forward_word()
        end,
        mode = '!',
      },
      {
        '<M-b>',
        function()
          require('readline').backward_word()
        end,
        mode = '!',
      },
      {
        '<M-d>',
        function()
          require('readline').kill_word()
        end,
        mode = '!',
      },
      {
        '<M-BS>',
        function()
          require('readline').backward_kill_word()
        end,
        mode = '!',
      },
      {
        '<C-w>',
        function()
          require('readline').unix_word_rubout()
        end,
        mode = '!',
      },
      {
        '<C-k>',
        function()
          require('readline').kill_line()
        end,
        mode = '!',
      },
      {
        '<C-u>',
        function()
          require('readline').backward_kill_line()
        end,
        mode = '!',
      },
      {
        '<C-a>',
        function()
          require('readline').beginning_of_line()
        end,
        mode = '!',
      },
      {
        '<C-e>',
        function()
          require('readline').end_of_line()
        end,
        mode = '!',
      },
      { '<C-f>', '<Right>', mode = '!' }, -- forward-char
      { '<C-b>', '<Left>', mode = '!' }, -- backward-char
      { '<C-n>', '<Down>', mode = '!' }, -- next-line
      { '<C-p>', '<Up>', mode = '!' }, -- previous-line
      { '<C-d>', '<Delete>', mode = '!' }, -- delete-char
      { '<C-h>', '<BS>', mode = '!' }, -- backward-delete-char
      { '<C-g>', '<Esc>', mode = '!' }, -- abort
    },
  },
}
