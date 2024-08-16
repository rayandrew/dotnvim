local utils = require 'rayandrew.utils'

return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      {
        'zbirenbaum/copilot-cmp',
        -- enable if hostname starts with polaris-*
        cond = utils.is_argonne_servers(),
        opts = {},
        dependencies = {
          {
            'zbirenbaum/copilot.lua',
            cmd = 'Copilot',
            event = 'InsertEnter',
            config = true,
          },
        },
        config = function(_, opts)
          local copilot_cmp = require 'copilot_cmp'
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          local on_attach = function(client, _)
            if client.name == 'copilot' then
              copilot_cmp._on_insert_enter {}
            end
          end
          vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
              local buffer = args.buf ---@type number
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              on_attach(client, buffer)
            end,
          })
        end,
      },
      {
        'sourcegraph/sg.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cond = not utils.is_argonne_servers(),
        opts = {
          enable_cody = true,
          accept_tos = true,
          download_binaries = true,
        },
      },
      -- {
      --   'Exafunction/codeium.nvim',
      --   dependencies = { 'nvim-lua/plenary.nvim' },
      --   config = true,
      --   -- disable if hostname starts with polaris-*
      --   cond = not utils.is_argonne_servers(),
      -- },
      -- {
      --   'tzachar/cmp-ai',
      --   config = function()
      --     local cmp_ai = require 'cmp_ai.config'
      --
      --     cmp_ai:setup {
      --       max_lines = 100,
      --       provider = 'Ollama',
      --       provider_options = {
      --         model = 'codegemma:2b-code',
      --         prompt = function(lines_before, lines_after)
      --           return lines_before
      --         end,
      --         suffix = function(lines_after)
      --           return lines_after
      --         end,
      --       },
      --       notify = true,
      --       -- notify_callback = function(msg)
      --       --   vim.notify(msg)
      --       -- end,
      --       run_on_every_keystroke = true,
      --       ignored_file_types = {
      --         -- default is not to ignore
      --         -- uncomment to ignore in lua:
      --         -- lua = true
      --       },
      --     }
      --   end,
      -- },
      { 'onsails/lspkind.nvim', config = true },
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        formatting = {
          format = require('lspkind').cmp_format {
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            show_labelDetails = true,
            before = function(entry, vim_item)
              return vim_item
            end,
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- ['<C-x>'] = cmp.mapping(
          --   cmp.mapping.complete {
          --     config = {
          --       sources = cmp.config.sources {
          --         -- { name = 'cmp_ai' },
          --         -- { name = 'codeium' },
          --         { name = 'cody' },
          --       },
          --     },
          --   },
          --   { 'i' }
          -- ),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),

          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          -- { name = 'cmp_ai' },
          { name = 'cody' },
          { name = 'codeium' },
          { name = 'copilot' },
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
}
