-- GLOBAL OPTIONS

vim.g.mapleader = ' '

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 6
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showtabline = 2
vim.opt.backupcopy = "yes"

-- Set tabswidth
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

local transparent = false

-- PLUGINS DECLARATION

vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig', version = vim.version.range('~2.5') },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/folke/tokyonight.nvim', version = vim.version.range('~4.12') },
  { src = 'https://github.com/SmiteshP/nvim-navic', version = 'master' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim', version = 'b8c2315' },
  { src = 'https://github.com/folke/snacks.nvim', version = vim.version.range('~2.23') },
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('~1.7') },
  { src = 'https://github.com/folke/persistence.nvim', version = vim.version.range('~3.1') },
  { src = 'https://github.com/lewis6991/gitsigns.nvim', version = vim.version.range('~2.1') },
  { src = 'https://github.com/nvim-mini/mini.icons', version = 'main' },
  { src = 'https://github.com/stevearc/conform.nvim', version = vim.version.range('~9.1') },
})

-- PLUGINS CONFIGURATION

require('nvim-treesitter').setup()

require('tokyonight').setup({
	transparent = transparent,
	styles = {
		floats = transparent and 'transparent' or 'dark',
	},
	on_colors = function(colors)
		colors.fg = '#ffffff'
	end,
	on_highlights = function(highlights, colors)
		highlights.TabLine = { bg = '#1e2030', fg = '#ffffff' }
	end
})

require('nvim-navic').setup({
  lsp = { auto_attach = true },
  lazy_update_context = false,
})

require('lualine').setup({
	sections = {
    lualine_b = { 'filename' },
    lualine_c = { 'navic' },
		lualine_x = { 'lsp_status' },
	},
})

require('snacks').setup({
	picker = {
		formatters = {
      file = {
        truncate = 120,
        -- min_width = 120,
      }
    },
		layout = { fullscreen = true, },
    win = {
			input = {
				keys = { ['<m-cr>'] = { 'tab', mode = { 'i', 'n' }, desc = 'Open in new tab' }, },
			},
		},
	},
	terminal = {
		win = {
			position = 'float',
			border = 'single',
		},
	},
  gitbrowse = {
    what = "permalink",
    url_patterns = {
      ["github%.com"] = {
        branch = "/tree/{branch}",
        file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
        permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
        commit = "/commit/{commit}",
      },
      ["gitlab.+net"] = {
        branch = "/-/tree/{branch}",
        file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
        permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
        commit = "/-/commit/{commit}",
      },
    }
  },
})

require('blink.cmp').setup({
	keymap = { preset = 'enter' },
	sources = { default = { 'lsp', 'path' } },
	signature = { enabled = true },
	completion = {
		menu = { auto_show = false, },
		documentation = { auto_show = true },
	},
})

require('conform').setup({
   formatters_by_ft = {
      cpp = { 'clang_format' },
   },
   -- formatters = {
   --    clang_format = { command = { 'clang-format-18' } },
   -- }
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
vim.lsp.config('pyrefly', {
  settings = {
    python = { pyrefly = { displayTypeErrors = 'force-on', }, },
  },
})
vim.lsp.config('clangd', {
	cmd = { 'clangd-18', '--background-index' },
})
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemas = {
        ["/home/cdury/repos/TitanProcessing/api/titan_pipeline_schema.yaml"] = {
          "/home/cdury/helper/repos/TitanProcessing/*_pipelines/*",
          "/home/cdury/repos/TitanProcessing/units/*/tests/pipelines/*.yaml",
        },
      },
    },
    redhat = { telemetry = { enabled = false } },
  },
})

vim.lsp.enable('clangd')
vim.lsp.enable('pyrefly')
vim.lsp.enable('ruff')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('yamlls')

-- Add Vue.js capabilities into vtsls
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = '/home/cdury/.bun/bin/vue-language-server',
  languages = { 'vue' },
  configNamespace = 'typescript',
}
vim.lsp.config('vtsls', {
    settings = { vtsls = { tsserver = { globalPlugins = { vue_plugin }, }, }, },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  }
)
vim.lsp.enable({ 'vtsls', 'vue_ls' })

-- KEYMAPS

-- Remove highlight after search
vim.keymap.set('n', '<esc>', '<cmd>noh<cr>')
-- Keep visual selection after shifting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
-- Yank visual selection into clipboard
vim.keymap.set('v', 'Y', '"+y')

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
vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Search Resume' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Search Diagnostics Buffer' })
vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics() end, { desc = 'Search Diagnostics' })
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gtd', function() vim.cmd('tab split') Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition (New Tab)' })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gtD', function() vim.cmd('tab split') Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration (New Tab)' })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'Goto References' })
vim.keymap.set('n', 'gtr', function() vim.cmd('tab split') Snacks.picker.lsp_references() end, { nowait = true, desc = 'Goto References (New Tab)' })
vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
vim.keymap.set('n', 'gty', function() vim.cmd('tab split') Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition (New Tab)' })

-- Git
vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_log_line() end, { desc = 'Git Blame Line' })
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit.open() end, { desc = 'Lazygit' })
vim.keymap.set({ 'n', 'v' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
local gs = require('gitsigns')
vim.keymap.set('n', '<leader>ghp', function() gs.preview_hunk_inline() end, { desc = 'Preview Hunk Inline' })
vim.keymap.set('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, { desc = 'Blame Hunk' })
vim.keymap.set('n', '<leader>ghr', function() gs.reset_hunk() end, { desc = 'Blame Hunk' })
vim.keymap.set('n', ']h', function() gs.nav_hunk('next') end, { desc = 'Next Hunk' })
vim.keymap.set('n', '[h', function() gs.nav_hunk('prev') end, { desc = 'Previous Hunk' })

-- Code
vim.keymap.set('n', '<leader>cr', function() vim.lsp.buf.rename() end, { desc = 'Refactor' })
vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, { desc = 'Code action' })
vim.keymap.set('n', '<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = 'Toggle inlay hints' })
vim.keymap.set('n', 'yp', function() vim.fn.setreg('+', vim.fn.expand('%')) end, { desc = 'Yank path' })

-- Toggle terminal (in mappings, '/' is represented by '_')
vim.keymap.set({ 'n', 't' }, '<c-_>', function() Snacks.terminal() end, { desc = 'Toggle terminal' })

-- Session management
vim.keymap.set('n', '<leader>qs', function() require('persistence').load() end, { desc = 'Load previous session' })

-- Treesitter highlighting
vim.keymap.set('n', '<leader>ut', function() vim.treesitter.start() end, { desc = 'Enable Treesitter Highlighting' })
vim.keymap.set('n', '<leader>uT', function() vim.treesitter.stop() end, { desc = 'Disable Treesitter Highlighting' })
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'c', 'cpp', 'lua', 'python', 'rust', 'typescript', 'javascript'},
	callback = function() vim.treesitter.start() end,
})

-- Format on save
local format_on_save = false
vim.keymap.set('n', '<leader>cF', function() format_on_save = not format_on_save end, { desc = 'Toggle format on save' })
vim.keymap.set('n', '<leader>cf', function() require('conform').format({ lsp_format = 'fallback' }) end, { desc = 'Format current buffer' })
vim.api.nvim_create_autocmd('BufWritePre', {
   pattern = '*',
   callback = function(args)
      if format_on_save then
         require('conform').format({ bufnr = args.buf, lsp_format = 'fallback' })
      end
   end,
})

-- Text manipulation
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+1' <cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-2' <cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+1\" <cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-2\" <cr>gv=gv", { desc = "Move Up" })

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
