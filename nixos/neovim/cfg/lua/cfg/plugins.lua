-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

-- Treesitter
require("nvim-treesitter.configs").setup(require("cfg.configs.treesitter"))

-- File tree viewer
require("nvim-tree").setup(require("cfg.configs.nvimtree"))

-- Telescope / Fuzzy find
require("telescope").setup(require("cfg.configs.telescope"))

-- Git
require("gitsigns").setup(require("cfg.configs.gitsigns"))

-- Autocompletion
require("cmp").setup(require("cfg.configs.cmp"))

-- Status line
require("lualine").setup(require("cfg.configs.lualine"))

-- Theming
require("base46").load_all_highlights()

-- setup language servers
local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = {
  "html",
  "cssls",
  "ts_ls",
  "ember",
  "lua_ls",
  "rust_analyzer",
  "gopls",
  "zls",
  "eslint",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = lsp_capabilities,
  })
end

lspconfig.eslint.setup({
  filetypes = { "javascript.glimmer", "typescript.glimmer" },
  on_attach = function(_, bufnr)
    -- eslint --fix on save before prettier/formatters
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

-- Use the new rfc-style formatter
lspconfig.nixd.setup({
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

-- Autoformat on save
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format { async = false, id = args.data.client_id }
      end,
    })
  end
})

-- diagnostics characters and settings
local d = vim.diagnostic
local x = d.severity
local lsp = vim.lsp

d.config({
  virtual_text = { prefix = "" },
  signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
  underline = true,
  float = { border = "single" },
})

-- Default border style
local orig_util_open_floating_preview = lsp.util.open_floating_preview
function lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
