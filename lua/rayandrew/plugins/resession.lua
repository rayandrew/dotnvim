return {
  {
    'stevearc/resession.nvim',
    lazy = false,
    cond = false,
    keys = {
      { '<leader>ps', ":lua require('resession').save()<CR>", desc = '[S]ave [S]ession' },
      { '<leader>pl', ":lua require('resession').load()<CR>", desc = '[L]oad [S]ession' },
      { '<leader>pd', ":lua require('resession').delete()<CR>", desc = '[D]elete [S]ession' },
    },
    opts = {
      tab_buf_filter = function(tabpage, bufnr)
        local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
        -- ensure dir has trailing /
        dir = dir:sub(-1) ~= '/' and dir .. '/' or dir
        return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
      end,
      -- override default filter
      buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        if buftype == 'help' then
          return true
        end
        if buftype ~= '' and buftype ~= 'acwrite' then
          return false
        end
        if vim.api.nvim_buf_get_name(bufnr) == '' then
          return false
        end

        -- this is required, since the default filter skips nobuflisted buffers
        return true
      end,
      extensions = { scope = {} },
    },
    config = function(_, opts)
      local resession = require 'resession'
      resession.setup(opts)
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
          end
        end,
        nested = true,
      })
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
        end,
      })
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          -- Always save a special session named "last"
          resession.save 'last'
        end,
      })
    end,
  },
}
