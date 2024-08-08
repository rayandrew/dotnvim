return {
  {
    'ojroques/nvim-osc52',
    event = 'VimEnter',
    config = function()
      local copy = function()
        if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
          require('osc52').copy_register '+'
        end
      end

      vim.api.nvim_create_autocmd('TextYankPost', { callback = copy })
    end,
  },
}
