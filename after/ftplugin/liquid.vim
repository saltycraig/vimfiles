setlocal list
compiler liquid

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

setlocal foldmethod=expr
setlocal foldexpr=MarkdownLiquidFolding(v:lnum)

" My own Markdown folding that only folds on '=\+\s\.+$' lines based on
" syntax group, using shipped syntax groups from $VIMRUNTIME/syntax/markdown.vim.
" This avoid collapsing YAML headers in liquid files, because markdown folding
" considers the end '---' line of YAML header as a valid Markdown header.
function! MarkdownLiquidFolding(lnum) abort
	for synID in synstack(a:lnum, 1) " => [912, 934]
		let name = synIDattr(synID, "name") " => 'vimFunction'
		" Give foldlevel based on the grouping name:
		if name ==# 'markdownH1Delimiter' | return ">1"
		elseif name ==# 'markdownH2Delimiter' | return ">2"
		elseif name ==# 'markdownH3Delimiter' | return ">3"
		elseif name ==# 'markdownH4Delimiter' | return ">4"
		elseif name ==# 'markdownH5Delimiter' | return ">5"
		elseif name ==# 'markdownH6Delimiter' | return ">6"
		endif
	endfor
	return "="
endfunction

