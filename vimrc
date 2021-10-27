" vim: fdm=marker nowrap ft=vim et sts=2 ts=2 sw=2 fdl=0

" Bare-basics {{{
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
set encoding=utf-8
scriptencoding utf-8
let mapleader=' '
" }}}

" Plug {{{
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

call plug#begin(expand('~/.vim/plugged'))
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
" Allows repeat '.' of vim-surround commands
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-liquid'
" Required dependency
Plug 'kana/vim-textobj-user'
" 'vie' command to select entire buffer
Plug 'kana/vim-textobj-entire'
" 'vii/ai' to select by similar indent level
Plug 'kana/vim-textobj-indent'

" Utilities
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'christoomey/vim-tmux-navigator'
" Use release branch (recommend)
" :CocInstall coc-tsserver coc-json coc-css ...
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" UI
Plug 'lifepillar/vim-solarized8'
Plug 'itchyny/lightline.vim'

call plug#end()

" }}}

" Plugin Settings {{{

" coc.nvim
" BUGFIX: https://github.com/neoclide/coc.nvim/issues/1775
let g:coc_disable_transparent_cursor = 1

" vim-fugitive
nnoremap <Leader>gg :G<CR>
nnoremap <Leader>gP :G push<CR>
nnoremap <Leader>gp :G pull<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>

" fzf.vim
nnoremap <C-p> :GFiles<CR>
" FZF from directory buffer is in, use this when not in Git repo
nnoremap <Leader>e :FZF %:h<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>/ :BLines<CR>
nnoremap <Leader>r :Rg<CR>
" Change to git project directory
nnoremap <Leader>c :FZFCd ~/git<CR>
nnoremap <Leader>C :FZFCd!<CR>
command! -bang -bar -nargs=? -complete=dir FZFCd
    \ call fzf#run(fzf#wrap(
    \ {'source': 'find '.( empty("<args>") ? ( <bang>0 ? "~" : "." ) : "<args>" ) .' -type d',
    \ 'sink': 'cd'}))
" Function used to populate Quickfix with selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
" Layout of fzf UI
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.4 } }
" Default toggle preview window key of <C-/> is not,
" widely supported on terminal emulators. Also it slows things down. Off.
let g:fzf_preview_window = []
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Lightline
" Lightline, requires vim-gitbranch and vim-fugitive plugins.
" Trim mode names down to single character to save space for long git branches
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'mode_map': {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'R',
        \ 'v' : 'V',
        \ 'V' : 'VL',
        \ "\<C-v>": 'VB',
        \ 'c' : 'C',
        \ 's' : 'S',
        \ 'S' : 'SL',
        \ "\<C-s>": 'SB',
        \ 't': 'T',
        \ },
      \ }
" }}}

" Settings {{{

set autochdir
set autoindent autoread belloff=all clipboard=unnamed,unnamedplus
set completeopt=menuone,popup nocursorline foldlevelstart=99 hidden hlsearch
set laststatus=2 listchars=space:·,trail:·
set modeline noswapfile nowrap number relativenumber
set shortmess+=c showcmd showmatch noshowmode signcolumn=yes
set ignorecase smartcase thesaurus=~/.vim/thesaurus/english.txt
set undofile undodir=~/.vim/undodir

if executable('rg')
  set grepprg=rg\ --vimgrep
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif
set incsearch
set laststatus=2
" Whitespace Display {{{
" Default for listchars is 'eol:$' which means show EOL
" character, when ':set list' is in effective, as '$'. I don't
" need this, but do care about trailing and leading whitespaces, so I
" add those. Tab is omitted her so it defaults to '^I' character on screen.
" I add a trailing listchar that matches space character.
  set listchars=space:·,trail:·
" }}}
if exists('+termguicolors')
  " https://github.com/tmux/tmux/issues/1246
  " Without 2 t_8x lines below termguicolors doesn't work.
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" enable use of folding with ft-markdown-plugin
let g:markdown_folding = 1

" enable :Man command and use it's folding
runtime ftplugin/man.vim
let g:ft_man_folding_enable=1

" }}}

" Mappings {{{

" Re-select visually selected area after indenting/dedenting.
xmap < <gv
xmap > >gv

" Move visual selection up/down lines.
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" '%%' in command-line mode maybe expands to path of current buffer.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Function keys
nnoremap <silent><F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <F4> :call utils#ToggleLocationList()<CR>
nnoremap <F5> :silent! make % <bar> copen <bar> silent redraw!<CR>
nnoremap <F6> :15Lexplore<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>

" iTerm2
nnoremap j <C-w>p<C-e><C-w>p
nnoremap k <C-w>p<C-y><C-w>p
nnoremap J <C-w>p<C-d><C-w>p
nnoremap K <C-w>p<C-u><C-w>p

" Leader keys
nnoremap <Leader>w :update<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>ft :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
nnoremap <Leader>n :<C-u>nohl<CR>
nnoremap <Leader><Leader> :b #<CR>

" Vimdiff
nnoremap gh :diffget //2<CR>
nnoremap gl :diffget //3<CR>
tnoremap <C-v><Esc> <Esc>
" Tab cycle
nnoremap <Tab> :tabNext<CR>

" Getting Help Easier
nnoremap <F1>f :help list-functions<CR>
nnoremap <F1>k :help keycodes<CR>
nnoremap <F1><F1> :help<CR>
nnoremap <F1>m :help user-manual<CR>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" vim-unimpaired style
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [L :lfirst<CR>
nnoremap ]L :llast<CR>

" }}}

" Commands {{{
command! Api :help list-functions<CR>
command! Cd :cd %:h
command! TodoLocal :botright lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ *<CR>
" }}}

" Autocmd {{{
" Put all autocmds into this group so this file is
" safe to be re-sourced, by clearing all first with autocmd!
augroup vimrc
  autocmd!
augroup END

autocmd vimrc BufNewFile,BufRead *.md setlocal complete+=k spell
autocmd vimrc BufWinEnter */doc/*.txt setlocal nonumber norelativenumber
autocmd vimrc BufWritePost $MYVIMRC nested source $MYVIMRC
autocmd vimrc BufWritePre /tmp/* setlocal noundofile
autocmd vimrc FileType liquid setlocal list

" Quickfix/Location List
autocmd vimrc FileType * if &ft ==# 'qf' | setlocal nonu nornu | endif
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost  l* lwindow
autocmd vimrc VimEnter * cwindow

" }}}

" Colorscheme and Syntax {{{

" lifepillar/vim-solarized8
set background=light
colorscheme solarized8_high
" https://ethanschoonover.com/solarized/#the-values
" For colouring 'nbsp', 'tab', and 'trail'
" original guifg=#657b83
highlight! SpecialKey guibg=#fdf6e3

" Use same bg as LineNr to blend all together
highlight! SignColumn guibg=#eee8d5
highlight! GitGutterAdd guibg=#eee8d5
highlight! GitGutterChange guibg=#eee8d5
highlight! GitGutterDelete guibg=#eee8d5

" Display hightlighting groups of thing under cursor
map <F2> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Add comment highlighting support for 'JSONC' (JSON w/ comments)
autocmd vimrc FileType json syntax match Comment +\/\/.\+$+

" To capture release-notes.md and migration-notes.md which are snippet files
autocmd vimrc BufNewFile,BufRead *.markdown,*.mkd,*.mkdn,*.md
      \ if getline(1) =~# "^We\.re excited" |
      \   let b:liquid_subtype = 'markdown' |
      \   set ft=liquid |
      \ elseif getline(1) =~# "^\\d.\\d\\d is the first generally" |
      \   let b:liquid_subtype = 'markdown' |
      \   set ft=liquid | 
      \ endif
"}}}

" Playground {{{

" }}}
" TODO:
" * 
