return {
  {
    'akinsho/git-conflict.nvim',
    event = 'VeryLazy',
    version = '*',
    config = function()
      require('git-conflict').setup()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitConflictDetected',
        callback = function()
          vim.notify('Conflict detected in ' .. vim.fn.expand '<afile>')
        end,
      })
    end,
  },
}
