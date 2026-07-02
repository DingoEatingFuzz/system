-- GDScript is special
vim.lsp.start({
  name = 'Godot',
  cmd = vim.lsp.rpc.connect('172.25.16.1', 6005),
  root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  on_attach = function()
    vim.api.nvim_command('echo serverstart("/tmp/godot.pipe")')
  end
})
