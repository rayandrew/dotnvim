vim.keymap.set('n', '<C-[>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<C-[><C-[>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>fs', '<cmd>w<cr><Esc>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>ws', '<cmd>split<cr>', { desc = '[W]indow Horizontal [S]plit' }) -- split horizontal
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = '[W]indow [V]ertical Split' }) -- split vertical
vim.keymap.set('n', '<leader>wq', '<C-w>q', { desc = '[W]indow [Q]uit' }) -- quit
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { desc = 'Chmod File E[x]ecutable', silent = true })
vim.keymap.set('n', '<leader>lz', '<cmd>Lazy<CR>', { desc = 'Chmod File E[x]ecutable', silent = true })
