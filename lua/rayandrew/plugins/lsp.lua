------------------------------
--    LSP CONFIGURATION     --
------------------------------

local slow_format_filetypes = {}

-- https://github.com/chrisgrieser/.config/blob/7dc36c350976010b32ece078edd581687634811a/nvim/lua/plugins/linter-formatter.lua#L214-L234
local linters = {
  lua = { "selene" },
  css = { "stylelint" },
  sh = { "shellcheck" },
  markdown = { "markdownlint", "vale" },
  yaml = { "yamllint" },
  python = { "pylint" },
  gitcommit = {},
  json = {},
  javascript = {},
  typescript = {},
  toml = {},
  applescript = {},
  bib = {},
}

-- https://github.com/chrisgrieser/.config/blob/7dc36c350976010b32ece078edd581687634811a/nvim/lua/plugins/linter-formatter.lua#L214-L234
-- PENDING https://github.com/mfussenegger/nvim-lint/issues/355
for ft, _ in pairs(linters) do
  table.insert(linters[ft], "codespell")
  table.insert(linters[ft], "editorconfig-checker")
end

-- https://github.com/chrisgrieser/.config/blob/7dc36c350976010b32ece078edd581687634811a/nvim/lua/plugins/linter-formatter.lua#L214-L234
local formatters = {
  lua = { "stylua" },
  python = { "isort", "black" },
  javascript = { "biome" },
  typescript = { "biome" },
  json = { "biome" },
  jsonc = { "biome" },
  nix = { "nixpkgs_fmt" },
  yaml = { "prettier" },
  html = { "prettier" },
  markdown = {
    "markdown-toc",
    "markdownlint",
    -- "injected",
  },
  css = { "stylelint", "prettier" },
  sh = { "shellcheck", "shfmt" },
  bib = { "trim_whitespace", "bibtex-tidy" },
  ["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
  ["*"] = { "codespell" },
}

local debuggers = {}

local dontInstall = {
  -- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
  "stylelint",
  -- not real formatters, but pseudo-formatters from conform.nvim
  "trim_whitespace",
  "trim_newlines",
  "squeeze_blanks",
  "injected",
  "nixpkgs_fmt",
}

---given the linter- and formatter-list of nvim-lint and conform.nvim, extract a
---list of all tools that need to be auto-installed
---@param myLinters object[]
---@param myFormatters object[]
---@param myDebuggers string[]
---@param ignoreTools string[]
---@return string[] tools
---@nodiscard
local function toolsToAutoinstall(myLinters, myFormatters, myDebuggers, ignoreTools)
  -- get all linters, formatters, & debuggers and merge them into one list
  local linterList = vim.tbl_flatten(vim.tbl_values(myLinters))
  local formatterList = vim.tbl_flatten(vim.tbl_values(myFormatters))
  local tools = vim.list_extend(linterList, formatterList)
  vim.list_extend(tools, myDebuggers)

  -- only unique tools
  table.sort(tools)
  tools = vim.fn.uniq(tools)

  -- remove exceptions not to install
  tools = vim.tbl_filter(function(tool)
    return not vim.tbl_contains(ignoreTools, tool)
  end, tools)
  return tools
end

return {
  {
    {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      lazy = true,
      config = false,
      init = function()
        -- Disable automatic setup, we are doing it manually
        vim.g.lsp_zero_extend_cmp = 0
        vim.g.lsp_zero_extend_lspconfig = 0
      end,
    },

    {
      "williamboman/mason.nvim",
      lazy = false,
      config = true,
    },

    -- Autocompletion
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        { "L3MON4D3/LuaSnip" },
      },
      config = function()
        -- Here is where you configure the autocompletion settings.
        local lsp_zero = require("lsp-zero")
        lsp_zero.extend_cmp()

        -- And you can configure cmp even more, if you want to.
        local cmp = require("cmp")
        local cmp_action = lsp_zero.cmp_action()

        cmp.setup({
          formatting = lsp_zero.cmp_format(),
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-f>"] = cmp_action.luasnip_jump_forward(),
            ["<C-b>"] = cmp_action.luasnip_jump_backward(),
          }),
        })
      end,
    },

    -- LSP
    {
      "neovim/nvim-lspconfig",
      cmd = { "LspInfo", "LspInstall", "LspStart" },
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "williamboman/mason-lspconfig.nvim" },
      },
      config = function()
        -- This is where all the LSP shenanigans will live
        local lsp_zero = require("lsp-zero")
        lsp_zero.extend_lspconfig()

        lsp_zero.on_attach(function(client, bufnr)
          -- see :help lsp-zero-keybindings
          -- to learn the available actions
          lsp_zero.default_keymaps({ buffer = bufnr })
        end)

        require("mason-lspconfig").setup({
          ensure_installed = {},
          handlers = {
            lsp_zero.default_setup,
            lua_ls = function()
              -- (Optional) Configure lua language server for neovim
              local lua_opts = lsp_zero.nvim_lua_ls()
              require("lspconfig").lua_ls.setup(lua_opts)
            end,
          },
        })
      end,
    },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = formatters,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        local function on_format(err)
          if err and err:match("timeout$") then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        return { timeout_ms = 200, lsp_fallback = true }, on_format
      end,
      format_after_save = function(bufnr)
        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { lsp_fallback = true }
      end,
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>xx",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  { -- Linter integration
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = linters

      lint.linters.shellcheck.args = { "--shell=bash", "--format=json", "-" }
      lint.linters.markdownlint.args = {
        "--disable=no-trailing-spaces", -- not disabled in config, so it's enabled for formatting
        "--disable=no-multiple-blanks",
      }
      lint.linters["editorconfig-checker"].args = {
        "-no-color",
        "-disable-max-line-length", -- only rule of thumb
        "-disable-trim-trailing-whitespace", -- will be formatted anyway
      }
    end,
  },

  { -- auto-install missing linters & formatters
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>pM", vim.cmd.MasonToolsUpdate, desc = " Mason Update" },
    },
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      local tools = toolsToAutoinstall(linters, formatters, debuggers, dontInstall)

      require("mason-tool-installer").setup({
        ensure_installed = tools,
        run_on_start = false, -- triggered manually, since not working with lazy-loading
      })

      -- clean unused & install missing
      vim.defer_fn(vim.cmd.MasonToolsInstall, 500)
      vim.defer_fn(vim.cmd.MasonToolsClean, 1000) -- delayed, so noice.nvim is loaded before
    end,
  },
}
