return {
  -- { import = "lazyvim.plugins.extras.coding.copilot" },
  { import = "lazyvim.plugins.extras.lang.json" },

  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "IndianBoy42/tree-sitter-just",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function(_, opts)
          require("tree-sitter-just").setup({})
        end,
      },
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "nix",
        "luadoc",
        "rust",
        "vimdoc",
        "toml",
      })
      require("nvim-treesitter.install").compilers = { "gcc", "clang" }
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "clangd",
        -- python
        "pyright",
        "isort",
        "black",
        "rust-analyzer",
        "texlab",
        "lua-language-server",
        "typescript-language-server",
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  {
    "lervag/vimtex",
    config = function()
      -- vim.g.vimtex_compiler_progname = "nvr"
      -- vim.g.vimtex_view_method = "zathura"
    end,
  },

  {
    "github/copilot.vim",
    init = function() end,
  },
}
