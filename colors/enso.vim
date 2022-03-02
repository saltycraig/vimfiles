" Name: enso.vim
" Version: 1.0
" Maintainer: github.com/craigmac
" License: Same as Vim.
"
" A non-colorscheme using the xterm-256 color palette to maximize chances of
" portability and consistent look.  Does not use the first 0-15 colorcodes
" because they tend to be slightly different between terminal emulators, and not
" the same as the ANSI 16 found here:
" https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
"
" The rest of the 256 colors (16-255) are typically much closer, as in the case
" of Terminal.app and iTerm on macOS.
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

" original cc color. cursorlinenr, cursorline, statuslineNC, Pmenu
hi! Conceal ctermfg=232 ctermbg=231 
hi! CursorColumn ctermbg=255 
hi! CursorLine ctermbg=255 cterm=NONE
hi! CursorLineNr ctermbg=255 ctermfg=232 cterm=NONE
hi! Directory ctermfg=244
hi! DiffAdd ctermbg=114 ctermfg=232
hi! DiffDelete ctermbg=174 ctermfg=232 cterm=NONE
hi! DiffChange ctermbg=146 cterm=NONE ctermfg=232
hi! DiffText ctermbg=176 cterm=NONE ctermfg=232
hi! EndOfBuffer ctermfg=232 ctermbg=231
hi! ErrorMsg ctermfg=231 ctermbg=196
hi! VertSplit ctermfg=232 ctermbg=232
hi! Folded ctermfg=232 ctermbg=255 cterm=NONE
hi! FoldColumn ctermfg=232 ctermbg=231
hi! SignColumn ctermfg=232 ctermbg=231
hi! IncSearch cterm=NONE ctermbg=226 ctermfg=232
hi! LineNr ctermfg=232 ctermbg=231 cterm=NONE
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
hi! link CursorLineNr CursorLine
hi! MatchParen cterm=NONE ctermbg=232 ctermfg=231
hi! ModeMsg cterm=bold 
hi! MoreMsg cterm=bold ctermfg=232 ctermbg=231
hi! NonText cterm=NONE ctermfg=232 ctermbg=231
hi! Normal ctermfg=232 ctermbg=231
hi! Pmenu ctermfg=232 ctermbg=255 cterm=NONE
hi! PmenuSel ctermfg=231 ctermbg=244 cterm=NONE
hi! PmenuSbar ctermbg=255
hi! PmenuThumb ctermbg=232
hi! Question ctermbg=231 ctermfg=232 cterm=bold
hi! Search ctermbg=226 ctermfg=232 cterm=NONE
hi! link QuickFixLine Search
hi! SpecialKey ctermbg=231 ctermfg=255
hi! SpellBad cterm=underline ctermfg=196 ctermbg=231
hi! link SpellCap SpellBad
hi! link SpellLocal SpellBad
hi! link SpellRare SpellBad
hi! StatusLine ctermfg=231 ctermbg=232 cterm=NONE
hi! StatusLineNC ctermfg=232 ctermbg=255 cterm=NONE
hi! Tabline cterm=NONE gui=NONE ctermbg=255 ctermfg=232
hi! TabLineFill cterm=NONE ctermbg=231 ctermfg=231
hi! TabLineSel ctermbg=232 ctermfg=231 cterm=NONE
hi! Title ctermbg=231 ctermfg=232 cterm=bold
hi! Visual ctermbg=244 ctermfg=231
hi! VisualNOS ctermbg=244 ctermfg=231
hi! WarningMsg ctermbg=231 ctermfg=196
hi! WildMenu ctermbg=255
hi! ColorColumn ctermbg=255

" Preferred groups
hi! Comment cterm=italic ctermfg=244 ctermbg=231 cterm=NONE
hi! Constant ctermfg=244 ctermbg=231 cterm=NONE
hi! Identifier ctermfg=232 ctermbg=231 cterm=NONE
hi! Statement ctermfg=232 ctermbg=231 cterm=bold
hi! PreProc ctermfg=232 ctermbg=231 cterm=NONE gui=NONE guibg=#ffffff
hi! Type ctermfg=232 ctermbg=231 cterm=NONE gui=NONE guibg=#ffffff
hi! Special ctermfg=232 ctermbg=231 cterm=NONE gui=NONE guibg=#ffffff
hi! Underlined cterm=underline gui=underline ctermfg=232 ctermbg=231 guibg=#ffffff
hi! Ignore ctermbg=231 ctermfg=231 guifg=#eeeeee
hi! Error ctermbg=196 ctermfg=231 guifg=#eeeeee
hi! Todo cterm=NONE gui=NONE ctermbg=255 ctermfg=232 guifg=#080808
hi! SignColumn ctermbg=231 guibg=#ffffff

hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC

" &ft = 'help'
hi! helpHyperTextEntry cterm=underline gui=underline 
hi! helpHyperTextJump cterm=underline gui=underline

