return {
  { import = "lazyvim.plugins.extras.coding.copilot" },
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
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "nix",
        "luadoc",
        "rust",
        "vimdoc",
        "toml",
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "clangd",
        "pyright",
        "black",
        "rust-analyzer",
        "texlab",
        "lua-language-server",
        "typescript-language-server",
      })
    end,
  },

  {
    "lervag/vimtex",
    config = function()
      -- vim.g.vimtex_compiler_progname = "nvr"
      -- vim.g.vimtex_view_method = "zathura"
    end,
  },
}
