" vim: fdm=indent nowrap ft=vim et sts=2 ts=2 sw=2
" vimrc for 8.2+
" macOS/Linux/BSD/WSL do: 
" git clone https://github.com/k-takata/minpac ~/.vim/pack/minpac/opt/minpac

" Bare-basics.
filetype plugin on " enable loading plugin/foo.vim files for all filetypes
filetype indent on " enable loading indent/foo.vim files for all filetypes
syntax on
set encoding=utf-8
scriptencoding utf-8
let mapleader=' '

" Plugins
packadd minpac
if !exists('g:loaded_minpac')
  " minpac is not available.
  echoerr 'First clone k-takata/minpac ~/.vim/pack/minpac/opt/minpac'
  finish
else
  " 2: (Default) Show error messages from external commands.
  " 3: Show start/end messages for each plugin.
  " 4: Show debug messages.
  call minpac#init({'verbose': 3, 'progress_open': 'vertical'})
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('tpope/vim-scriptease', {'type': 'opt'})
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-endwise')
  call minpac#add('tpope/vim-obsession')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-unimpaired')
  call minpac#add('wellle/targets.vim')
  call minpac#add('michaeljsmith/vim-indent-object')
  call minpac#add('tpope/vim-projectionist')
  call minpac#add('tpope/vim-dispatch')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('arcticicestudio/nord-vim')
  call minpac#add('vim-airline/vim-airline')
  call minpac#add('vim-airline/vim-airline-themes')
  " Download binary, update config files for keybindings (bash, zsh), after
  " every update.
  call minpac#add('junegunn/fzf', {'do': { -> system('install --all --no-fish') }})
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('dense-analysis/ale')
  call minpac#add('janko-m/vim-test')
  call minpac#add('sgur/vim-editorconfig')
  " LSP 
  call minpac#add('prabirshrestha/asyncomplete.vim')
  call minpac#add('prabirshrestha/asyncomplete-lsp.vim')
  call minpac#add('prabirshrestha/asyncomplete-buffer.vim')
  call minpac#add('prabirshrestha/asyncomplete-file.vim')
  call minpac#add('prabirshrestha/asyncomplete-tags.vim')
  call minpac#add('prabirshrestha/vim-lsp')
  call minpac#add('mattn/vim-lsp-settings')
 
  command! PackUpdate call minpac#update()
  command! PackClean call minpac#clean()
endif

" ==================
" Plugin Settings
" ==================
" Refer to wiki for individual server setup (manual) if an installer
" via mattn/vim-lsp-settings is not provided for that language. If supported,
" we can simply run :LspInstall <server-name>
" Help: https://github.com/prabirshrestha/vim-lsp/wiki/Servers
let g:asyncomplete_auto_popup = 1 " default is 1

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
  \ 'name': 'buffer',
  \ 'allowlist': ['*'],
  \ 'blocklist': ['go'],
  \ 'completor': function('asyncomplete#sources#buffer#completor'),
  \ 'config': {
  \    'max_buffer_size': 5000000,
  \  },
  \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
  \ 'name': 'file',
  \ 'allowlist': ['*'],
  \ 'priority': 10,
  \ 'completor': function('asyncomplete#sources#file#completor')
  \ }))

" Requires we have :echo executable('ctags') to be 1 (installed ctags)
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
  \ 'name': 'tags',
  \ 'allowlist': ['c', 'ruby'],
  \ 'completor': function('asyncomplete#sources#tags#completor'),
  \ 'config': {
  \    'max_file_size': 50000000,
  \  },
  \ }))

" I find this to be buggy and not work well with Vim folding behaviours. 
let g:lsp_fold_enabled = 0  
" 0 to use ALE or other linting plugins. 1 will mean to let server provide
" diagnostics about the code. I use ALE because not every language has a LSP
" server, like Vimscript, but does have a linter program we can call with ALE,
" so we get better coverage of languages by just leaving linting to ALE and
" using LSP servers for others purposes.
let g:lsp_diagnostics_enabled = 0 
" Requires linking to or tweaking highlight group 'lspReference'
" highlight! link ErrorMsg lspReference
let g:lsp_document_highlight_enabled = 0

if executable('pyls')
  " pip install python-language-server
  au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  inoremap <buffer> <expr><c-f> lsp#scroll(+4)
  inoremap <buffer> <expr><c-d> lsp#scroll(-4)
  let g:lsp_format_sync_timeout = 1000
  " Example document format on save
  " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  autocmd!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" https://github.com/dense-analysis/ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'vim': ['vint'],
\ }
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)
nmap <silent> ]W <Plug>(ale_last)


" https://github.com/janko-m/vim-test
let test#strategy = 'dispatch'

" Settings
set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set clipboard=unnamed,unnamedplus
set completeopt=menuone,popup
set hidden
set history=200
set hlsearch
set incsearch
set laststatus=2
set listchars=eol:$,space:·,
set modeline
set mouse=a
set noswapfile
set nrformats-=octal
set number
set path-=/usr/include
set path+=**10
set relativenumber
set ruler
set scrolloff=5
set showcmd
set showmatch
set showmode
set smartcase
set tags=./tags;,tags;
set termguicolors
set ttimeout
set ttimeoutlen=100
set wildignore=*/.git/*,*/.hg/*,*/.svn/*,*/.node_modules/*,*.o,*.obj
set wildmenu
set wildmode=list:longest,longest:full

let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_sizestyle='h'
let g:netrw_winsize=15
let g:netrw_list_hide=netrw_gitignore#Hide() . '.*\.swp$'

" Don't use Ex mode, use Q for formatting instead.
map Q gq
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
nnoremap <Leader>t :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>

nnoremap <Leader>l :ALELint<CR>
nnoremap <Leader>n :<C-u>nohl<CR>
nnoremap <Leader>b :<C-u>Buffers<CR>
nnoremap <Leader>r :<C-u>Rg<Space>

" smaller case does buffer-local, uppercase is project wide
nnoremap <Leader>T :<C-u>Tags<Space>
nnoremap <Leader>t :<C-u>BTags<Space>
nnoremap <Leader>g :<C-u>BCommits<CR>
nnoremap <Leader>G :<C-u>Commits<CR>
nnoremap <C-p> :<C-u>FZF<CR>

nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>ga :Git add -A<CR>
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gg :Git commit --all<CR>
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>
nnoremap gh :diffget //2<CR>
nnoremap gl :diffget //3<CR>

" Terminal
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
autocmd vimrc BufWritePre /tmp/* setlocal noundofile

" Quickfix/Location List
autocmd vimrc FileType * if &ft ==# 'qf' | setlocal nonu nornu | endif
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost  l* lwindow
autocmd vimrc VimEnter * cwindow
if (v:version >=# 802)
  packadd! cfilter
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd vimrc BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
autocmd vimrc BufNewFile,BufRead *.patch set filetype=diff

" Remember the positions in files with some git-specific exceptions.
autocmd vimrc BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$")
  \           && &filetype !~# 'commit\|gitrebase'
  \           && expand("%") !~ "ADD_EDIT.patch"
  \           && expand("%") !~ "addp-hunk-edit.diff" |
  \   exe "normal g`\"" |
  \ endif

" Getting Help Easier
nnoremap <F1>f :help list-functions<CR>
nnoremap <F1>k :help keycodes<CR>
command! Api :help list-functions<CR>

command! Cd :cd %:h
command! TodoLocal :botright lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Only :.+,$bwipeout<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ *<CR>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig"
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif

colorscheme nord

