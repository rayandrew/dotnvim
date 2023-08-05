-- credit goes to
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html

local M = {}

local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]):upper()
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
  if fpath == "" or fpath == "." then
    return " "
  end

  return string.format(" %%<%s/", fpath)
end

local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#StatusLineAccent#"
  if current_mode == "n" then
    mode_color = "%#StatuslineAccent#"
  elseif current_mode == "i" or current_mode == "ic" then
    mode_color = "%#StatuslineInsertAccent#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
    mode_color = "%#StatuslineVisualAccent#"
  elseif current_mode == "R" then
    mode_color = "%#StatuslineReplaceAccent#"
  elseif current_mode == "c" then
    mode_color = "%#StatuslineCmdLineAccent#"
  elseif current_mode == "t" then
    mode_color = "%#StatuslineTerminalAccent#"
  end
  return mode_color
end

local function filename()
  local fname = vim.fn.expand("%:t")
  if fname == "" then
    return ""
  end
  return fname .. " "
end

function M.render_active()
  local parts = {
    "%#Statusline#",
    update_mode_colors(),
    mode(),
    "%#Normal# ",
    "%=%#StatusLineExtra#",
    filepath(),
    filename(),
  }

  local statusline = table.concat(parts, "")

  return statusline
end

function M.render_inactive()
  local parts = {
    "%#Statusline#",
    "%#Normal# ",
    "%=%#StatusLineExtra#",
  }
  local statusline = table.concat(parts, "")
  return statusline
end

-- function M.render(opts)
--   opts = opts or {}
--   local active = opts.active or false
--   local statusline = ""
--   if active then
--     statusline = M.render_active()
--   else
--     statusline = M.render_inactive()
--   end
--   vim.opt_local.statusline = statusline
-- end

function M.setup()
  local augroup = require("rayandrew.util").augroup
  local autocmd = vim.api.nvim_create_autocmd

  -- Statusline
  autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
    group = augroup("statusline-enter"),
    pattern = "*",
    callback = function()
      vim.opt_local.statusline = "%!v:lua.require('rayandrew.statusline').render_active()"
    end,
    -- command = [[lua require("rayandrew.statusline").render({ active = true })]],
  })

  autocmd({ "BufLeave", "BufWinLeave", "WinLeave" }, {
    group = augroup("statusline-leave"),
    pattern = "*",
    callback = function()
      vim.opt_local.statusline = "%!v:lua.require('rayandrew.statusline').render_inactive()"
    end,
    -- command = [[lua require("rayandrew.statusline").render({ active = false })]],
  })
end

return M
