-- return {
--   "tpope/vim-dadbod",
--   "kristijanhusak/vim-dadbod-ui",
--   "kristijanhusak/vim-dadbod-completion",
--
--   vim.keymap.set("n", "<leader>B", ":DBUI<CR>", { noremap = true, desc = "DBUI Toggle" }),
-- }
--
return {
  -- "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",
  -- "kristijanhusak/vim-dadbod-completion",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Your DBUI configuration
    -- vim.g.db_ui_use_nerd_fonts =
  end,
  vim.keymap.set("n", "<leader>B", ":DBUI<CR>", { noremap = true, desc = "DBUI Toggle" }),
}
