""""""""""""""""" Vundle

" Preperation for Vundle setup
set nocompatible
filetype off

" Vundle Setup
set rtp+=${DOTFILES}/vim-plugin/Vundle.vim
call vundle#begin('$DOTFILES/vim-plugin')
" Handle Vundle
Plugin 'VundleVim/Vundle.vim'
" Nerdtree
Plugin 'https://github.com/scrooloose/nerdtree.git'
" Fugitive for git commands
Plugin 'https://github.com/tpope/vim-fugitive.git'
" Syntax highlighting
Plugin 'https://github.com/vim-syntastic/syntastic.git'
" Surround vim
Plugin 'https://github.com/tpope/vim-surround.git'
" Hardcore mode
Plugin 'https://github.com/wikitopian/hardmode.git'
" Wakatime
Plugin 'https://github.com/wakatime/vim-wakatime.git'

call vundle#end()

"""""""""""""""" syntax and indent

" Use colorscheme
colorscheme peachpuff

" load filetype-specific indent files
filetype plugin indent on 
" Enable syntax
syntax enable
" better visual line breaks
set breakindent
"·width·of·tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" enable folding
set foldmethod=indent
set foldlevel=99

"""""""""""""""" Vim Look and Feel

" Always split to the right or below
set splitright
set splitbelow
" Relative numbers
set relativenumber
" line numbers
set number
" syntax highlighting
syntax on
" show the command in bottom line
set showcmd
" Highlight current line
set cursorline
" list whitespaces and some other characters
set listchars=tab:>-,space:·,eol:✂︎
set list
" Color for special keys
hi SpecialKey ctermfg=59
hi NonText ctermfg=59
" redraw only when we need to.
set lazyredraw
" encoding
set encoding=utf-8
" file format
set fileformat=unix
" Bar hinting for 80 chars
set colorcolumn=81

""""""""""""""""" Search things

" path for subfolders
set path=**
" visual autocomplete for command menu
set wildmenu

""""""""""""""" Nerdtree

" Open nerd tree when vim starts up
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open nerd tree with shift-tab
map <S-tab> :NERDTreeToggle<CR>

"""""""""""""""" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

