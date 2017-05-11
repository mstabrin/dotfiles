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
" Indent guides
Plugin 'https://github.com/nathanaelkane/vim-indent-guides.git'
" Nice looking tables
Plugin 'https://github.com/dhruvasagar/vim-table-mode.git'
" Smooth scrolling
Plugin 'https://github.com/cskeeters/vim-smooth-scroll.git'

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
" Edit previous text and over linebreaks
set backspace=indent,eol,start

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
" encoding
set encoding=utf-8
" show the command in bottom line
set showcmd
" list whitespaces and some other characters
set listchars=tab:>-,space:·,eol:✂︎
set list
" Color for special keys
hi SpecialKey ctermfg=59
hi NonText ctermfg=59
hi CursorLineNr ctermbg=59 ctermfg=white
" redraw only when we need to.
set lazyredraw
" file format
set fileformat=unix
" Bar hinting for 80 chars
set colorcolumn=81
highlight ColorColumn ctermbg=darkgray

""""""""""""""""" Search things

" path for subfolders
set path=**
" visual autocomplete for command menu
set wildmenu

set statusline=
set statusline+=%7*\[%n]                                  "buffernr
set statusline+=%1*\ %<%F\                                "File+path
set statusline+=%2*\ %y\                                  "FileType
set statusline+=%3*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
set statusline+=%3*\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
set statusline+=%4*\ %{&ff}\                              "FileFormat (dos/unix..) 
set statusline+=%8*\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
set statusline+=%9*\ col:%03c\                            "Colnr
set statusline+=%0*\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.
set laststatus=2

" Do case insensitive search
set ignorecase
" Dont ignore if capital letters are used
set smartcase

""""""""""""""" local settings
set exrc " Load vimrc in current directory
set secure " Save vimrc content

"""""""""""""""" Remap keys

""""""""""""""" Nerdtree

" Open nerd tree when vim starts up
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open nerd tree with shift-tab
map <S-tab> :NERDTreeToggle<CR>
" Close nerdtree if it is the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"""""""""""""""" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

"""""""""""""""" Vim indent guide
set ts=4 sw=4 et
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=grey   ctermbg=grey
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgrey ctermbg=darkgrey

""""""""""""""" Vim table
"Markdown table mode
let g:table_mode_corner="|"

"""""""""""""" Align lines with the visual mode command \al
fun! AlignStuff(replace_string, arg) "{{{
    echo "'<,'>s/".a:arg."/".a:replace_string.a:arg."/g | '<,'>!column -t -s '".a:replace_string."'"
    execute "'<,'>s/".a:arg."/".a:replace_string.a:arg."/g | '<,'>!column -t -s '".a:replace_string."'"
endfunction "}}}
command! -nargs=* Align call AlignStuff(<f-args>)
vmap \al :<BS><BS><BS><BS><BS>Align \| 

""""""""""""" Increment visual selected Text
fun! Incr()
    let a = line('.') - line("'<")
    let c = virtcol("'<")
    if a > 0
        execute 'normal! '.c.'|'.a."\<C-a>"
    endif
    normal `<
endfunction
vmap \inc :call Incr()<CR>

"""""""""""" Adjust smart scroll speed
let g:ms_per_line=5
