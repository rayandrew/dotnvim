return {
  'ej-shafran/compile-mode.nvim',
  branch = 'latest',
  cmd = { 'Compile' },
  -- or a specific version:
  -- tag = "v3.0.0"
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'm00qek/baleia.nvim', tag = 'v1.3.0' },
  },
  opts = {
    -- to add ANSI escape code support, add:
    baleia_setup = true,
  },
}
