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

set rtp+=/usr/local/opt/fzf
set updatetime=100

set background=dark
colorscheme solarized8

function! ClangFormatFull()
    let l:lines = "all"
    py3f /usr/local/Cellar/clang-format/10.0.1/share/clang/clang-format.py
endfunction

function! ClangFormatOnSave()
    let l:formatdiff = 1
    py3f /usr/local/Cellar/clang-format/10.0.1/share/clang/clang-format.py
endfunction

command! ClangFormat call ClangFormatFull()

autocmd! bufwritepost .vimrc source %
autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.cc call ClangFormatOnSave()

nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>
nnoremap <3-MiddleMouse> <Nop>
nnoremap <4-MiddleMouse> <Nop>

inoremap <MiddleMouse> <Nop>
inoremap <2-MiddleMouse> <Nop>
inoremap <3-MiddleMouse> <Nop>
inoremap <4-MiddleMouse> <Nop>

let mapleader = ","
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
map <Leader>o <esc>:Tagbar<CR>
nnoremap <Leader>jd :YcmCompleter GoTo<CR>
nnoremap <Leader>jr :YcmCompleter GoToReferences<CR>
nnoremap <Leader>jt :YcmCompleter GetType<CR>

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
set guifont=SourceCodePro+Powerline+AwesomeRegular:h14

" map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>
map <Leader>p i#!/usr/bin/env python<CR># -*- coding: utf-8 -*-<CR><C-c>
map <Leader>h :vsp<CR>:FSRight<CR>

" Fzf stuff
map <C-P> :Files<CR>
imap <C-P> :Files<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

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
let g:ycm_always_populate_location_list = 1

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
