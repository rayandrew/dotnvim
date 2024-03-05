local M = {}

local lsps = {
  lua = { "lua-language-server" },
  python = { "pyright" },
}

-- https://github.com/chrisgrieser/.config/blob/7dc36c350976010b32ece078edd581687634811a/nvim/lua/plugins/linter-formatter.lua#L214-L234
M.linters = {
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
for ft, _ in pairs(M.linters) do
  table.insert(M.linters[ft], "codespell")
  table.insert(M.linters[ft], "editorconfig-checker")
end

-- https://github.com/chrisgrieser/.config/blob/7dc36c350976010b32ece078edd581687634811a/nvim/lua/plugins/linter-formatter.lua#L214-L234
M.formatters = {
  lua = { "stylua" },
  python = { "isort", "black" },
  javascript = { "biome" },
  typescript = { "biome" },
  json = { "biome" },
  jsonc = { "biome" },
  nix = { "alejandra" },
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
  -- ["*"] = { "codespell" },
}

M.debuggers = {}

M.dontInstall = {
  -- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
  "stylelint",
  -- not real formatters, but pseudo-formatters from conform.nvim
  "trim_whitespace",
  "trim_newlines",
  "squeeze_blanks",
  "injected",
  "alejandra",
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
function toolsToAutoinstall(myLinters, myFormatters, myDebuggers, ignoreTools)
  -- get all linters, formatters, & debuggers and merge them into one list
  local lspList = vim.tbl_flatten(vim.tbl_values(lsps))
  local linterList = vim.tbl_flatten(vim.tbl_values(myLinters))
  local formatterList = vim.tbl_flatten(vim.tbl_values(myFormatters))
  local tools = vim.list_extend(linterList, formatterList)
  vim.list_extend(tools, lspList)
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

function M.getToolsToInstall()
  local tools = toolsToAutoinstall(M.linters, M.formatters, M.debuggers, M.dontInstall)
  return tools
end

return M
