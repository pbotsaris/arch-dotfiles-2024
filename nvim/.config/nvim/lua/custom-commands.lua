vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if vim.tbl_isempty(clients) then
    print('No LSP attached to this buffer')
    return
  end
  for _, c in ipairs(clients) do
    print(('%s (id=%d) root=%s'):format(c.name, c.id, c.root_dir or 'nil'))
  end
end, {})
