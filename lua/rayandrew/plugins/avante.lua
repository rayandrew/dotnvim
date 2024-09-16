return {
  {
    'yetone/avante.nvim',
    enabled = false,
    event = 'VeryLazy',
    build = 'make',
    opts = {
      -- api_key_name = 'cmd:op item get Anthropic --fields "api"',
      -- api_key_name = 'cmd:op item get ChatGPT --fields "api"',
      -- api_key_name = 'cmd:op item get g-raydreww --fields "gemini-api"',
      debug = false,
      allow_insecure = false,
      provider = 'claude',
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-3-5-sonnet-20240620',
        temperature = 0,
        max_tokens = 4096,
        -- api_key_name = 'cmd:op item get Anthropic --fields "api"',
      },
    },
    dependencies = {
      'echasnovski/mini.icons',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
