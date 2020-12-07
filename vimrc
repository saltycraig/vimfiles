source $VIMRUNTIME/defaults.vim
packadd! editexisting
if (v:version >=# 802)
  packadd! cfilter
endif

let mapleader=' '
let maplocalleader='\'

augroup init
  autocmd!
augroup END

set autoread
set belloff=all
set complete-=i
" TODO: see how this works with :args **/*.jsx etc., will it scan those?
" set complete-=u | " Don't scan unloaded buffers in buffer list.
set completeopt=menuone,noinsert,noselect
set hidden
set foldnestmax=2
set ignorecase smartcase
set laststatus=2
set noswapfile
set nowrap
set number relativenumber
set omnifunc=syntaxcomplete#Complete
set path=.,,
set spelllang=en_ca
set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set splitbelow splitright
set thesaurus=~/.vim/thesaurus/english.txt
set undofile
set undodir=~/.vim/undodir
set wildignore+=*.o,*.obj,*.pyc,*.pyd,*.dll
set wildignore+=*.exe,*.bin,*.zip
set wildignore+=*.bmp,*.jpg,*.jpeg,*.svg,*.png

let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_sizestyle='h'
let g:netrw_winsize=15

packadd! photon.vim
packadd! tagbar
packadd! targets.vim
packadd! vim-commentary
packadd! vim-dispatch
packadd! vim-editorconfig
packadd! vim-endwise
packadd! vim-indent-object
packadd! vim-repeat
packadd! vim-surround
packadd! vim-unimpaired

set wildcharm=<C-z>
nnoremap <Leader>e :edit **/*<C-z><S-Tab>
nnoremap <Leader>E :split **/*<C-z><S-Tab>
nnoremap <Leader>ve :vsplit<CR>:edit **/*<C-z><S-Tab>

nnoremap <Leader>b :buffer <C-z><S-Tab>*
nnoremap <Leader>B :buffers!<CR>:b
nnoremap <Leader>vb :vsplit<CR>:buffer <C-z><S-Tab>*

nnoremap <Leader>f :find **/*<C-z><S-Tab>
nnoremap <Leader>F :split<CR>:find **/*<C-z><S-Tab>
nnoremap <Leader>vf :vsplit<CR>:find **/*<C-z><S-Tab>

nnoremap <Leader>o :g//#<Left><Left>
set splitbelow
set splitright

nnoremap <silent><F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <silent><F4> :call utils#ToggleLocationList()<CR>
nnoremap <silent><F5> :silent! make % <bar> copen <bar> silent redraw!<CR>
nnoremap <silent><F6> :15Lexplore<CR>
nnoremap <silent><F8> :TagbarToggle<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>
nnoremap <silent><Leader>tn :tabnew<CR>
tnoremap <Esc> <C-\><C-n>
" Sending actual Esc char requires this because of above line.
tnoremap <C-v><Esc> <Esc>
nnoremap <Leader>w :update<CR>
nnoremap <Leader>h :hide<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <silent><Leader>n :nohlsearch<CR>
nnoremap <silent><Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>ft :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
if has('unix')
  " mintty on win 10 sends ^@ which is <Nul> in Vim notation
  inoremap <Nul> <C-x><C-o>
  " tnoremap <silent> <Esc>` <C-w>:ToggleTerminal<CR>
  " nnoremap <silent> <Esc>` :ToggleTerminal<CR>
  nnoremap <Esc>j <C-w>p<C-e><C-w>p
  nnoremap <Esc>k <C-w>p<C-y><C-w>p
elseif has('mac')
  nnoremap ∆ <C-w>p<C-e><C-w>p
  nnoremap ˚ <C-w>p<C-y><C-w>p
  " TODO: setup toggleterminal command mapping like above for mac.

  " TODO: fix Ctrl-^ requiring Shift be pressed as well
  " Dropping a bunch of files onto MacVim opens each in its own tab,
  " and the default is only 10, so bump it up on MacVim.
  set tabpagemax=100
endif

inoreabbrev (<CR> (<CR>)<Esc>O
inoreabbrev ({<CR> ({<CR>});<Esc>O
inoreabbrev {<CR> {<CR>}<Esc>O
inoreabbrev {; {<CR>};<Esc>O
inoreabbrev {, {<CR>},<Esc>O
inoreabbrev [<CR> [<CR>]<Esc>O
inoreabbrev [; [<CR>];<Esc>O
inoreabbrev [, [<CR>],<Esc>O
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

autocmd init QuickFixCmdPost [^l]* cwindow
autocmd init QuickFixCmdPost  l* lwindow
autocmd init VimEnter * cwindow
autocmd init BufWritePre /tmp/* setlocal noundofile
autocmd init BufNewFile,BufRead *.txt,*.md,*.adoc setlocal complete+=k
" Fixes reviving unlisted buffer (:buffers!), because FileType is not run
autocmd init BufWinEnter */doc/*.txt setlocal nonumber norelativenumber
autocmd init BufWritePost ~/.vim/vimrc source ~/.vim/vimrc

command! Todo :silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ **<CR>
command! LocalTodo :lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Cd :cd %:h
command! Only :.+,$bwipeout<CR>
command! Api :vertical h function-list<CR>
command! API :vertical h function-list<CR>

" Better prompts for :ls/files/buffers/dlist/ilist etc.
" https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
function! CCR()
  let cmdline = getcmdline()
  if cmdline =~ '\v\C^(ls|files|buffers)'
    return "\<CR>:b"
  elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
    return "\<CR>:"
  elseif cmdline =~ '\v\C^(dli|il)'
    return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
  elseif cmdline =~ '\v\C^(cli|lli)'
    return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
  elseif cmdline =~ '\C^old'
    set nomore
    return "\<CR>:sil se more|e #<"
  elseif cmdline =~ '\C^changes'
    set nomore
    return "\<CR>:sil se more|norm! g;\<S-Left>"
  elseif cmdline =~ '\C^ju'
    set nomore
    return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
  elseif cmdline =~ '\C^marks'
    return "\<CR>:norm! `"
  elseif cmdline =~ '\C^undol'
    return "\<CR>:u "
  else
    return "\<CR>"
  endif
endfunction
cnoremap <expr> <CR> CCR()

" TODO: install vim-ocs52

rviminfo!
silent! helptags ALL
colorscheme photon
" Alter photon.vim to make comments red.
highlight Comment ctermfg=167

