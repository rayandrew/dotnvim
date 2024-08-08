return {
  {
    'joshuadanpeterson/typewriter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = true,
    config = true,
    cmd = { 'TWEnable', 'TWToggle' },
    opts = {
      enable_with_zen_mode = true,
      enable_with_true_zen = true,
      -- keep_cursor_position = true,
      enable_notifications = true,
      -- enable_horizontal_scroll = true,
    },
  },
}
