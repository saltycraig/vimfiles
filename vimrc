" vim: fdm=indent nowrap ft=vim et sts=2 ts=2 sw=2
" vimrc for 8.2+
" Windows GVim => c:/users/cmaceachern/vimfiles/vimrc
" UNIX => ~/.vim/vimrc
scriptencoding utf-8
set encoding=utf-8
 
runtime defaults.vim
runtime macros/matchit.vim

let mapleader=' '
let maplocalleader='\'

if has('win64')
  call plug#begin('~/vimfiles/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'cormacrelf/vim-colors-github'
Plug 'lifepillar/vim-solarized8'
call plug#end()

set autoindent
set autoread
set belloff=all
set completeopt=menuone,popup
set hidden
set hlsearch
set ignorecase 
set laststatus=2
set listchars=eol:$,space:·,
set modeline
set mouse=a
set noswapfile
set number
set path-=/usr/include
set path+=**10
set relativenumber
set smartcase
set tags=./tags;,tags;
set termguicolors
if has('unix')
  set wildignore=*/.git/*,*/.hg/*,*/.svn/*,*/.node_modules/*,*.o,*.obj
else
  " Windows ('noshellslash')
  set wildignore=*\\.git\\*,*\\.hg\\*,*\\.svn\\*,*\\.node_modules\\*,*.o,*.obj
endif

let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_sizestyle='h'
let g:netrw_winsize=15
let g:netrw_list_hide=netrw_gitignore#Hide() . '.*\.swp$'

if has('gui') || has('xterm_clipboard')
  set clipboard=unnamed,unnamedplus
endif

" Re-select visually selected area after indenting/dedenting.
xmap < <gv
xmap > >gv
" Move visual selection up/down lines.
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv
" '%%' in command-line mode maybe expands to path of current buffer.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

nnoremap <F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <F4> :call utils#ToggleLocationList()<CR>
nnoremap <F5> :silent! make % <bar> copen <bar> silent redraw!<CR>
" nnoremap <F6> :15Lexplore<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>

nnoremap <Leader>w :update<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <Leader>, :edit $MYVIMRC<CR>
if has('win64')
  nnoremap <Leader>t :e <C-R>=expand('~/vimfiles/after/ftplugin/'.&ft.'.vim')<CR><CR>
else
  nnoremap <Leader>t :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
endif
nnoremap <Leader>l :buffer #<CR>
nnoremap <Leader>n :nohl<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>o :CtrlPTag<CR>
nnoremap <C-s> :source %<CR>

" Terminal
tnoremap <Esc> <C-\><C-n> 
tnoremap <C-v><Esc> <Esc>

if has('mac') && has('gui_running')
  " macvim GUI
  set macmeta
  nnoremap ê <C-w>p<C-e><C-w>p
  nnoremap ë <C-w>p<C-y><C-w>p
  nnoremap Ê <C-w>p<C-d><C-w>p
  nnoremap Ë <C-w>p<C-u><C-w>p
elseif has('mac')
  " Alacritty, usually.
  nnoremap ∆ <C-w>p<C-e><C-w>p
  nnoremap ˚ <C-w>p<C-y><C-w>p
  nnoremap Ô <C-w>p<C-d><C-w>p
  nnoremap <C-w>p<C-u><C-w>p
elseif has('win64') && has('gui_running')
  " gVim 64-bit: 'win32' also returns 1
  nnoremap ê <C-w>p<C-e><C-w>p
  nnoremap ë <C-w>p<C-y><C-w>p
  nnoremap Ê <C-w>p<C-d><C-w>p
  nnoremap Ë <C-w>p<C-u><C-w>p
elseif !has('gui') && !has('gui_running')
  " Use Esc (^[) for terminal emulators for Alt support, e.g.
  " bash-for-windows/mintty terminal
  nnoremap j <C-w>p<C-e><C-w>p
  nnoremap k <C-w>p<C-y><C-w>p
  nnoremap J <C-w>p<C-d><C-w>p
  nnoremap K <C-w>p<C-u><C-w>p
endif

augroup vimrc
  autocmd!
augroup END

" Textfiles, vimrc files
autocmd vimrc BufNewFile,BufRead *.txt,*.md,*.adoc setlocal complete+=k
autocmd vimrc BufNewFile,BufRead *.txt,*.md,*.adoc setlocal tw=78
autocmd vimrc BufWinEnter */doc/*.txt setlocal nonumber norelativenumber
if has('win64')
  autocmd vimrc BufWritePost ~/vimfiles/vimrc source ~/vimfiles/vimrc
else
  autocmd vimrc BufWritePost ~/.vim/vimrc source ~/.vim/vimrc
endif

" Quickfix/Location List
autocmd vimrc FileType * if &ft ==# 'qf' | setlocal nonu nornu | endif
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost  l* lwindow
autocmd vimrc VimEnter * cwindow
if (v:version >=# 802)
  packadd! cfilter
endif

" Getting Help Easier
nnoremap <F1>f :help list-functions<CR>
nnoremap <F1>k :help keycodes<CR>
command! Api :help list-functions<CR>

command! Cd :cd %:h
command! TodoLocal :botright lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Only :.+,$bwipeout<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ *<CR>

set background=light
colorscheme solarized8

