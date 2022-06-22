" This line makes pacman-installed global Arch Linux vim packages work.
source /usr/share/nvim/archlinux.vim

" <!-- Encoding Configuration -->
set encoding=utf-8
scriptencoding utf-8

" <!-- General -->
set nocompatible

" <!-- Indentation -->
set sw=4 et
set softtabstop=4
set tabstop=4
set expandtab
set cin noai
set tw=80 cc=80
set nojoinspaces
set formatoptions=cloqr
set shiftwidth=4
set autoindent
set number relativenumber
set wildmode=longest,list
set mouse=v
set mouse=a
set clipboard=unnamedplus
set cursorline
set ttyfast
set noswapfile
set hlsearch
set incsearch
set smartcase ignorecase
filetype plugin indent on
filetype plugin on
syntax on

" <!-- Navigation -->
set nofoldenable
set foldmethod=marker
set numberwidth=3
set nostartofline

" <!-- Display -->
set nowrap
set ruler
set list
set scrolloff=5
set laststatus=2

" <!-- Title -->
set title
set titlestring=%t
set titleold=

" <!-- History -->
set history=10000
set viminfo+=:10000

" <!-- Plugins -->
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'shaunsingh/nord.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim'
Plug 'lewis6991/impatient.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'jbgutierrez/vim-better-comments'
call plug#end()

" <!-- Color Scheme -->
" Nord Tweaks
let g:nord_contrast = v:true
let g:nord_borders = v:true
let g:nord_disable_background = v:true
let g:nord_italic = v:true

" Load the colorscheme
colorscheme nord

" Custom Tweaks
highlight ColorColumn ctermbg=0 guibg=#4c566a
highlight Normal ctermfg=white ctermbg=black
autocmd ColorScheme * highlight CursorLineNr cterm=bold term=bold gui=bold

" Load lua stuff
:luafile ~/.config/nvim/lua/init.lua
