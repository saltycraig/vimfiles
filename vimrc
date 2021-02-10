" vim: fdm=marker

" Bootstrapping {{{
scriptencoding utf-8 " because I use multi-byte mac keys below

let vimplug_exists=expand('~/.vim/autoload/plug.vim')
if has('win32') && !has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr 'You have to install curl or first install vim-plug yourself!'
    execute 'q!'
  endif
  echo 'Installing vim-plug into ~/.vim/autoload/plug.vim'
  echo ''
  silent exec '!'curl_exists' -fLo ' . shellescape(vimplug_exists) . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let g:not_finish_vimplug = 'yes'
  autocmd init VimEnter * PlugInstall
endif
"}}}

" Plugins {{{
call plug#begin(expand('~/.vim/plugged'))
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'Raimondi/delimitMate'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'wellle/targets.vim'
call plug#end()
"}}}

" Plugin settings {{{
" https://github.com/itchyny/lightline.vim
let g:lightline = {
\ 'colorscheme': 'gruvbox',
\}

" https://github.com/junegunn/fzf.vim
let g:fzf_preview_window = ''
let g:fzf_layout = { 'down': '20%'}
autocmd! FileType fzf
autocmd FileType fzf set ls=0 nosmd noru nonu nornu
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler number rnu
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

" https://github.com/majutsushi/tagbar
let g:tagbar_autofocus = 0
nnoremap <silent><Leader>o :TagbarToggle<CR> 
nnoremap <silent><Leader>e :FZF<CR>
nnoremap <silent><Leader>b :Buffers<CR>

"}}}

" Builtin settings {{{
set autoread
set belloff=all
set complete-=i
set completeopt=menuone,noinsert,noselect
set directory=~/.vim/swapdir
set hidden
set hlsearch
set foldnestmax=2
set ignorecase smartcase
set laststatus=2
set mouse=a
set mousemodel=popup
set noswapfile
set nowrap
set number relativenumber
set spelllang=en_ca
set splitbelow splitright
set swapfile
set termguicolors
set undofile
set undodir=~/.vim/undodir
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_sizestyle='h'
let g:netrw_winsize=15

if has('gui') || has('xterm_clipboard')
  set clipboard=unnamed,unnamedplus
endif

let python_highlight_all = 1
"}}}

" Tool Integrations {{{
"}}}

" Key bindings {{{
let mapleader=' '
let maplocalleader='\'

" Center the screen on the jump to the next find result
nnoremap n nzzzv
nnoremap N Nzzzv
" Re-select visually selected area after indenting/dedenting
vmap < <gv
vmap > >gv
" Move visual selection up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
nnoremap <silent><F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <silent><F4> :call utils#ToggleLocationList()<CR>
nnoremap <silent><F5> :silent! make % <bar> copen <bar> silent redraw!<CR>
nnoremap <silent><F6> :15Lexplore<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>
nnoremap <silent><Leader>tn :tabnew<CR>
nnoremap <Leader>w :update<CR>
nnoremap <Leader>h :hide<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <Leader>n :nohlsearch<CR>
nnoremap <Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>ft :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
nnoremap <Leader>` :terminal<CR>
nnoremap <Leader>m :terminal ++open make<CR>
tnoremap <Esc> <C-\><C-n> tnoremap <C-v><Esc> <Esc>
if has('mac')
  nnoremap ∆ <C-w>p<C-e><C-w>p
  nnoremap ˚ <C-w>p<C-y><C-w>p
  nnoremap Ô <C-w>p<C-d><C-w>p
  nnoremap  <C-w>p<C-u><C-w>p
endif
"}}}

" Autocmds {{{
augroup init
  autocmd!
augroup END
autocmd init BufNewFile,BufRead *.txt,*.md,*.adoc setlocal complete+=k
autocmd init BufWinEnter */doc/*.txt setlocal nonumber norelativenumber
autocmd init BufWritePre /tmp/* setlocal noundofile
autocmd init BufWritePost ~/.vim/vimrc source ~/.vim/vimrc
autocmd init FileType * if &ft ==# 'qf' | set nonu nornu | endif
autocmd init QuickFixCmdPost [^l]* cwindow
autocmd init QuickFixCmdPost  l* lwindow
autocmd init VimEnter * cwindow
"}}}

" Commands {{{
command! Api :vertical h function-list<CR>
command! API :vertical h function-list<CR>
command! Cd :cd %:h
command! LocalTodo :botright lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Only :.+,$bwipeout<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ **<CR>
"}}}

" UI {{{
set background=light
colorscheme gruvbox
"}}}

" Playground {{{
"}}}
