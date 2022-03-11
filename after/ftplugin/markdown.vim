" use 'dictionary' value for words
setlocal complete+=k
setlocal foldlevel=99
setlocal suffixesadd=.md
setlocal list
setlocal expandtab
setlocal shiftwidth=3
setlocal softtabstop=3
setlocal tabstop=3

" Better with 'set wrap' on
nnoremap <buffer> j gj
nnoremap <buffer> k gk
" TODO: could be made more robust to support other style Markdown headings
let &l:define = '\v^#+\s*.+$'

" TODO: redo this
nnoremap <buffer> gf :call utils#LiquidInclude()<CR>

" MATCHES:
" 1. {% include {{ page.version }}/snippets/target-platform-before-start.md %}
" 2. ({{ page.version }}/rn/develop/focus-management/#why-we-need-focus)
" 3. (../linux/)
"
" SEARCH PATTERN:
" /{{\s*page.version\s*}}\zs\/[^\.\)]\+\|\.\.\zs\/[^\.\)]\+
setlocal include={{\\s*page.version\\s*}}\\zs\\/[^\\.\\)]\\+\\\|\\.\\.\\zs\\/[^\\.\\)]\\+

" Taken from upstream tpope/vim-markdown, remove this when $VIMRUNTIME/ftplugin/markdown.vim
" catches up (current version is from 2019).
nnoremap <silent><buffer> [[ :<C-U>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "bsW")<CR>
nnoremap <silent><buffer> ]] :<C-U>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "sW")<CR>
xnoremap <silent><buffer> [[ :<C-U>exe "normal! gv"<Bar>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "bsW")<CR>
xnoremap <silent><buffer> ]] :<C-U>exe "normal! gv"<Bar>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "sW")<CR>

" setlocal foldmethod=expr
" setlocal foldexpr=MarkdownLiquidFolding(v:lnum)
" My own Markdown folding that only folds on '=\+\s\.+$' lines based on
" syntax group, using shipped syntax groups from
" $VIMRUNTIME/syntax/markdown.vim.
" function! MarkdownLiquidFolding(lnum) abort
	" for synID in synstack(a:lnum, 1) " => [912, 934]
	" 	let name = synIDattr(synID, "name") " => 'vimFunction'
	" 	" Give foldlevel based on the grouping name:
	" 	if name ==# 'markdownH1Delimiter' | return ">1"
	" 	elseif name ==# 'markdownH2Delimiter' | return ">2"
	" 	elseif name ==# 'markdownH3Delimiter' | return ">3"
	" 	elseif name ==# 'markdownH4Delimiter' | return ">4"
	" 	elseif name ==# 'markdownH5Delimiter' | return ">5"
	" 	elseif name ==# 'markdownH6Delimiter' | return ">6"
	" 	endif
	" endfor
	" return "="
" endfunction

" vim:set sw=2:

