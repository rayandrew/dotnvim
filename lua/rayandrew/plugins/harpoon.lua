return {
  {
    'theprimeagen/harpoon',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>ha',
        function()
          local mark = require 'harpoon.mark'
          mark.add_file()
          vim.print('Added to Harpoon ' .. vim.fn.expand '%')
        end,
        desc = 'Harpoon Add File',
      },
      {
        '<leader>he',
        function()
          local ui = require 'harpoon.ui'
          ui.toggle_quick_menu()
        end,
        desc = 'Harpoon UI',
      },
      {
        '<leader>h1',
        function()
          local ui = require 'harpoon.ui'
          ui.nav_file(1)
        end,
      },
      {
        '<leader>h2',
        function()
          local ui = require 'harpoon.ui'
          ui.nav_file(2)
        end,
      },
      {
        '<leader>h3',
        function()
          local ui = require 'harpoon.ui'
          ui.nav_file(3)
        end,
      },
      {
        '<leader>h4',
        function()
          local ui = require 'harpoon.ui'
          ui.nav_file(4)
        end,
      },
      {
        '<leader>h5',
        function()
          local ui = require 'harpoon.ui'
          ui.nav_file(5)
        end,
      },
    },
  },
}
