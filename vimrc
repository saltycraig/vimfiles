" vim: fdm=marker nowrap ft=vim et sts=2 ts=2 sw=2 fdl=0

" Bare-basics {{{
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
set encoding=utf-8
scriptencoding utf-8
let mapleader=' '
" }}}

" Plugin Settings {{{

" pack/git/opt/<plugin>
packadd vim-polyglot
packadd cfilter " quickfix reducer :Cfilter [v]/re/
packadd matchit " extended 'matchpairs', basically

" vim-fugitive
nnoremap <Leader>gg :G<CR>
nnoremap <Leader>gP :G push<CR>
nnoremap <Leader>gp :G pull<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>
nnoremap <Leader>gb :G blame<CR>
nnoremap <Leader>gl :Gclog<CR>
nnoremap <Leader>gc :G commit -av<CR>

" fzf.vim
nnoremap <C-p> :GFiles<CR>
" FZF from directory buffer is in, use this when not in Git repo
nnoremap <Leader>e :FZF %:h<CR>
nnoremap <Leader>b :Buffers<CR>
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
" Lightline, requires vim-gitbranch or vim-fugitive plugins.
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

" Options {{{

" Indenting/Formatting
" copy above line indent on enter
set autoindent
" indent after {, after a line with a keyword from 'cinwords',
" before a line starting with }. } as first char is given same
" indent as matching {. When 'cindent' is on or 'indentexpr' is set
" smartindent has no effect. 'indentexpr' is the most advanced version.
" 'cindent' is mainly for C stuff specifically.
set smartindent
set autoread " auto re-read files changes outside of Vim
set belloff=all | " no sounds for all possible bell events
" yank/delete/change/put ops go to clipboard registers * and +
" Normally they would go to unnamed register.
" This isn't supposed to work without :echo has('X11') and
" :echo has('xterm_clipboard') but in my tests on macos both are 0 but work!
set clipboard=unnamed,unnamedplus
" completion menu can show even when only one match, and instead of preview
" window if there's extra information, use the 'popupwin' feature
set completeopt=menuone,popup
set diffopt+=algorithm:patience | " http://vimways.org/2018/the-power-of-diff/
set hidden " hide buffers without needing to save them
set hlsearch " highlight all search matches until :nohl run
set laststatus=2 | " always show statuslines in all windows
set listchars=space:·,trail:· | " strings to show when :set list is on
set noswapfile " no annoying *.foo~ files left around
set nowrap " defaults to line wrapping on
set number relativenumber " current line number shown - rest shown relative
set signcolumn=yes | " Always show sign column, instead of popping open/closed
set showmatch " on brackets briefly jump to matching to show it
set ignorecase smartcase " ignore case in searches, UNLESS capitals used
set thesaurus=~/.vim/thesaurus/english.txt | " Use for :h i_CTRL-X_CTRL-T
set undofile undodir=~/.vim/undodir | " persistent undo on and where to save

if executable('rg')
  set grepprg=rg\ --vimgrep
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

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

" vim-liquid
" TODO: test this
let g:liquid_highlight_types=["javascript", "cpp"]

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
nnoremap <silent><F4> :call utils#ToggleLocationList()<CR>
nnoremap <silent><F5> :silent make! % <bar> silent redraw!<CR>
nnoremap <silent><F6> :15Lexplore<CR>
nnoremap <silent><F9> :set list!<CR>
nnoremap <silent><F10> :set spell!<CR>

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

" A way to send actual Esc char to terminal buffer if needed
tnoremap <C-v><Esc> <Esc>

" vim-unimpaired style
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
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
  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
  autocmd BufWritePre /tmp/* setlocal noundofile
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost  l* lwindow
  autocmd VimEnter * cwindow
augroup END

" }}}

" Colorscheme and Syntax {{{

" lifepillar/vim-solarized8
set background=light
colorscheme solarized8_high
" https://ethanschoonover.com/solarized/#the-values
" For colouring 'nbsp', 'tab', and 'trail'
" original guifg=#657b83
highlight! SpecialKey guibg=#fdf6e3 guifg=#eee8d5
" Use same bg as LineNr to blend all together
highlight! SignColumn guibg=#eee8d5
highlight! GitGutterAdd guibg=#eee8d5
highlight! GitGutterChange guibg=#eee8d5
highlight! GitGutterDelete guibg=#eee8d5

" Display highlighting groups of thing under cursor
map <F2> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Add comment highlighting support for 'JSONC' (JSON w/ comments)
autocmd vimrc FileType json syntax match Comment +\/\/.\+$+

"}}}

" Playground {{{
" TODO:
" * play with t_SI t_EI et al to modify cursor on mode changes
nnoremap <Leader>s :silent grep! '' **/*.md <Bar> silent redraw!
nnoremap <Leader>/ :noautocmd vimgrep //j **/*.md<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" }}}
