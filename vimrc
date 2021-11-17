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
packadd cfilter " quickfix reducer :Cfilter [v]/re/
packadd matchit " extended 'matchpairs', basically
packadd vim-fugitive

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

" :bwipeout! selected buffers using :ls! to show all hidden buffers
nnoremap <Leader>! :FZFWipeSelectedBuffers<CR>
command! FZFWipeSelectedBuffers
  \ call fzf#run(fzf#wrap({'source': mapnew(getbufinfo(), {_, val -> val.name}),
  \ 'sink': 'bwipeout!',
  \ 'options': '--multi'}))

" Change to git project directory
nnoremap <Leader>c :FZFCd ~/git<CR>
nnoremap <Leader>C :FZFCd!<CR>
nnoremap <Leader><C-]> :Tags<CR>
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
  \ 'border':  ['fg', 'Normal'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
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
set history=10000 | " Max possible value, use <C-f> in commandline to browse
set hlsearch " highlight all search matches until :nohl run
set laststatus=2 | " always show statuslines in all windows
set listchars=space:·,trail:· | " strings to show when :set list is on
set noswapfile " no annoying *.foo~ files left around
set nowrap " defaults to line wrapping on
set number relativenumber " current line number shown - rest shown relative
set path=.,** | " Very slow on bigger projects, ok on small
set showmatch " on brackets briefly jump to matching to show it
set statusline=%F%=%y
set showtabline=2 | " Always show tabline, I set it to show &pwd and use :lcd in each
" Use for non-gui tabline, for gui use :h 'guitablabel'
set tabline=%!MyTabLine()
set ignorecase smartcase " ignore case in searches, UNLESS capitals used
set splitbelow " new horizontal split window always goes below current
set splitright " same but with new vertical split window
set thesaurus=~/.vim/thesaurus/english.txt | " Use for :h i_CTRL-X_CTRL-T
set undofile undodir=~/.vim/undodir | " persistent undo on and where to save
set wildoptions=tagfile | " :tag <C-d> will show tag kind and file

if executable('rg')
  set grepprg=rg\ --vimgrep
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" enable use of folding with ft-markdown-plugin
let g:markdown_folding = 1

" enable :Man command and use it's folding
runtime! ftplugin/man.vim
let g:ft_man_folding_enable=1

" Terminal.app
if $TERM_PROGRAM ==# 'Apple_Terminal'
  set title
  autocmd! BufEnter * let &titlestring=getcwd()
endif
" }}}

" Mappings {{{

" Match C,D, behaviour, yank to line end from cursor position
nnoremap Y y$
" Clear highlighting, call :diffupdate
nnoremap <C-l> <Cmd>nohlsearch<Bar>diffupdate<CR><C-l>

nnoremap <Leader>tv :vertical terminal<CR> 
nnoremap <Leader>ts :terminal<CR> 

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

" iTerm2/Terminal.app
nnoremap j <C-w>p<C-e><C-w>p
nnoremap k <C-w>p<C-y><C-w>p
nnoremap J <C-w>p<C-d><C-w>p
nnoremap K <C-w>p<C-u><C-w>p

" Leader keys
nnoremap <Leader>w :update<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>ft :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
nnoremap <Leader><Leader> :buffer #<CR>
" leave this a bdelete because wipeout erases jump points etc for navigation
nnoremap <Leader>k :bdelete!<CR>

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
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprev<CR>
nnoremap ]T :tablast<CR>
nnoremap [t :tabfirst<CR>
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
" https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg

" See all active highlight groups with:
" :so $VIMRUNTIME/syntax/hitest.vim
set background=light
colorscheme enso

function! SynGroup() " Outputs both the name of the syntax group, AND the translated syntax
  " group of the character the cursor is on.
  " line('.') and col('.') return the current position
  " synID(...) returns a numeric syntax ID
  " synIDtrans(l:s) translates the numeric syntax id l:s by following highlight links
  " synIDattr(l:s, 'name') returns the name corresponding to the numeric syntax ID
  " example output:
  " vimMapModKey -> Special
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction
nnoremap <F2> :call SynGroup()<CR>
"}}}

" Playground {{{
" TODO:
" * play with t_SI t_EI et al to modify cursor on mode changes
nnoremap <Leader>s :silent grep! '' **/*.md <Bar> silent redraw!
nnoremap <Leader>/ :noautocmd vimgrep //j **/*.md<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

nnoremap <Leader>gl :botright vertical terminal ++close lazygit<CR> 

function! MyTabLine()
  " Loop over pages and define labels for them, then get label for each tab
  " page use MyTabLabel(). See :h 'statusline' for formatting, e.g., T, %, #, etc.
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      " use hl-TabLineSel for current tabpage
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number, for mouse clicks
    let s .= '%' . (i + 1) . 'T'

    " call MyTabLabel() to make the label
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " After last tab fill with hl-TabLineFill and reset tab page nr with %T
  let s .= '%#TabLineFill#%T'

  " Right-align (%=) hl-TabLine (%#TabLine#) style and use %999X for a close
  " current tab mark, with 'X' as the character
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif

  return s
endfunction

function! MyTabLabel(n)
  " Give tabpage number n create a string to display on tabline
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  " return getcwd(winnr)
  return getcwd(winnr, a:n)
  " return bufname(buflist[winnr - 1])
endfunction

" Never mistype q: again option
" nnoremap q: :q

" }}}

