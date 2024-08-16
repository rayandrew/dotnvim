return {
  {
    'nvim-pack/nvim-spectre',
    lazy = true,
    config = true,
    keys = {
      { '<leader>pt', '<cmd>lua require("spectre").toggle()<cr>', desc = 'Spectre [T]oggle' },
      { '<leader>pw', '<cmd>lua require("spectre").open_visual({select_word = true})<cr>', desc = 'Spectre Current [W]ord', mode = 'n' },
      { '<leader>pw', '<cmd>lua require("spectre").open_visual()<cr>', desc = 'Spectre Current [W]ord', mode = 'v' },
      { '<leader>pf', '<cmd>lua require("spectre").open_file_search({select_word = true})<cr>', desc = 'Spectre Current [F]ile' },
    },
  },
}
