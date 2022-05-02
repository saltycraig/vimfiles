" vim: set foldmethod=indent foldlevel=1 textwidth=100 filetype=vim :
" Author: C.D. MacEachern <craigm@fastmail.com> vim 7.4+ config file.
" Last Modified: 2020-09-17
" local.vim -- utility functions that I use

function! utils#UpdateLastModified() abort
	" Looks for 'modified:' in first 10 lines and updates time. Called on
	" Bufwrite for *.vim in after/ftplugin. Saves pos and restores it too.
	if &filetype ==# 'vim'
		let l:winview = winsaveview()
		if exists('*strftime')
			silent! execute '1,10s/Modified:.*/Modified: ' . strftime('%Y-%m-%d') . '/'
			call winrestview(l:winview)
		else
			echoerr 'Could not use strftime system call to modify date'
			return
		endif
	endif
endfunction

function! utils#JekyllOpenDevx() abort
	" Requires 'devx' as &pwd for '%:.' to work correctly with forming the final URL to open
	if !getcwd() =~ 'devx' 
		echoerr 'Command only works when &pwd is "devx"'
		return
	endif
	let relpath = expand('%:.')
		\ ->substitute('_ver_', '', '')
		\ ->substitute('^docs', '', '')
		\ ->substitute('\.md$', '/', '')
	" cases:
	" docs/_ver_6.14/path/to/file
	" docs/release-details/file-with-version-6.8.md
	let newversion = relpath->matchstr('\d\.\d\d\?')
	" When relpath = version/path/to/topic we need to drop leading \d\.\d\d\? dir, otherwise we end
	" up with 6.15/6.15/path/to/file. We only check up to first / to limit to first folder.
	let newpath = newversion .. relpath->substitute('\d\.\d\d\?/', '', '')
	" any version 6.14 and over requires localhost only
	let host = str2float(newversion) >= 6.14 ? 'http://localhost:4000' : 'https://developer-staging.youi.tv/'
	let finalurl = host .. newpath
	execute "silent! !open " . finalurl
	redraw!
endfunction

function! utils#MarkdownInclude() abort
	" finds:
	" '/snippets/target-platform-before-start'
	" '/cpp/platform-roku/roku-cloud-solution/'
	" '/rn/develop/focus-management/#why-we-need-focus'
	" '(../windows/)
	" echom 'DEBUG: Using include value of: ' .. &include
	let l:fname = matchstr(getline('.')->trim(), &include)
	if empty(l:fname) 
		return 
	endif 
	" echom 'DEBUG: l:fname after trim() and include match = ' .. l:fname
	" split any #foo so we can jump to that spot in the file if it exists
	let l:fname_ahref = split(l:fname, '#')
	let l:fname = l:fname_ahref[0]
	try
		let l:ahref = l:fname_ahref[1]
	catch /E684/
		let l:ahref = 0
	endtry
	" echom 'DEBUG: l:fname_ahref if found in include match = ' .. l:ahref
	" trim any trailing / so we can use suffixesadd to add .md
	let l:fname = substitute(l:fname, '/$', '', '')
	" trim leading / as well
	let l:fname = substitute(l:fname, '^/', '', '')
	" echom 'DEBUG: l:fname after leading and trailing "/" removed = ' .. l:fname
	" TODO: 
	" now get what version folder we want to start search in
	" from the buffer name we are in, hardcoded right now for 6.15 only
	let l:search_path = '/Users/cmaceach/git/devx/docs/_ver_' .. '6.15' .. '/**'
	" echom 'DEBUG: using l:search_path of : ' .. l:search_path
	execute 'edit ' .. findfile(l:fname .. &suffixesadd, l:search_path)
	" try jumping to href tag if one was found
	if !empty(l:ahref)
		" remove dashes in the line, which are used in the url,
		let l:ahref = substitute(l:ahref, '-\+', ' ', 'g')
		call search('^#\+\s*' .. l:ahref, 'w')
	endif
endfunction

function! JekyllOpen() abort
	if !getcwd() =~# 'youi-platform-docs'
		echoerr 'Command currently only works when &pwd is ~/git/hbo/youi-platform-docs'
		return
	endif
	let topicpath = expand('%:.') " docs/_ver_6.16/rn/guides/crash-reporting.md
		\ ->substitute('_ver_', '', '') " docs/6.16/rn/guides/crash-reporting.md
		\ ->substitute('^docs', '', '') " /6.16/rn/guides/crash-reporting.md
		\ ->substitute('\.md$', '/', '') " /6.16/rn/guides/crash-reporting/
	" echom 'DEBUG: topicpath set to: ' .. topicpath
	let host = 'https://docs.hbo.com'
	let finalurl = host .. topicpath
	execute "silent! !open " .. finalurl
	redraw!
endfunction

