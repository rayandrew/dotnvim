return {
  { -- buffer remove
    'echasnovski/mini.bufremove',
    version = false,
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote

    'echasnovski/mini.ai',
    version = false,
    opts = {
      n_lines = 500,
    },
  },
  {
    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']

    'echasnovski/mini.surround',
    version = false,
    config = true,
  },

  {
    'echasnovski/mini.statusline',
    version = false,
    config = function()
      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'echasnovski/mini.indentscope',
    version = false,
    config = true,
  },
  {
    'echasnovski/mini-git',
    main = 'mini.git',
    version = false,
    config = true,
    keys = {
      { '<leader>gs', '<cmd>lua MiniGit.show_at_cursor()<cr>', mode = 'n' },
      { '<leader>gs', '<cmd>lua MiniGit.show_at_cursor()<cr>', mode = 'x' },
    },
  },
  -- {
  --   'echasnovski/mini.comment',
  --   version = false,
  --   config = true,
  --   keys = {
  --     'gc',
  --     'gcc',
  --   },
  -- },
}
