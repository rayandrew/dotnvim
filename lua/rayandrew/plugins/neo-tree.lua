-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal' },
    -- {
    --   '<leader>fe',
    --   ':Neotree toggle<CR>',
    --   desc = 'Toggle NeoTree',
    -- },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<space>'] = 'none',
          -- ["C"] = "copy",
          ['C'] = {
            'copy',
            config = {
              show_path = 'absolute', -- "none", "relative", "absolute"
            },
          },
          ['R'] = { 'rename', config = { show_path = 'absolute' } },
          ['y'] = function(state)
            local node = state.tree:get_node()
            -- get relative path
            local filepath = node:get_id()
            local filename = vim.fn.fnamemodify(filepath, ':.')
            -- local filename = node.name
            vim.fn.setreg('+', filename)
            vim.notify('Copied: ' .. filename)
          end,
          ['Y'] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            vim.fn.setreg('+', filepath)
            vim.notify('Copied: ' .. filepath)
          end,
          ['O'] = {
            command = function(state)
              local node = state.tree:get_node()
              local filepath = node.path
              local osType = os.getenv 'OS'

              local command

              if osType == 'Windows_NT' then
                command = 'start ' .. filepath
              elseif osType == 'Darwin' then
                command = 'open ' .. filepath
              else
                command = 'xdg-open ' .. filepath
              end
              os.execute(command)
            end,
            desc = 'open_with_system_defaults',
          },
        },
      },
    },
  },
}
