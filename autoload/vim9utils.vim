vim9script
# vim9utils.vim
# Summary: Utility functions I use, written in vim9 script.

export def SwitchSourceHeader()
  # Switch between cpp/.h files, user must set relevant 'path'
  # value for this to work, e.g., 'set path=.,,**5'
  if &ft ==# 'cpp'
    if (expand('%:e') ==# 'cpp')
      # find equivalent header file
      find %:t:r.h
    else
      # we are a header file, find source file
      find %:t:r.cpp
    endif
  endif
enddef

export def StripTrailingWhitespaces()
  # Don't touch binary files or diff files
  if !&binary && &filetype !=# 'diff'
    var lastsearch = getreg('/')
		var l = line(".")
		var c = col(".")
    execute ':%s/\s\+$//e'
    # restore last search to last search register, ignore above one
    setreg('/', lastsearch)
		cursor(l, c)
  endif
enddef

# OLD: I use vim-qf functions now
export def ToggleQuickfixList()
  var qwinid = getqflist({'winid': 0}).winid
  if qwinid > 0
    cclose
  else
    botright copen 10
  endif
enddef

# OLD: I use vim-qf functions now
export def ToggleLocationList()
  # Tries to toggle open/close location list for current window,
  # if no loclist exists then just ignore error stating such
  var lwinid = getloclist(0, {'winid': 0}).winid
  if lwinid > 0
    lclose
  else
    try
      botright lopen 10
    catch /E776/
      echohl WarningMsg
      echo 'Window has no associated location list.'
      echohl None
      return
    endtry
  endif
enddef

export def MaybeReplaceCrWithCrColon()
  # Return <CR>: and maybe followed by a 'b' or 'u' or more, depending on what
  # the command requires to user to enter to work.
  # https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
  var cmdline = getcmdline()
  if cmdline =~ '\v\C^(ls|files|buffers)'
    return "\<CR>:b"
  elseif cmdline =~ '\v\C(#|nu|num|numb|numbe|number)$'
    return "\<CR>:"
  elseif cmdline =~ '\v\C^(dli|li)'
    return "\<CR>:" .. cmdline[0] .. "j " .. split(cmdline, ' ')[1] .. "\<S-Left>\<Left>"
  elseif cmdline =~ '\v\C^(cli|lli)'
    # like :clist or :llist but prompts for an error/location number
    return "\<CR>:sil " .. repeat(cmdline[0], 2) .. "\<Space>"
  elseif cmdline =~ '\C^old'
    # like :oldfiles but prompts for an old file to edit
    set nomore
    return "\<CR>:sil se more|e #<"
  elseif cmdline =~ '\C^changes'
    # like :changes but prompts for a change to jump to
    set nomore
    return "\<CR>:sil se more|norm! g;\<S-Left>"
  elseif cmdline =~ '\C^ju'
    # like :jumps but prompts for a position to jump to
    set nomore
    return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
  elseif cmdline =~ '\C^marks'
    # like :marks but prompts for a mark to jump to
    return "\<CR>:norm! `"
  elseif cmdline =~ '\C^undol'
    # like :undolist but prompts for a change to undo
    return "\<CR>:u "
  else
    return "\<CR>"
  endif
enddef

# example: :Redir scriptnames, :Redir ls!, does not work for external like
# :Redir !which python, though 
export def Redir(cmd: string)
	# TODO: I could detect if cmd startswith ! and run it with system()?
  var output = execute(cmd)
  botright split +enew
  setlocal nobuflisted nonumber norelativenumber buftype=nofile bufhidden=wipe noswapfile
  nnoremap <buffer> q :bwipeout!<CR>
  call setline(1, split(output, "\n"))
enddef

export def JekyllOpenLive()
  # Requires 'devx' as &pwd for '%:.' to work correctly with forming the final URL to open
  if !getcwd() =~ 'devx' 
    echoerr 'Command only works when &pwd is "devx"'
    return
  endif
  var relpath = expand('%:.')
        \ ->substitute('_ver_', '', '')
        \ ->substitute('^docs', '', '')
        \ ->substitute('\.md$', '/', '')
  # cases:
  # docs/_ver_6.14/path/to/file
  # docs/release-details/file-with-version-6.8.md
  var newversion = relpath->matchstr('\d\.\d\d\?')
  # When relpath = version/path/to/topic we need to drop leading \d\.\d\d\? dir, otherwise we end
  # up with 6.15/6.15/path/to/file. We only check up to first / to limit to first folder.
  var newpath = newversion .. relpath->substitute('\d\.\d\d\?/', '', '')
  # any version 6.14 and over requires localhost only
  var host = str2float(newversion) >= 6.14 ? 'http://localhost:4000' : 'https://developer-staging.youi.tv/'
  var finalurl = host .. newpath
  execute "silent! !open " . finalurl
	redraw!
enddef

export def MyTabline(): string
  var line: string = ''
  for i in range(tabpagenr('$'))
		var tabnr: number = i + 1 # tab index starts at 1
		var winnr: number = tabpagewinnr(tabnr) # active window number
		 
		var buflist: list<number> = tabpagebuflist(tabnr) # => [21, 24, 25]
		var bufnr: number = buflist[winnr - 1]

    line ..= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
		# mouse support and highlighting current selected tab
		line ..= '%' .. tabnr .. 'T'

		# show the current active buffer name, just the filename
		var bufname: string = fnamemodify(bufname(bufnr), ':t')
		line ..= ' ' .. (bufname == '' ? '[No Name]' : bufname)
		# show the tab number, put it at the back or will get cutoff
		# when tablabel too wide
		line ..= ' ' .. tabnr .. ' '
		# modified? add '+'
		line ..= (getbufvar(bufnr, "&mod") ? '+ ' : '')

  endfor
  # After last tab fill with hl-TabLineFill and reset tab page nr with %T
  line ..= '%#TabLineFill#%T'
  # Right-align (%=) hl-TabLine (%#TabLine#) style and use %999X for a close
  # current tab mark, with 'X' as the character
  if tabpagenr('$') > 1
    line ..= '%=%#TabLine#%999XX'
  endif
  return line
enddef

export def Grep(...args: list<string>): string
  # Based on: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
  #
  # 'expandcmd' allows us to do :Grep 'leader' % and have % expanded to current
  # file like default :grep cmd does
  #
  return system(join([&grepprg] + [expandcmd(join(args))]))
enddef

export def Make(): string
  # TODO: works for simple cases but I will need to escape more I think to get
  # things like makeprg value of :compiler liquid to work correctly.
  return system(expandcmd(&makeprg))
enddef

export def CCR(): string
  # https://gist.github.com/romainl/5b2cfb2b81f02d44e1d90b74ef555e31
	# TODO: maybe wrap these in a try to catch cancelled jump and send <CR>
	# to avoid the dreaded hit enter prompt
	#
	var cmdline = getcmdline()
	var filter_stub = '\v\C^((filt|filter|filter) .+ )*'
  # Local command to reset temporary 'nomore', then delete the command
  command! -bar Z silent set more|delcommand Z
  if getcmdtype() !~ ':'
		return "\<CR>"
	endif
  if cmdline =~ filter_stub .. '(ls|files|buffers)$'
		# like :ls but prompt for a buffer
		return "\<CR>:b"
	elseif cmdline =~ '\v\C^(#|nu|num|numb|numbe|number|l|li|lis|list)$'
		# like :g//# but prompts for a command
		return "\<CR>:"
	elseif cmdline =~ filter_stub .. '(\%)*(#|nu|num|numb|numbe|number|l|li|lis|list)$'
		# like :g//# but prompts for a command
		return "\<CR>:"
	elseif cmdline =~ '\v\C^(dli|il)'
		# like :dlist or :ilist but prompts for a count for :djump or :ijump
		return "\<CR>:" .. cmdline[0] .. "j  " .. split(cmdline, " ")[1] .. "\<S-Left>\<Left>"
	elseif cmdline =~ filter_stub .. '(cli)'
		# like :clist or :llist but prompts for an error/location number
		return "\<CR>:sil cc\<Space>"
	elseif cmdline =~ filter_stub .. '(lli)'
		# like :clist or :llist but prompts for an error/location number
		return "\<CR>:sil ll\<Space>"
	elseif cmdline =~ filter_stub .. 'old'
		# like :oldfiles but prompts for an old file to edit
		set nomore
		return "\<CR>:Z|e #<"
	elseif cmdline =~ filter_stub .. 'changes'
		# like :changes but prompts for a change to jump to
		set nomore
		return "\<CR>:Z|norm! g;\<S-Left>"
	elseif cmdline =~ filter_stub .. 'ju'
		# like :jumps but prompts for a position to jump to
		set nomore
		return "\<CR>:Z|norm! \<C-o>\<S-Left>"
	elseif cmdline =~ filter_stub .. 'marks'
		# like :marks but prompts for a mark to jump to
		return "\<CR>:norm! `"
	elseif cmdline =~ '\v\C^undol'
		# like :undolist but prompts for a change to undo
		return "\<CR>:u "
	elseif cmdline =~ '\v\C^tabs'
		set nomore
		return "\<CR>:Z| tabnext\<S-Left>"
	elseif cmdline =~ '^\k\+$'
		# handle cabbrevs gracefully
		# https://www.reddit.com/r/vim/comments/jgyqhl/nightly_hack_for_vimmers/
		return "\<C-]>\<CR>"
	else
		return "\<CR>"
	endif
enddef

# TODO: finish this. takes a 'site', next, nextonly, prod, etc.
# to determine which prefix URL to use
export def JekyllOpen(site: string)
  # Requires 'devx' as &pwd for '%:.' to work correctly with forming the final URL to open
  if !getcwd() =~ 'devx' 
    echoerr 'Command only works when &pwd is "devx"'
    return
  endif
  var relpath = expand('%:.')
        \ ->substitute('_ver_', '', '')
        \ ->substitute('^docs', '', '')
        \ ->substitute('\.md$', '/', '')

  # cases:
  # docs/_ver_6.14/path/to/file
  # docs/release-details/file-with-version-6.8.md
  var newversion = relpath->matchstr('\d\.\d\d\?')

  # When relpath = version/path/to/topic we need to drop leading \d\.\d\d\? dir, otherwise we end
  # up with 6.15/6.15/path/to/file. We only check up to first / to limit to first folder.
  var newpath = newversion .. relpath->substitute('\d\.\d\d\?/', '', '')

  # any version 6.14 and over requires localhost only
  var host = str2float(newversion) >= 6.14 ? 'https://localhost.com:8080/' : 'https://developer-staging.youi.tv/'

  var finalurl = host .. newpath
  execute "silent! !open " .. finalurl
enddef

export def SynGroup() 
  # Outputs both the name of the syntax group, AND the translated syntax
  # group of the character the cursor is on.
  # line('.') and col('.') return the current position
  # synID(...) returns a numeric syntax ID
  # synIDtrans(l:s) translates the numeric syntax id l:s by following highlight links
  # synIDattr(l:s, 'name') returns the name corresponding to the numeric syntax ID
  # example output:
  # vimMapModKey -> Special
  var s = synID(line('.'), col('.'), 1)
  echo synIDattr(s, 'name') .. ' -> ' .. synIDattr(synIDtrans(s), 'name')
enddef

# TODO: universal ctags pattern to match:
# /\v^exp%[ort]\s+%[def\|class\|const\|final\|interface]\s+
