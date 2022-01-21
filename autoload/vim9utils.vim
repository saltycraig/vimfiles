vim9script
# vim9utils.vim
# Summary: Utility functions I use, written in vim9 script.

# TODO: make ftdetect to set vim9script ft if found in first line, and
# create a after/ftplugin/vim9script file with better include/defines
def vim9utils#SwitchSourceHeader()
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

def vim9utils#StripTrailingWhitespaces()
  # Don't touch binary files or diff files
  if !&binary && &filetype !=# 'diff'
    var _s = @
    execute "normal! %s/\s\+$//e"
    # restore last search to last search register, ignore above one
    var @/ = _s
  endif
enddef

def vim9utils#ToggleQuickfixList()
  var qwinid = getqflist({'winid': 0}).winid
  if qwinid > 0
    cclose
  else
    botright copen 10
  endif
enddef

def vim9utils#ToggleLocationList()
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

def vim9utils#MaybeReplaceCrWithCrColon()
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

def vim9utils#Redir(cmd: string)
  var output = execute(cmd)
  botright split +enew
  setlocal nobuflisted nonumber norelativenumber buftype=nofile bufhidden=wipe noswapfile
  nnoremap <buffer> q :bwipeout!<CR>
  call setline(1, split(output, "\n"))
enddef

def vim9utils#JekyllOpenLive()
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
  # TODO: make more robust, calling os-specific open like netrw does,
  # like xdg-open on Linux
  execute "silent! !open " . finalurl
enddef

def vim9utils#mytabline(): string
  def GetCurrentTabLabel(tabnr: number): string
    # Give tabpage number return string of :getcwd for that tabpage
    var buflist = tabpagebuflist(tabnr)
    var winnr = tabpagewinnr(tabnr)
    return getcwd(winnr, tabnr)
  enddef
  var s: string
  for i in range(1, tabpagenr('$'))
    # Loop over pages and define labels for them, then get label for each tab
    if i == tabpagenr()
      s ..= '%#TabLineSel#'
    else
      s ..= '%#TabLine#'
    endif
    # set the tab page number, for mouse clicks
    s ..= '%' .. i .. 'T'
    # s ..= ' %{GetCurrentTabLabel(' .. i .. ')} '
    s ..= ' ' .. GetCurrentTabLabel(i) .. ' '
  endfor
  # After last tab fill with hl-TabLineFill and reset tab page nr with %T
  s ..= '%#TabLineFill#%T'
  # Right-align (%=) hl-TabLine (%#TabLine#) style and use %999X for a close
  # current tab mark, with 'X' as the character
  if tabpagenr('$') > 1
    s ..= '%=%#TabLine#%999XX'
  endif
  return s
enddef

def vim9utils#myguitabline(): string
  def GetCurrentTabLabel(tabnr: number): string
    # Give tabpage number return string of :getcwd for that tabpage
    var buflist = tabpagebuflist(tabnr)
    var winnr = tabpagewinnr(tabnr)
    return getcwd(winnr, tabnr)
  enddef
  # This is called for each tabpage when using gui, see ':h 'guitablabel'
  var s = '%N' .. 'T'
  # the actual label
  s ..= ' %{GetCurrentTabLabel(' .. v:lnum  .. ')} '
  return s
enddef

# TODO: make a Make equivalent
def vim9utils#Grep(...args: list<string>): string
  # Based on: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
  #
  # 'expandcmd' allows us to do :Grep 'leader' % and have % expanded to current
  # file like default :grep cmd does
  #
  return system(join([&grepprg] + [expandcmd(join(args))]))
enddef

def vim9utils#CCR(): string
  # Local command we'll keep using to deal with more prompts
  command! -bar Z silent set more|delcommand Z
  if getcmdtype() ==# ':'
    var cmdline = getcmdline()
    # TODO: maybe wrap these in a try to catch cancelled jump and send <CR>
    # to avoid the dreaded hit enter prompt
    # :dlist|ilist becomes :djump/ijump instead
    if cmdline =~# '\v\C^(dli|il)' | return "\<CR>:" .. cmdline[0] .. "jump   " .. split(cmdline, " ")[1] .. "\<S-Left>\<Left>\<Left>"
    elseif cmdline =~# '\v\C^(cli|lli)' | return "\<CR>:silent " .. repeat(cmdline[0], 2) .. "\<Space>"
    elseif cmdline =~# '\C^changes' | set nomore | return "\<CR>:Z|norm! g;\<S-Left>"
    elseif cmdline =~# '\C^ju' | set nomore | return "\<CR>:Z|norm! \<C-o>\<S-Left>"
    elseif cmdline =~# '\v\C(#|nu|num|numb|numbe|number)$' | return "\<CR>:"
    elseif cmdline =~# '\C^ol' | set nomore | return "\<CR>:Z|e #<"
    elseif cmdline =~# '\v\C^(ls|files|buffers)' | return "\<CR>:b"
    elseif cmdline =~# '\C^marks' | return "\<CR>:norm! `"
    elseif cmdline =~# '\C^undol' | return "\<CR>:u "
    else | return "\<CR>" | endif
  else | return "\<CR>" | endif
enddef


