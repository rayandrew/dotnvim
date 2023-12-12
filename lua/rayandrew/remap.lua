local Util = require("rayandrew.util")

------------------------------
--        Buffers
------------------------------

Util.map("n", "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Util.map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Move Lines
Util.map("n", "<C-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
Util.map("n", "<C-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
Util.map("i", "<C-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
Util.map("i", "<C-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
Util.map("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
Util.map("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

------------------------------
--   Windowing + Navigation
------------------------------

-- better up/down
Util.map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
Util.map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- resize
Util.map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
Util.map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
Util.map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
Util.map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- split
Util.map("n", "<leader>ws", "<cmd>split<cr>", { desc = "[W]indow Horizontal [S]plit" }) -- split horizontal
Util.map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "[W]indow [V]ertical Split" }) -- split vertical

-- move
-- Util.map("n", "<leader>wh", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to Left [W]indow" })
-- Util.map("n", "<leader>wj", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to [W]indow Below" })
-- Util.map("n", "<leader>wk", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to Top [W]indow" })
-- Util.map("n", "<leader>wl", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to Right [W]indow" })

if Util.has("bufferline.nvim") then
  Util.map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  Util.map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  Util.map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  Util.map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  Util.map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  Util.map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  Util.map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  Util.map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

Util.map("n", "<leader>wh", function()
  require("smart-splits").resize_left()
end, { desc = "Window Resize Left" })
Util.map("n", "<leader>wj", function()
  require("smart-splits").resize_down()
end, { desc = "Window Resize Down" })
Util.map("n", "<leader>wk", function()
  require("smart-splits").resize_up()
end, { desc = "Window Resize Up" })
Util.map("n", "<leader>wl", function()
  require("smart-splits").resize_right()
end, { desc = "Window Resize Right" })
-- moving between splits
-- Util.map("n", "<C-h>", function()
--   require("smart-splits").move_cursor_left()
-- end, { desc = "Focus to Left Window" })
-- Util.map("n", "<C-j>", function()
--   require("smart-splits").move_cursor_down()
-- end, { desc = "Focus to Lower Window" })
-- Util.map("n", "<C-k>", function()
--   require("smart-splits").move_cursor_up()
-- end, { desc = "Focus to Upper Window" })
-- Util.map("n", "<C-l>", function()
--   require("smart-splits").move_cursor_right()
-- end, { desc = "Focus to Right Window" })
-- swapping buffers between windows
Util.map("n", "<leader><leader>h", function()
  require("smart-splits").swap_buf_left()
end, { desc = "Swap Buffer Left" })
Util.map("n", "<leader><leader>j", function()
  require("smart-splits").swap_buf_down()
end, { desc = "Swap Buffer Down" })
Util.map("n", "<leader><leader>k", function()
  require("smart-splits").swap_buf_up()
end, { desc = "Swap Buffer Up" })
Util.map("n", "<leader><leader>l", function()
  require("smart-splits").swap_buf_right()
end, { desc = "Swap Buffer Right" })

-- tabs
Util.map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
Util.map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
Util.map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
Util.map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
Util.map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
Util.map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- close
Util.map("n", "<leader>wq", "<C-w>q", { desc = "[W]indow [Q]uit" }) -- quit

------------------------------
--        Clipboard
------------------------------

Util.map("x", "<leader>p", [["_dP]])

Util.map({ "n", "v" }, "<leader>y", [["+y]])
Util.map("n", "<leader>Y", [["+Y]])

Util.map({ "n", "v" }, "<leader>d", [["_d]])

Util.map("i", "<C-c>", "<Esc>")

Util.map("n", "Q", "<nop>")

------------------------------
--        Utilities
------------------------------

Util.map("n", "<leader>u", vim.cmd.UndotreeToggle)

-- better indenting
Util.map("v", "<", "<gv")
Util.map("v", ">", ">gv")

-- file permission
Util.map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

Util.map("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

------------------------------
--        Terminal
------------------------------

-- lazygit
Util.map("n", "<leader>gg", function()
  Util.float_term({ "lazygit" }, { cwd = Util.get_root(), esc_esc = false, ctrl_hjkl = false })
end, { desc = "Lazygit (root dir)" })
Util.map("n", "<leader>gG", function()
  Util.float_term({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false })
end, { desc = "Lazygit (cwd)" })

-- float term
local lazyterm = function()
  Util.float_term(nil, { cwd = Util.get_root() })
end
Util.map("n", "<leader>tt", lazyterm, { desc = "Terminal (root dir)" })
Util.map("n", "<leader>tT", function()
  Util.float_term()
end, { desc = "Terminal (cwd)" })
Util.map("n", "`", lazyterm, { desc = "Terminal (root dir)" })
Util.map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
Util.map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

Util.map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
Util.map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
Util.map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

------------------------------
--        Netrw
------------------------------

-- netrw
-- Util.map("n", "<leader>e", function()
--   vim.cmd("Ex")
-- end)

-- remap q to quit buffer in netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  command = "nnoremap <buffer> q <cmd>bd<CR>",
})

-- disable ctrl-h and ctrl-l in netrw and change it to TmuxNavigateLeft and TmuxNavigateRight
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  command = "nnoremap <buffer> <C-h> <cmd>TmuxNavigateLeft<CR>",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  command = "nnoremap <buffer> <C-l> <cmd>TmuxNavigateRight<CR>",
})

-- change refresh netrw to r
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  command = "nnoremap <buffer> r <cmd>edit<CR>",
})

------------------------------
--        Others
------------------------------

-- ufo
Util.map("n", "zR", function()
  require("ufo").openAllFolds()
end)
Util.map("n", "zM", function()
  require("ufo").closeAllFolds()
end)

-- lazy
Util.map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- source file
Util.map("n", "<leader><leader>s", function()
  vim.cmd("so")
end, { desc = "Source File" })
