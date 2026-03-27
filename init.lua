-- GLOBAL OPTIONS

vim.g.mapleader = ' '

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set tabswidth
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

local transparent = false

-- PLUGINS DECLARATION

vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig', version = vim.version.range('~2.5') },
	{ src = 'https://github.com/folke/tokyonight.nvim', version = vim.version.range('~4.12') },
	{ src = 'https://github.com/nvim-lualine/lualine.nvim', version = 'b8c2315' },
	{ src = 'https://github.com/folke/snacks.nvim', version = vim.version.range('~2.23') },
	{ src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('~1.7') },
	{ src = 'https://github.com/folke/persistence.nvim', version = vim.version.range('~3.1.0') },
	{ src = 'https://github.com/lewis6991/gitsigns.nvim', version = vim.version.range('~2.1.0') },
})

-- PLUGINS CONFIGURATION

require('tokyonight').setup({
	transparent = transparent,
	styles = {
		floats = transparent and 'transparent' or 'dark',
	},
})

require('lualine').setup({
	sections = {
		lualine_x = { 'lsp_status', 'filetype' },
	},
})

require('snacks').setup({
	picker = {
		formatters = { truncate = 120, },
		layout = { fullscreen = true, },
    win = {
			input = {
				keys = { ['<m-cr>'] = { 'tab', mode = { 'i', 'n' }, desc = 'Open tab' }, },
			},
		},
	},
	terminal = {
		win = {
			position = 'float',
			border = 'single',
		},
	},
})

require('blink.cmp').setup({
	keymap = { preset = 'enter' },
	sources = { default = { 'lsp', 'path' } },
	signature = { enabled = true },
})

require('persistence').setup()
require('gitsigns').setup()

-- LSP CONFIG

vim.lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			-- Keep rust-analyzer from providing function arguments snippets
			completion = { callable = { snippets = 'add_parentheses' }, },
		},
	},
})
vim.lsp.config("pyrefly", {
  settings = {
    python = { pyrefly = { displayTypeErrors = "force-on", }, },
  },
})

vim.lsp.enable('rust_analyzer')
vim.lsp.enable('pyrefly')
vim.lsp.enable('ruff')

-- EDITOR BEHAVIOR

-- Remove highlight after search
vim.keymap.set('n', '<esc>', '<cmd>noh<cr>')

-- Window management
vim.keymap.set('n', 'H', '<cmd>tabprev<cr>', { desc = 'Prev tab' })
vim.keymap.set('n', 'L', '<cmd>tabnext<cr>', { desc = 'Next tab' })
vim.keymap.set('n', '<Leader>bd', function() Snacks.bufdelete.delete() end, { desc = 'Delete buffer' })

-- Diagnostics
vim.diagnostic.config({ signs = false, virtual_lines = false, virtual_text = true, underline = true })
vim.keymap.set('n', 'gK', vim.diagnostic.open_float, { desc = 'Open line diagnostics' })
vim.keymap.set('n', '<Leader>uD', function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = new_config, underline = new_config })
end, { desc = 'Toggle diagnostics' })

-- Pickers
vim.keymap.set('n', '<Leader>ff', function() Snacks.picker.files() end, { desc = 'Find files' })
vim.keymap.set('n', '<Leader>fr', function() Snacks.picker.recent() end, { desc = 'Find recent files' })
vim.keymap.set('n', '<Leader>fb', function() Snacks.picker.buffers() end, { desc = 'Find buffer' })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search grep' })
vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Search word' })
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'Goto References' })
vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })

-- Git
vim.keymap.set('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'Git blame line' })
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit.open() end, { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
local gs = require('gitsigns')
vim.keymap.set('n', '<leader>ghp', function() gs.preview_hunk_inline() end, { desc = 'Preview Hunk Inline' })
vim.keymap.set('n', '<leader>ghb', function() gs.preview_hunk_inline() end, { desc = 'Preview Hunk Inline' })
vim.keymap.set('n', ']h', function() gs.nav_hunk('next') end, { desc = 'Next Hunk' })
vim.keymap.set('n', '[h', function() gs.nav_hunk('prev') end, { desc = 'Previous Hunk' })

-- Code
vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format() end, { desc = 'Format' })
vim.keymap.set('n', '<leader>cr', function() vim.lsp.buf.rename() end, { desc = 'Refactor' })
vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, { desc = 'Code action' })
vim.keymap.set('n', '<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = 'Toggle inlay hints' })

-- Toggle terminal (in mappings, '/' is represented by '_')
vim.keymap.set({ 'n', 't' }, '<c-_>', function() Snacks.terminal() end, { desc = 'Toggle terminal' })

-- Session management
vim.keymap.set('n', '<leader>qs', function() require('persistence').load() end, { desc = 'Load previous session' })

-- UI

vim.cmd('colorscheme tokyonight')
vim.opt.winborder = 'rounded'
vim.opt.cursorline = true
vim.opt.signcolumn = 'auto:1-3'

-- Flash yanked content
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Make backround transparent
if transparent then
	vim.cmd([[
		highlight Normal guibg=none
		highlight NonText guibg=none
		highlight Normal ctermbg=none
		highlight NonText ctermbg=none
		highlight LspInlayHint guibg=none
	]])
end
