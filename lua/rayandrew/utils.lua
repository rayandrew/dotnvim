local M = {}

local _is_argonne_servers = false

M.is_argonne_servers = function()
  local is_polaris = not not (vim.fn.hostname():match '^polaris%-')
  _is_argonne_servers = is_polaris
  return _is_argonne_servers
end

return M
