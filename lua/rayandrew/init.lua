local M = {}

function M.setup()
  require("rayandrew.set")
  require("rayandrew.lazy")
  require("rayandrew.autocmds")
  require("rayandrew.remap")
  require("rayandrew.theme").setup()
  require("rayandrew.commands")
  require("rayandrew.neovide")
  -- require("rayandrew.filetype").setup()
  -- require("rayandrew.statusline").setup()
end

return M
