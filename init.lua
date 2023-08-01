vim.cmd([[
set number
set relativenumber
set autoindent
set tabstop=4
set smarttab
set softtabstop=4
set mouse=a
set expandtab ts=4 sw=4 ai
]])

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
		{
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {                                      -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.api.nvim_command, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'L3MON4D3/LuaSnip'},     -- Required
    }
  },
  {
		  'tpope/vim-surround'
  },
  {
		  'preservim/nerdtree'
  },{
		  'theprimeagen/harpoon'
  },{
		  'tpope/vim-fugitive'
  },{
		  'nvim-treesitter/nvim-treesitter' --Treeshitter
  },{
		  'nvim-telescope/telescope.nvim' -- Fuzzy finder
  },{
		  'nvim-lua/plenary.nvim'
  },{
		  'preservim/tagbar' --Tagbar for code navigation
  },{
		  'terryma/vim-multiple-cursors' --CTRL + N for multiple cursors
  },{
		  'tc50cal/vim-terminal' --Vim Terminal
  },{
		  'ryanoasis/vim-devicons' --Developer Icons
  },{
		  'rafi/awesome-vim-colorschemes' --Retro Scheme
  },{
		  'ap/vim-css-color' --CSS Color Preview
  },{
		  'vim-airline/vim-airline' --Status bar
  },{
		  'tpope/vim-surround' --Surrounding ysw)
  },{
		  'tpope/vim-commentary' --For Commenting gcc & gc
  },{
      'rose-pine/neovim'
  }
})

if vim.fn.has('nvim') == 1 then
    vim.cmd 'set termguicolors'
    vim.cmd 'highlight clear Italic'
    vim.cmd 'highlight Italic gui=NONE cterm=NONE'
end

vim.cmd.colorscheme("rose-pine")

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

nmap("<C-q>", ": NERDTreeToggle<cr>")

vim.g.mapleader = " "

nmap("<leader>pf", "<cmd>lua require 'telescope.builtin'.find_files()<cr>")
nmap("<C-p>", "<cmd>lua require 'telescope.builtin'.git_files()<cr>")
nmap("<leader>ps", "<cmd> lua require('telescope.builtin').grep_string({search=vim.fn.input('Grep > ')})<cr>")

nmap("<C-s>", " :w<cr>")

nmap("<leader>g", ":noh<cr>")

nmap("<leader>r", ":!%:p")

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {"rust", "javascript", "python", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,


  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}



local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1)end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2)end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3)end)
vim.keymap.set("n", "<C-b>", function() ui.nav_file(4)end)

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>dl", ":normal 0dg_<cr>")
vim.keymap.set("n", "<leader>yl", ":normal 0yg_<cr>")
vim.keymap.set("n", "<leader>cl", ":normal 0yyp<cr>")

vim.keymap.set("n", "<leader>f", ":LspZeroFormat<cr>")


local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client,bufnr)
		lsp.default_keymaps({buffer=bufnr})
end)

lsp.ensure_installed({
		'eslint',
		'rust_analyzer',
		'pyright'
})

lsp.set_preferences({ sign_icons = { } })

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["C-space>"] = cmp.mapping.complete()
})

lsp.setup()



