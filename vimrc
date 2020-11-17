" Author: C.D. MacEachern <craigm@fastmail.com>
" Description: vim 8.0+ config (requires +packages)

" -------------------------
" Needed First
" -------------------------
source $VIMRUNTIME/defaults.vim

" Add autocmds to this group to avoid resourcing problems.
augroup vimrc
  autocmd!
augroup END

let mapleader = ' '
let maplocalleader = "\\"

if v:version >= 802
  set completeopt=menuone,noinsert,noselect,popup
else
  set completeopt=menuone,noinsert,noselect,preview
endif

" -------------------------
" Packages and Settings
" -------------------------
packadd! vim-colors-solarized
packadd! targets.vim
packadd! vim-commentary
packadd! vim-dispatch
packadd! vim-editorconfig
packadd! vim-indent-object
packadd! vim-repeat
packadd! vim-surround
packadd! vim-unimpaired

packadd! vim-fugitive
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>ga :Git add -A<CR>
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gg :Git commit --all<CR>
nnoremap <Leader>gp :Git push<CR>

packadd! fzf
let g:fzf_layout = { 'down': '40%' }

packadd! fzf.vim
nnoremap <C-p> :FZF<CR>
if has('osx')
  nnoremap π :Buffers<CR>
  " option-j (alt key) = ∆
  " option-k = ˚
else
  " this is how terminal vim sees alt+p keypress in mintty (:help i_C-v)
  noremap <Esc>p :Buffers<CR>
endif

packadd! vim-vsnip
" Expand
imap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
smap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
" Expand or jump
imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
" Jump forward or backward
imap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap s <Plug>(vsnip-select-text)
xmap s <Plug>(vsnip-select-text)
nmap S <Plug>(vsnip-cut-text)
xmap S <Plug>(vsnip-cut-text)
" If you want to use snippet for multiple filetypes, use 'g:vsnip_filetypes'.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript', 'html', 'css']
let g:vsnip_filetypes.typescriptreact = ['typescript']
let g:vsnip_snippet_dir = expand('~/.vim/snippets')
let g:vsnip_snippet_dirs = [
  \ expand('~/.vim/pack/git-managed/opt/vim-vsnip-snippets/snippets'),
  \ expand('~/.vsnip')
  \ ]

packadd! vim-vsnip-integ
packadd! vim-vsnip-snippets

" 'python3 install.py --all' flag installs servers for:
" C/C++, C#, Go, Java, Python, Rust, JavaScript/TypeScript
packadd! YouCompleteMe
" https://github.com/ycm-core/YouCompleteMe#plugging-an-arbitrary-lsp-server
let g:ycm_language_server =
  \ [
  \   {
  \     'name': 'vimls',
  \     'cmdline': ['/usr/local/bin/vim-language-server', '--stdio'],
  \     'filetypes': ['vim']
  \   },
  \ ]

" -------------------------
" Non-Plugin Mappings
" -------------------------
" command line mappingscan't use Tab so 'wcm' needs to used in place of it
" Essentially, whenever I see <C-z> read it as hitting <Tab> key
set wildcharm=<C-z>

" Scroll other window shortcut
if has('osx')
  " On Alacritty set 'alt_send_esc = false' in the alacritty.yml config.
  if !empty('ALACRITTY_LOG')
    nnoremap ∆ <C-w>p<C-e><C-w>p
    nnoremap ˚ <C-w>p<C-y><C-w>p
  endif
else
  " mintty, maybe others
  nnoremap <Esc>j <C-w>p<C-e><C-w>p
  nnoremap <Esc>k <C-w>p<C-y><C-w>p
endif

" vimrc
nnoremap <Leader>ev :edit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" use %% in command-line to autoexpand to current buf directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" common mistake, we almost never want q:
map q: :q

" :edit mappings
" nnoremap <Leader>e :<C-u>e<space><C-z><S-Tab>
" Remaps C-p to do the above as a convenience
" nmap <C-p> <Leader>e
" " Do :edit from current file folder
" nnoremap <Leader>E
"   \ :<C-u>e <C-r>=fnameescape(expand('%:p:h')).'/'<CR><C-z><S-Tab>

" :find mappings
" * Like :edit but uses value of 'path',
" * keep value of 'pwd' at project root to get find-in-project results
nnoremap <Leader>f :<C-u>find<space><C-d>
" Like above, but use current file directory as starting point
nnoremap <Leader>F :<C-u>find <C-r>=fnameescape(expand('%:p:h')).'/'<CR><C-d>
nnoremap <Leader>s :<C-u>sfind<space><C-d>
nnoremap <Leader>S
  \ :<C-u>sfind <C-r>=fnameescape(expand('%:p:h')).'/'<CR><C-d>
nnoremap <Leader>v :<C-u>vert sfind<space><C-d>
nnoremap <Leader>V
  \ :<C-u>vert sfind <C-r>=fnameescape(expand('%:p:h')).'/'<CR><C-d>

" :tabedit/tabfind mappings
nnoremap <Leader>t :<C-u>tabedit <C-z><S-Tab>
nnoremap <Leader>T :<C-u>tabfind <C-r>=fnameescape(expand('%:p:h')).'/'<CR><C-d>

" :buffer mappings
" * Prefer <C-d> to wildmenu here because it allows fuzzy matching typing
nnoremap <Leader>b :<C-u>buffer <C-d>
nnoremap <Leader>B :<C-u>sbuffer <C-d>

" Function keys
nnoremap <silent><F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <silent><F4> :call utils#ToggleLocationList()<CR>
nnoremap <F5> :silent make! % <bar> silent redraw!<CR>
nnoremap <F6> :15Lexplore<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>

" Buffers/Windows
nnoremap <Leader>w :<C-u>update<CR>
nnoremap <Leader>l :<C-u>b #<CR>

" Edit current buffer filetype in after/ftplugin/
nnoremap <Leader>ft :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>

" Symbol Navigation (see vimways.org/2018 romainl article)
nnoremap <Leader>ij :<C-u>ijump <C-r><C-w>
nnoremap <Leader>is :<C-u>isearch
nnoremap <Leader>il :<C-u>ilist <C-r><C-w>

" 'define' commands are more precise as they search for the
" text matching 'define' (e.g. 'def') plus the argument,
" whereas 'include' commands simple search for the argument
nnoremap <Leader>dj :<C-u>djump <C-r><C-w>
nnoremap <Leader>ds :<C-u>dsearch
nnoremap <Leader>dl :<C-u>dlist

" Tag jumping
nnoremap <Leader>tj :<C-u>tjump<space>
nnoremap <Leader>tp <C-w>}
"
" jump to tag or present options if ambiguous
nnoremap <C-]> g<C-]>
" opens in preview window our choice
nnoremap <C-w><C-]> g<C-w><C-]>

" Terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

" Command-line
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" -------------------------
" Abbreviations
" -------------------------
" Autoclosing brackets/braces
inoreabbrev (<CR> (<CR>)<Esc>O
inoreabbrev ({<CR> ({<CR>});<Esc>O
inoreabbrev {<CR> {<CR>}<Esc>O
inoreabbrev {; {<CR>};<Esc>O
inoreabbrev {, {<CR>},<Esc>O
inoreabbrev [<CR> [<CR>]<Esc>O
inoreabbrev [; [<CR>];<Esc>O
inoreabbrev [, [<CR>],<Esc>O

" -------------------------
" Options
" -------------------------
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide().'.*\.swp$'
let g:netrw_sizestyle='h'
set autoread " If file changed on disk, reread it
set autoindent
set cursorline
set hidden
set ignorecase smartcase
set noswapfile nobackup noundofile nowritebackup
set noshowmode
set number relativenumber
set laststatus=2
" ',,' means search in current directory
" **2 means limit downward search to 2 folders deep
" '.' means relative to directory of current file, which I don't usually
" use because I keep the value of 'cd' at project root
set path=,,
set path+=**3
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif
" split and vsplit commands always open below and to right, respectively
set splitbelow splitright
" adding '!26' to save 26 global marks, i.e., A - Z, rest is default
set viminfo="'100,!26,<50,s10,h"
" Used with :edit, :find, and a few others
set wildignore+=*.jpg,*.jpeg,*.bmp,*.ico,*.so,*.dll,*.o,*.obj,*.zip
set wildignore+=*.swp,*~,._*,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.zip
set wildignore+=*/.git/*,*/node_modules/*,*/.hg/*,*/.svn/*,*/.venv/*

" --------------------------------------------------
" Whitespace Explanations. Because I forget.
" These are the global defaults just here reference.
" --------------------------------------------------
" Number of spaces <Tab> counts for. Whether 1 tab byte 0x09 will be replaced
" with space bytes 0x20 depends on if 'expandtab/noexpandtab'.
set tabstop=8
" Governs how much to indent (e.g., >> command)
" Whether it uses spaces or tab character is up to a few settings:
"   * if 'noexpandtab': tries to use tab bytes (\x09) alone. It will use
"   spaces as needed if the result of tabstop / shiftwidth is not 0.
"   * if 'expandtab': only use space bytes.
" Unless you want mixed tab and space bytes (THE HORROR.) if you set
" tabstop and shiftwidth to different values that are non equally divisible,
" use 'expandtab'.
set shiftwidth=8
" Rounds indenting actions to a multiple of 'shiftwidth' if this is on.
set noshiftround
" Number of spaces that tab byte \x09 counts for when doing edits like
" when pressing <Tab> or <BS>. It uses a mix of space \x020 and tab
" \x09 bytes. Useful to keep tabstop at 8 while being able to add tabs
" and delete like it is set to softtabstop (insert/remove that many
" whitespaces, made up of space and tab characters).
"  * if 'noexpandtab': number of \x020 (space) bytes are minimized by
"  inserting as many \x09 (tab) bytes as possible.
set softtabstop=0
" Don't use space bytes \x020 to make up tab \x09 bytes, use real tabs.
" Technically small filesizes with tab characters, but with minification
" on most web/code now being popular, this doesn't matter as much.
set noexpandtab
" Do not copy indent from current line when starting new line: <CR>,o,O
set noautoindent

if v:version >= 800
  packadd! matchit
  set belloff=all | " Turn off bell ring for all events
  " set termguicolors " Use true colours if terminal supports it
  set breakindent | " Every wrapped line continues visual indent
  set shortmess+=c
  if has('patch-8.1.0360')
    " better vimdiff experience with patience algorithm
    set diffopt+=internal,algorithm:patience
  endif
  if v:version >= 802
    packadd! cfilter
  endif
endif

if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --vimgrep\ --hidden\ --ignore-dir=.git/\ $*
  set grepformat=%f:%l:%c:%m
endif

" -------------------------
" Autocommands
" -------------------------
autocmd vimrc BufWritePre /tmp/* setlocal noundofile
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost  l* lwindow

" -------------------------
" Commands
" -------------------------
" TODO: move these to user autoload folder
command! Todo :silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ **<CR>
command! LocalTodo :lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
" change to current buffer directory
command! Cd :cd %:h


" -------------------------
" Autocommands
" -------------------------
" Local settings
autocmd FileType python setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=0
autocmd FileType python setlocal define=^\\s*\\(def\\\|class\\)
autocmd FileType python setlocal makeprg=pylint\ --output-format=parseable\ --score=n
autocmd FileType javascript,javascriptreact setlocal et ts=2 sts=2 sw=0
autocmd FileType javascript,javascriptreact setlocal makeprg=npx\ eslint\ --format\ unix

" Lint on write, also have F5 to run same on demand
autocmd BufWritePost *.py,*.js,*.jsx silent make! <afile> | silent redraw!

" -------------------------
" Needed Last
" -------------------------
" Read in saved viminfo to registers/marks/oldfiles/etc. Stored in ~/.viminfo
rviminfo!
" Ignore errors and read in all doc/ files in &rtp to update help files.
silent! helptags ALL
set background=light
colorscheme solarized
