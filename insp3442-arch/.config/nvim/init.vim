set nocompatible
set mouse=v
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set number relativenumber
set wildmode=longest,list
" set cc=80
set mouse=a
set clipboard=unnamedplus
set cursorline
set ttyfast
set noswapfile
filetype plugin indent on
filetype plugin on
syntax on

call plug#begin()
Plug 'shaunsingh/nord.nvim'
call plug#end()

" Example config in Vim-Script
let g:nord_contrast = v:true
let g:nord_borders = v:true
let g:nord_disable_background = v:true
let g:nord_italic = v:true

" Load the colorscheme
colorscheme nord
