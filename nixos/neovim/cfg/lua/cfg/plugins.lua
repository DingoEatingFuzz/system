-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- File tree viewer
require("nvim-tree").setup(require("cfg.configs.nvimtree"))

-- Telescope / Fuzzy find
require("telescope").setup(require("cfg.configs.telescope"))

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
