" Name: enso.vim
" Version: 1.0
" Maintainer: github.com/craigmac
" License: Same as Vim.
"
" A non-colorscheme using the lower 16 colors of the xterm-256 color palette
" to maximize chances of portability and consistent look.
"
" Anti-Features:
" * Uses 'notermguicolors' so works on non true-colour capable terminals, like
" Terminal.app on macOS.
" * No broken/sort-of-working-but-not syntax highlighting. Who needs Treesitter?
"
" Mis-features:
" * Because it is 'notermguicolors' compatible, we do not define
" 'g:terminal_ansi_colors', so it will also just use 16 ANSI colors of the
" underlying terminal. 
" * Mostly 4 shades, but some colour for Diff* groups and things like Search,
" Spelling/Errors, places where I think it should stick out more.
" * Simplified as much as possible - no functions, dynamically generated
" content/values, etc. 
" * No support or toggleable support for plugins, do this in your .vimrc file.
" * Only support the preferred highlighting groups
"
" Inspired by non-colorschemes like off.vim.
" TODO: pictures of iTerm2 with white colorscheme next to Terminal.app white
" colorscheme, etc. like Apprentice
" TODO: Philosophy section:
"   * why no colours? Q & A: Quick, when you open a Go file in Vim, what colour
"   are the keywords? The comments? How about the constants?
"   * Benefits of syntax highlighting:
"     * Colours look nice
"     * Colours can tell us when something isn't syntactically correct (biggest)
"   We can still get this second benefit with minimal highlighting by using just
"   enough variance. Examples of how this works in pictures.
"   Design:
"   * For UI elements: ANSI 8/#808080 background with 015/#ffffff foreground when selected/active,
"   otherwise it is 007/#c0c0c0 background with 000/#000000 black text.
"   Examples:

hi clear

if exists('syntax on')
  syntax reset
endif

let g:colors_name='enso'

hi! Conceal ctermfg=0 ctermbg=15 guifg=#000000 guibg=#ffffff 
hi! CursorColumn ctermbg=7 guibg=#c0c0c0
hi! CursorLine ctermbg=7 guibg=#c0c0c0 cterm=NONE gui=NONE
hi! CursorLineNr ctermbg=7 ctermfg=0 guifg=#000000 guibg=#c0c0c0 cterm=NONE gui=NONE
hi! Directory ctermfg=8 guifg=#808080
hi! DiffAdd ctermbg=10 ctermfg=0 guibg=#00ff00 guifg=#000000
hi! DiffDelete ctermbg=12 ctermfg=0 guibg=#0000ff guifg=#000000
hi! DiffChange ctermbg=11 cterm=NONE gui=NONE ctermfg=0 guifg=#000000 guibg=#ffff00
hi! DiffText ctermbg=1 cterm=NONE gui=NONE ctermfg=0 guifg=#000000 guibg=#800000
hi! EndOfBuffer ctermfg=0 ctermbg=15 guifg=#000000 guibg=#ffffff
hi! ErrorMsg ctermfg=15 ctermbg=1 guifg=#ffffff guibg=#800000
hi! VertSplit ctermfg=0 ctermbg=0 guifg=#000000 guibg=#000000
hi! Folded ctermfg=0 ctermbg=7 cterm=NONE gui=NONE guifg=#000000 guibg=#c0c0c0
hi! FoldColumn ctermfg=0 ctermbg=15 guibg=#000000 guibg=#ffffff
hi! SignColumn ctermfg=0 ctermbg=15 guifg=#000000 guibg=#ffffff
hi! IncSearch cterm=reverse gui=reverse
hi! LineNr ctermfg=0 ctermbg=15 cterm=NONE gui=NONE guifg=#000000 guibg=#ffffff
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
hi! link CursorLineNr CursorLine
hi! MatchParen cterm=NONE gui=NONE ctermbg=0 ctermfg=15 guibg=#000000 guifg=#ffffff
hi! ModeMsg cterm=bold gui=bold
hi! MoreMsg cterm=bold gui=bold ctermfg=0 ctermbg=15 guibg=#ffffff guifg=#000000
hi! NonText cterm=NONE gui=NONE ctermfg=0 ctermbg=15 guibg=#ffffff guifg=#000000
hi! Normal ctermfg=0 ctermbg=15 guifg=#000000 guibg=#ffffff
hi! Pmenu ctermfg=0 ctermbg=7 cterm=NONE gui=NONE guifg=#000000 guibg=#c0c0c0
hi! PmenuSel ctermfg=15 ctermbg=8 cterm=NONE gui=NONE guifg=#ffffff guibg=#808080
hi! PmenuSbar ctermbg=7 guibg=#c0c0c0
hi! PmenuThumb ctermbg=0 guibg=#000000
hi! Question ctermbg=15 ctermfg=0 cterm=bold gui=bold guifg=#000000 guibg=#ffffff
hi! Search ctermbg=11 guibg=#ffff00
hi! link QuickFixLine Search
" Used for listchars but also for meta/map keys listed with :map. Neovim does
" this better by breaking them into two separate groups, with a ListChar group.
hi! SpecialKey ctermbg=15 ctermfg=7
hi! SpellBad cterm=underline gui=undercurl ctermfg=1 ctermbg=15 guifg=#800000 guibg=#ffffff
hi! link SpellCap SpellBad
hi! link SpellLocal SpellBad
hi! link SpellRare SpellBad
hi! StatusLine ctermfg=15 ctermbg=8 cterm=NONE gui=NONE guifg=#ffffff guibg=#808080
hi! StatusLineNC ctermfg=0 ctermbg=7 cterm=NONE gui=NONE guifg=#000000 guibg=#c0c0c0
hi! Tabline cterm=NONE gui=NONE ctermbg=7 ctermfg=0 guifg=#000000 guibg=#c0c0c0
hi! TabLineFill ctermbg=15 ctermfg=15 guibg=#ffffff guifg=#000000
hi! TabLineSel ctermbg=8 cterm=NONE gui=NONE ctermfg=15 guifg=#ffffff guibg=#808080
hi! Title ctermbg=15 ctermfg=0 cterm=bold gui=bold guifg=#000000 guibg=#ffffff
hi! Visual ctermbg=8 ctermfg=15 guifg=#ffffff guibg=#c0c0c0
hi! VisualNOS ctermbg=8 ctermfg=15 guifg=#ffffff guibg=#c0c0c0
hi! WarningMsg ctermbg=15 ctermfg=1 guibg=#ffffff guifg=#800000
hi! WildMenu ctermbg=7 guibg=#c0c0c0
hi! ColorColumn ctermbg=7 guibg=#c0c0c0

" Preferred groups
hi! Comment ctermfg=8 ctermbg=15 cterm=italic gui=italic
hi! Constant ctermfg=8 ctermbg=15 cterm=NONE gui=NONE guifg=#000000 guibg=#ffffff
hi! Identifier ctermfg=0 ctermbg=15 cterm=NONE gui=NONE guifg=#000000 guibg=#ffffff
hi! Statement ctermfg=0 ctermbg=15 cterm=bold gui=bold guifg=#000000 guibg=#ffffff
hi! PreProc ctermfg=0 ctermbg=15 cterm=NONE gui=NONE guifg=#000000 guibg=#ffffff
hi! Type ctermfg=0 ctermbg=15 cterm=NONE gui=NONE guifg=#000000 guibg=#ffffff
hi! Special ctermfg=0 ctermbg=15 cterm=NONE gui=NONE guifg=#000000 guibg=#ffffff
hi! Underlined cterm=underline gui=underline ctermfg=0 ctermbg=15 guifg=#000000 guibg=#ffffff
hi! Ignore ctermbg=15 ctermfg=15 guibg=#ffffff guifg=#ffffff
hi! Error ctermbg=9 ctermfg=15 guibg=#ff0000 guifg=#ffffff
hi! Todo cterm=NONE gui=NONE ctermbg=8 ctermfg=15 guibg=#808080 guifg=#ffffff
hi! SignColumn ctermbg=15 guibg=#000000

hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC

" GitGutter
hi! GitGutterAdd    guifg=#008000 ctermfg=2 guibg=#ffffff ctermbg=2
hi! GitGutterChange guifg=#808000 ctermfg=3 guibg=#ffffff ctermbg=3
hi! GitGutterDelete guifg=#800000 ctermfg=1 guibg=#ffffff ctermbg=1

" &ft = 'help'
hi! helpHyperTextEntry cterm=underline gui=underline 

