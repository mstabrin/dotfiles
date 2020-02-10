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
" Indent guides
Plugin 'https://github.com/nathanaelkane/vim-indent-guides.git'
" Nice looking tables
Plugin 'https://github.com/dhruvasagar/vim-table-mode.git'
" Smooth scrolling
Plugin 'https://github.com/cskeeters/vim-smooth-scroll.git'
" You complete me
"Plugin 'https://github.com/Valloric/YouCompleteMe.git'

call vundle#end()

""""""""""""""" Basic functions

source ${DOTFILES}/vimrc_basic

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
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": ["ruby", "php"],
    \ "passive_filetypes": ["puppet"]
    \ }

"""""""""""""""" Vim indent guide
set ts=4 sw=4 et
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_tab_guides = 0
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
