return {
  {
    'rmagatti/auto-session',
    cond = false,
    lazy = false,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      auto_session_enabled = true,
      auto_session_root_dir = vim.fn.stdpath 'data' .. '/sessions/',
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = nil,
      auto_session_allowed_dirs = nil,
      auto_session_create_enabled = true,
      auto_session_enable_last_session = false,
      auto_session_use_git_branch = false,
      auto_restore_lazy_delay_enabled = true,
      log_level = 'error',
      cwd_change_handling = {
        restore_upcoming_session = false,
        post_cwd_changed_hook = function()
          require('bufferline.ui').refresh()
          --require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
        end,
      },
    },
    config = true,
    -- config = function(_, opts)
    --   require('auto-session').setup {
    --   }
    -- end,
  },
}
