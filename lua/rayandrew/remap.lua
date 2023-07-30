local Util = require("rayandrew.util")

------------------------------
--        Buffers
------------------------------

Util.map("n", "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save file" })

Util.map(
  { "i", "v", "n", "s" },
  "<C-s>",
  "<cmd>w<cr><esc>",
  { desc = "Save file" }
)

-- Move Lines
Util.map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
Util.map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
Util.map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
Util.map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
Util.map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
Util.map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

------------------------------
--   Windowing + Navigation
------------------------------

-- better up/down
Util.map(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
Util.map(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- resize
Util.map(
  "n",
  "<C-Up>",
  "<cmd>resize +2<cr>",
  { desc = "Increase window height" }
)
Util.map(
  "n",
  "<C-Down>",
  "<cmd>resize -2<cr>",
  { desc = "Decrease window height" }
)
Util.map(
  "n",
  "<C-Left>",
  "<cmd>vertical resize -2<cr>",
  { desc = "Decrease window width" }
)
Util.map(
  "n",
  "<C-Right>",
  "<cmd>vertical resize +2<cr>",
  { desc = "Increase window width" }
)

-- split
Util.map(
  "n",
  "<leader>ws",
  "<cmd>split<cr>",
  { desc = "[W]indow Horizontal [S]plit" }
) -- split horizontal
Util.map(
  "n",
  "<leader>wv",
  "<cmd>vsplit<cr>",
  { desc = "[W]indow [V]ertical Split" }
) -- split vertical

-- move
Util.map(
  "n",
  "<leader>wh",
  "<cmd>TmuxNavigateLeft<cr>",
  { desc = "Go to Left [W]indow" }
)
Util.map(
  "n",
  "<leader>wj",
  "<cmd>TmuxNavigateDown<cr>",
  { desc = "Go to [W]indow Below" }
)
Util.map(
  "n",
  "<leader>wk",
  "<cmd>TmuxNavigateUp<cr>",
  { desc = "Go to Top [W]indow" }
)
Util.map(
  "n",
  "<leader>wl",
  "<cmd>TmuxNavigateRight<cr>",
  { desc = "Go to Right [W]indow" }
)

if Util.has("bufferline.nvim") then
  Util.map(
    "n",
    "<S-h>",
    "<cmd>BufferLineCyclePrev<cr>",
    { desc = "Prev buffer" }
  )
  Util.map(
    "n",
    "<S-l>",
    "<cmd>BufferLineCycleNext<cr>",
    { desc = "Next buffer" }
  )
  Util.map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  Util.map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  Util.map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  Util.map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  Util.map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  Util.map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

-- tabs
Util.map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
Util.map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
Util.map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
Util.map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
Util.map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
Util.map(
  "n",
  "<leader><tab>[",
  "<cmd>tabprevious<cr>",
  { desc = "Previous Tab" }
)

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
  Util.float_term(
    { "lazygit" },
    { cwd = Util.get_root(), esc_esc = false, ctrl_hjkl = false }
  )
end, { desc = "Lazygit (root dir)" })
Util.map("n", "<leader>gG", function()
  Util.float_term({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false })
end, { desc = "Lazygit (cwd)" })

-- float term
local lazyterm = function()
  Util.float_term(nil, { cwd = Util.get_root() })
end
Util.map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
Util.map("n", "<leader>fT", function()
  Util.float_term()
end, { desc = "Terminal (cwd)" })
Util.map("n", "<c-`>", lazyterm, { desc = "Terminal (root dir)" })
Util.map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
Util.map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

Util.map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
Util.map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
Util.map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
Util.map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
Util.map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
Util.map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
Util.map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

------------------------------
--        Others
------------------------------

-- lazy
Util.map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
