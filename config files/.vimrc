syntax on
set number
set termguicolors
set background=dark
set clipboard=unnamed

call plug#begin()
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'lifepillar/vim-cheat40'
call plug#end()

colorscheme catppuccin_mocha
let mapleader = " "
