--- [[ Conform ]] commands

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#format-command
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

--- [[ WhiteSpace ]] commands

-- vim.api.nvim_create_user_command("RemoveWhiteSpaceEnable", function()
--   vim.b.disable_whitespace = false
--   vim.g.disable_whitespace = false
-- end, {
--   desc = "Re-enable whitespace removal on save",
-- })
--
-- vim.api.nvim_create_user_command("RemoveWhiteSpaceDisable", function(args)
--   if args.bang then
--     -- RemoveWhiteSpaceDisable! will disable whitespace removal just for this buffer
--     vim.b.disable_whitespace = true
--   else
--     vim.g.disable_whitespace = true
--   end
-- end, {
--   desc = "Disable whitespace removal on save",
--   bang = true,
-- })
