vim.keymap.set('n', '<C-[>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<C-[><C-[>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>fs', '<cmd>w<cr><Esc>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>ws', '<cmd>split<cr>', { desc = '[W]indow Horizontal [S]plit' }) -- split horizontal
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = '[W]indow [V]ertical Split' }) -- split vertical
vim.keymap.set('n', '<leader>wq', '<C-w>q', { desc = '[W]indow [Q]uit' }) -- quit
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { desc = 'Chmod File E[x]ecutable', silent = true })
vim.keymap.set('n', '<leader>lz', '<cmd>Lazy<CR>', { desc = '[L]azy', silent = true })
vim.keymap.set('n', '<leader>lp', '<cmd>Lazy profile<CR>', { desc = '[L]azy [P]rofile', silent = true })

vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

vim.keymap.set('n', '<leader>mx', '<cmd>!chmod +x %<CR>', { desc = 'Chmod File E[x]ecutable', silent = true })

-- vim.keymap.set('n', '<leader>gg', function()
--   Util.float_term({ 'lazygit' }, { cwd = Util.get_root(), esc_esc = false, ctrl_hjkl = false })
-- end, { desc = 'Lazygit (root dir)' })
vim.keymap.set('n', '<leader>gg', function()
  local term = require 'rayandrew.term'
  term.lazygit_float()
end, { desc = '[G]it Lazygit', noremap = true, silent = true })
vim.keymap.set('n', '<leader>gG', function()
  local term = require 'rayandrew.term'
  term.lazygit()
end, { desc = '[G]it Lazygit', noremap = true, silent = true })

vim.keymap.set('n', '<leader>tn', ':$tabnew<CR>', { noremap = true, silent = true, desc = '[T]ab [N]ew' })
vim.keymap.set('n', '<leader>tq', ':tabclose<CR>', { noremap = true, silent = true, desc = '[T]ab [Q]uit' })
vim.keymap.set('n', '<leader>tc', ':tabonly<CR>', { noremap = true, silent = true, desc = '[T]ab [C]lose All' })
vim.keymap.set('n', '<leader>tl', ':tabn<CR>', { noremap = true, silent = true, desc = '[T]ab Prev' })
vim.keymap.set('n', '<leader>th', ':tabp<CR>', { noremap = true, silent = true, desc = '[T]ab Next' })
-- move current tab to previous position
vim.keymap.set('n', '<leader>tmh', ':-tabmove<CR>', { noremap = true, silent = true, desc = '[T]ab Move Left' })
-- move current tab to next position
vim.keymap.set('n', '<leader>tml', ':+tabmove<CR>', { noremap = true, silent = true, desc = '[T]ab Move Right' })

-- Toggle Term

-- local trim_spaces = true
-- vim.keymap.set('v', '<leader>tl', function()
--   require('toggleterm').send_lines_to_terminal('single_line', trim_spaces, { args = vim.v.count })
-- end, { desc = 'Send Selection to Terminal' })
-- vim.g.send_toggleterm_motion = function(motion_type)
--   require('toggleterm').send_lines_to_terminal(motion_type, false, { args = vim.v.count })
-- end
-- local send_motion_d = function(p)
--   return function()
--     vim.go.operatorfunc = 'v:lua.send_toggleterm_motion'
--     return p
--   end
-- end
-- vim.keymap.set('n', '<leader>tp', send_motion_d 'g@', { desc = 'Send Motion to Terminal', expr = true })
-- vim.keymap.set('n', '<leader>tt', send_motion_d 'g@_', { desc = 'Send Motion to Terminal Twice', expr = true })
-- vim.keymap.set('n', '<leader>tf', send_motion_d "ggg@G''", { desc = 'Send Motion to Terminal Full File', expr = true })

-- Double the command to send line to terminal
-- vim.keymap.set('n', '<leader>tt', function()
--   -- set_opfunc(function(motion_type)
--   --   require('toggleterm').send_lines_to_terminal(motion_type, false, { args = vim.v.count })
--   -- end)
--   vim.go.operatorfunc = 'v:lua.send_toggleterm_motion'
--   vim.api.nvim_feedkeys('g@_', 'n', false)
-- end, { desc = 'Send Motion to Terminal Twice', expr = true })

-- Send whole file
-- vim.keymap.set('n', '<leader>tf', function()
--   -- set_opfunc(function(motion_type)
--   --   require('toggleterm').send_lines_to_terminal(motion_type, false, { args = vim.v.count })
--   -- end)
--   vim.go.operatorfunc = 'v:lua.send_toggleterm_motion'
--   vim.api.nvim_feedkeys("ggg@G''", 'n', false)
-- end, { desc = 'Send Whole File to Terminal', expr = true })
