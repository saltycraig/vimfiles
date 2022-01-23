setlocal list
setlocal foldlevel=99
setlocal expandtab
setlocal suffixesadd=.md

" TODO: could be made more robust to support other style Markdown headings
let &l:define = '\v^#+\s*.+$'

" in vimrc my CCR() fn handles the CR here so need nmap to trigger it
nmap <buffer> gO :dlist /<CR>

nnoremap <buffer> gf :call utils#LiquidInclude()<CR>

" MATCHES:
" 1. {% include {{ page.version }}/snippets/target-platform-before-start.md %}
" 2. ({{ page.version }}/rn/develop/focus-management/#why-we-need-focus)
" 3. (../linux/)
"
" SEARCH PATTERN:
" /{{\s*page.version\s*}}\zs\/[^\.\)]\+\|\.\.\zs\/[^\.\)]\+
setlocal include={{\\s*page.version\\s*}}\\zs\\/[^\\.\\)]\\+\\\|\\.\\.\\zs\\/[^\\.\\)]\\+

compiler liquid
