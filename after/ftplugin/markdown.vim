" use 'dictionary' value for words
setlocal complete+=k
setlocal foldlevel=99
setlocal suffixesadd=.md
setlocal list
setlocal expandtab
setlocal shiftwidth=3
setlocal softtabstop=3
setlocal tabstop=3
" setlocal foldmethod=expr
" setlocal foldexpr=MarkdownYamlFold()

" TODO: could be made more robust to support other style Markdown headings
let &l:define = '\v^#+\s*.+$'

nnoremap <buffer> gf :call utils#LiquidInclude()<CR>

" MATCHES:
" 1. {% include {{ page.version }}/snippets/target-platform-before-start.md %}
" 2. ({{ page.version }}/rn/develop/focus-management/#why-we-need-focus)
" 3. (../linux/)
"
" SEARCH PATTERN:
" /{{\s*page.version\s*}}\zs\/[^\.\)]\+\|\.\.\zs\/[^\.\)]\+
setlocal include={{\\s*page.version\\s*}}\\zs\\/[^\\.\\)]\\+\\\|\\.\\.\\zs\\/[^\\.\\)]\\+

" Based on:
" https://habamax.github.io/2019/03/07/vim-markdown-frontmatter.html
" Don't recognize '---' in frontmatter as being a markdown fold.
" function! MarkdownYamlFold() abort
"   let line = getline(v:lnum)

"   " Regular headers
"   let depth = match(line, '\(^#\+\)\@<=\( .*$\)\@=')
"   if depth > 0
"     return ">" . depth
"   endif

"   " Setext style headings
"   let prevline = getline(v:lnum - 1)
"   let nextline = getline(v:lnum + 1)
"   if (line =~ '^.\+$') && (nextline =~ '^=\+$') && (prevline =~ '^\s*$')
"     return ">1"
"   endif

"   if (line =~ '^.\+$') && (nextline =~ '^-\+$') && (prevline =~ '^\s*$')
"     return ">2"
"   endif

"   " frontmatter
"   if (v:lnum == 1) && (line =~ '^----*$')
" 	  return ">1"
"   endif

"   return "="
" endfunction

" Taken from upstream tpope/vim-markdown, remove this when runtime markdown.vim
" catches up (current version is from 2019).
nnoremap <silent><buffer> [[ :<C-U>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "bsW")<CR>
nnoremap <silent><buffer> ]] :<C-U>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "sW")<CR>
xnoremap <silent><buffer> [[ :<C-U>exe "normal! gv"<Bar>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "bsW")<CR>
xnoremap <silent><buffer> ]] :<C-U>exe "normal! gv"<Bar>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "sW")<CR>
" vim:set sw=2:

