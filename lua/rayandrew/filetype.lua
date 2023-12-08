-- using nvim autocommands

local autocmd = vim.api.nvim_create_autocmd
local augroup = require("rayandrew.util").augroup

local M = {}

function M.setup()
  local group = augroup("filetype")
  -- set tabs=4 and use tabs in txt files
  autocmd("filetype", {
    pattern = "text",
    group = group,
    callback = function()
      vim.bo.tabstop = 4
      vim.bo.softtabstop = 4
      vim.bo.shiftwidth = 4
      vim.bo.expandtab = false
      vim.opt_local.wrap = true
    end,
  })

  -- tex/latex wrap true
  autocmd("filetype", {
    pattern = "tex",
    group = group,
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.breakindent = true
      vim.opt_local.breakindentopt = "shift:2"
    end,
  })

  autocmd("filetype", {
    pattern = "latex",
    group = group,
    callback = function()
      -- set wrap and breakindent
      vim.opt_local.wrap = true
      vim.opt_local.breakindent = true
      vim.opt_local.breakindentopt = "shift:2"
    end,
  })
end

return M
