set encoding=utf-8
set guioptions-=T
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set tw=0

set noerrorbells
set visualbell
set t_vb=
set printoptions=paper:A4,duplex:off,collate:n,syntax:y

set background=dark
colorscheme solarized8

function! ClangFormat()
    py3f /usr/share/clang/clang-format-10/clang-format.py
endfunction

function! ClangFormatFull()
    let l:formatdiff = 0
    call ClangFormat()
endfunction

function! ClangFormatOnSave()
    let l:formatdiff = 1
    call ClangFormat()
endfunction

command! ClangFormat call ClangFormatFull()

autocmd! bufwritepost .vimrc source %
autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.cc call ClangFormatOnSave()

let mapleader = ","
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
nnoremap <Leader>jd :YcmCompleter GoTo<CR>

vnoremap <Leader>s :sort<CR>

"map <C-K> :py3f /usr/share/clang/clang-format-10/clang-format.py<cr>
"imap <C-K> <c-o>:py3f /usr/share/clang/clang-format-10/clang-format.py<cr>

" Indent
vnoremap < <gv
vnoremap > >gv

set number
set colorcolumn=88
highlight ColorColumn ctermbg=233


" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
" set t_Co=256
set guifont=Menlo\ for\ Powerline\ 9

" For ctrlp
" let g:ctrlp_max_height = 30
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10000'
set wildignore+=*.pyc
set wildignore+=*.o
set wildignore+=*.d
set wildignore+=*build*/
set wildignore+=*/coverage/*
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>
map <Leader>p i#!/usr/bin/env python<CR># -*- coding: utf-8 -*-<CR><C-c>
map <Leader>h :vsp<CR>:FSRight<CR>

set nocp
filetype plugin on

set hlsearch

set backupdir=~/.vim/backup_files//
set directory=~/.vim/swap_files//
set undodir=~/.vim/undo_files//

set list
set showbreak=↪\ 
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_list_stop_completion = ['<C-y>', '<Enter>']

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

let g:airline_powerline_fonts = 1
let g:airline_theme='dark'

let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="horizontal"

let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
