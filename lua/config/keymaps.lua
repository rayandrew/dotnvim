-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local Util = require("lazyvim.util")

------------------------------
--        Buffers
------------------------------

map("n", "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save file" })

-- map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Move Lines
map("n", "<C-S-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<C-S-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<C-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<C-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<C-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- split
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "[W]indow Horizontal [S]plit" }) -- split horizontal
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "[W]indow [V]ertical Split" }) -- split vertical
-- close
map("n", "<leader>wq", "<C-w>q", { desc = "[W]indow [Q]uit" }) -- quit

-- move
-- map("n", "<leader>wh", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to Left [W]indow" })
-- map("n", "<leader>wj", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to [W]indow Below" })
-- map("n", "<leader>wk", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to Top [W]indow" })
-- map("n", "<leader>wl", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to Right [W]indow" })

if Util.has("bufferline.nvim") then
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

map("n", "<leader>wh", function()
  require("smart-splits").resize_left()
end, { desc = "Window Resize Left" })
map("n", "<leader>wj", function()
  require("smart-splits").resize_down()
end, { desc = "Window Resize Down" })
map("n", "<leader>wk", function()
  require("smart-splits").resize_up()
end, { desc = "Window Resize Up" })
map("n", "<leader>wl", function()
  require("smart-splits").resize_right()
end, { desc = "Window Resize Right" })
map("n", "<leader><leader>h", function()
  require("smart-splits").swap_buf_left()
end, { desc = "Swap Buffer Left" })
map("n", "<leader><leader>j", function()
  require("smart-splits").swap_buf_down()
end, { desc = "Swap Buffer Down" })
map("n", "<leader><leader>k", function()
  require("smart-splits").swap_buf_up()
end, { desc = "Swap Buffer Up" })
map("n", "<leader><leader>l", function()
  require("smart-splits").swap_buf_right()
end, { desc = "Swap Buffer Right" })
