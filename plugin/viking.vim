" viking.vim - it's dangerous to go it alone...take this!

" Functions {{{1

if !exists(":DiffOrig")
	" see diff b/t current buffer and file loaded from, i.e. changes
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
	\ | wincmd p | diffthis
endif

function! s:EnsureDirExists () abort
	" Ask to create dir on e.g. :e /path/non-existant-folder/myfile.txt
	let required_dir = expand("%:h")
	if !isdirectory(required_dir)
		if confirm("Directory '" . required_dir . "' doesn't exist.", "&Abort?\n&Create it?") == 2
				call mkdir( required_dir, 'p' )
		endif
	endif
endfunction

function! Redir(cmd, rng, start, end) abort
	" usage: :Redir !ls -la | :Redir highlight | :.Redir !node 
	" pass args: :%Redir !bash -s foo bar
	for win in range(1, winnr('$'))
		" close any scratch win already open
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~# '^!'
		" shell command, if there's an % expand it to full path, and grab from
		" after the ! (\zs means start matching here) to the end
		let cmd = a:cmd =~# ' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			" No range e.g., :Redir !ls
			let output = systemlist(cmd)
		else
			" Ranged, e.g., :%Redir !python3 %
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		" not external command e.g., :Redir version
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	" To detect 'scratch' var if/when Redir called again
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nonumber norelativenumber
	nnoremap <buffer> q :bwipeout!<CR>
	call setline(1, output)
endfunction

function! StripTrailingWhitespaces() abort
	" Don't touch binary files or diff files
	if !&binary && &filetype !=# 'diff'
		let _s=@
		%s/\s\+$//e
		" restore last search to last search register, ignore above one
		let @/=_s
	endif
endfunction

function! CCR() abort
	" Background here: https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
	" with help from https://github.com/teoljungberg
	let cmdline = getcmdline()
	let filter_stub = '\v\C^((filt|filte|filter) .+ )*'
	command! -bar Z silent set more|delcommand Z
	if getcmdtype() !~ ':'
		return "\<CR>"
	endif
	if cmdline =~ filter_stub . '(ls|files|buffers)$'
		" like :ls but prompts for a buffer command
		return "\<CR>:b"
	elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number|l|li|lis|list)$'
		" like :g//# but prompts for a command
		return "\<CR>:"
	elseif cmdline =~ filter_stub . '(\%)*(#|nu|num|numb|numbe|number|l|li|lis|list)$'
		" like :g//# but prompts for a command
		return "\<CR>:"
	elseif cmdline =~ '\v\C^(dli|il)'
		" like :dlist or :ilist but prompts for a count for :djump or :ijump
		return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
	elseif cmdline =~ filter_stub . '(cli)'
		" like :clist or :llist but prompts for an error/location number
		return "\<CR>:sil cc\<Space>"
	elseif cmdline =~ filter_stub . '(lli)'
		" like :clist or :llist but prompts for an error/location number
		return "\<CR>:sil ll\<Space>"
	elseif cmdline =~ filter_stub . 'old'
		" like :oldfiles but prompts for an old file to edit
		set nomore
		return "\<CR>:Z|e #<"
	elseif cmdline =~ filter_stub . 'changes'
		" like :changes but prompts for a change to jump to
		set nomore
		return "\<CR>:Z|norm! g;\<S-Left>"
	elseif cmdline =~ filter_stub . 'ju'
		" like :jumps but prompts for a position to jump to
		set nomore
		return "\<CR>:Z|norm! \<C-o>\<S-Left>"
	elseif cmdline =~ filter_stub . 'marks'
		" like :marks but prompts for a mark to jump to
		return "\<CR>:norm! `"
	elseif cmdline =~ '\v\C^undol'
		" like :undolist but prompts for a change to undo
		return "\<CR>:u "
	elseif cmdline =~ '\v\C^tabs'
		set nomore
		return "\<CR>:Z| tabnext\<S-Left>"
	elseif cmdline =~ '^\k\+$'
		" handle cabbrevs gracefully
		" https://www.reddit.com/r/vim/comments/jgyqhl/nightly_hack_for_vimmers/
		return "\<C-]>\<CR>"
	else
		return "\<CR>"
	endif
endfunction

function! SynGroup() abort
	" Outputs both the name of the syntax group, AND the translated syntax
	" group of the character the cursor is on.
	" line('.') and col('.') return the current position
	" synID(...) returns a numeric syntax ID
	" synIDtrans(l:s) translates the numeric syntax id l:s by following highlight links
	" synIDattr(l:s, 'name') returns the name corresponding to the numeric syntax ID
	" example output:
	" vimMapModKey -> Special
	let l:s = synID(line('.'), col('.'), 1)
	echo synIDattr(l:s, 'name') .. ' -> ' .. synIDattr(synIDtrans(l:s), 'name')
endfunction

" Commands {{{1
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" Autocmds {{{1
" Ask for directory creation on save/new file {{{
augroup Viking
    autocmd!
    autocmd BufNewFile,BufWritePre * :call <SID>EnsureDirExists()
augroup END

" vim: fdm=marker
