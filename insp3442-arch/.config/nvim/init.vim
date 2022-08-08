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
" Run :PlugInstall to update
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'shaunsingh/nord.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'lewis6991/impatient.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'jbgutierrez/vim-better-comments'
call plug#end()

" <!-- Color Scheme -->
" Nord Tweaks
let g:nord_disable_background = v:true
let g:nord_contrast = v:true
let g:nord_enable_sidebar_background = v:true
let g:nord_italic = v:true
"let g:nord_borders = v:true
" Load the colorscheme
colorscheme nord

" Custom Tweaks
highlight ColorColumn ctermbg=0 guibg=#4c566a
highlight Normal ctermfg=white ctermbg=black
autocmd ColorScheme * highlight CursorLineNr cterm=bold term=bold gui=bold

" <-- COC -->
" CocInstall coc-json coc-tsserver coc-pyright
" Tweaks
highlight CocNotificationProgress guibg=#4c566a guifg=#5e81ac
highlight CocNotificationButton guibg=#4c566a guifg=#5e81ac
highlight CocNotificationError guibg=#4c566a guifg=#5e81ac
highlight CocNotificationWarning guibg=#4c566a guifg=#5e81ac
highlight CocNotificationInfo guibg=#4c566a guifg=#5e81ac

" Custom Functions
function! OpenFile()
    " Get input
    call inputsave()
    let s:path = input("Open: ", expand('%:p:h'), "file")
    while len(s:path) == 0
        let s:path = input("Invalid. Open: ", "", "file")
    endwhile
    call inputrestore()
    " Create a new tab and edit
    execute 'tabnew'
    execute 'edit 's:path
endfunction

" Keybindings
" Buffer Control
map <silent> <C-f> :call OpenFile()<CR>
map <silent> <M-Left> :bp<CR>
map <silent> <M-Right> :bn<CR>
map <silent> <C-l> :bd<CR>

" Load lua stuff
:luafile ~/.config/nvim/lua/init.lua
