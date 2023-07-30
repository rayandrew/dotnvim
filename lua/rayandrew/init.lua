local M = {}

function M.setup()
  require("rayandrew.set")
  require("rayandrew.lazy")
  require("rayandrew.autocmds")
  require("rayandrew.remap")
  require("rayandrew.theme").setup()
end

return M
