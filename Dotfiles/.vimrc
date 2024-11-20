"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" =>  autocmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 打开自动定位到最后编辑的位置, 需要确认 .viminfo 当前用户可写
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" clean extra spaces
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" file header
autocmd BufNewFile *.sh,*.py, exec ":call SetNewFileTitle()"
let $author_name = "Yakir"
func SetNewFileTitle()
    if expand("%:e") == 'py'
        call setline(1,"\#=============================================================")
        call append(line("."), "\# Author: ".$author_name)
        call append(line(".")+1, "\# Created Time: ".strftime("%c"))
        call append(line(".")+2, "\#=============================================================")
        call append(line(".")+3, "\#!/usr/bin/env python")
        call append(line(".")+4, "\#")
    else
        call setline(1,"\#=============================================================")
        call append(line("."), "\# Author: ".$author_name)
        call append(line(".")+1, "\# Created Time: ".strftime("%c"))
        call append(line(".")+2, "\#=============================================================")
        call append(line(".")+3, "\#!/bin/bash")
        call append(line(".")+4, "\#")
    normal G
    normal o
    normal o
    endif
endfun


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => keymaps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = " "
let maplocalleader = "\\"

noremap H ^
noremap L $
nmap <leader>w :w!<cr>

" delete Windows ^M
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" F1~F6
" F1 nothing
noremap <F1> <Esc>"
" F2 NERDTree
map <F2> :NERDTreeToggle<CR>
" F3 generate comment
func SetComment()
    call append(line(".")  , '//**************** comment start ********************')
    call append(line(".")+1, '//**************** comment end   ********************')
endfunc
map <F3> :call SetComment()<CR>j<CR>O
" F4 wrap lines on | off
nnoremap <F4> :set wrap! wrap?<CR>
" F5 paste mode on, disbale paste mode when leaving insert mode
set pastetoggle=<F5>
au InsertLeave * set nopaste
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" F6 syntax on | off
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme and fonts
" fonts install -> https://github.com/powerline/fonts
syntax enable
set encoding=utf8
set ffs=unix,dos,mac
set background=dark
colorscheme solarized
"colorscheme molokai
set t_Co=256

" UI
set mouse=a
set number
set relativenumber
set cursorline
set splitbelow
set splitright
set laststatus=2
set statusline=\ %F%m%r%h\ Format:\%{&fileformat}\ Line:\ %l\ Column:\ %c\ Percent:\ %p%%

" indent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set smartindent
set wrap

" search
set incsearch
set hlsearch
set ignorecase
"set smartcase
set history=512

" code
"set foldenable
"set foldmethod=indent
"set foldlevel=99
filetype on
filetype plugin on
filetype indent on

" optimize
set autoread
set lazyredraw 
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" install -> git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    "Plugin 'VundleVim/Vundle.vim'
    "Plugin 'vim-syntastic/syntastic'
    Plugin 'exvim/ex-colorschemes'
call vundle#end()

