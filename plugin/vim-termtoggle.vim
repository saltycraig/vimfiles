" Reload guard
if exists("g:loaded_vim_termtoggle")
  finish
endif
let g:loaded_vim_termtoggle = 1

let s:save_cpo = &cpo
set cpo&vim

if !hasmapto('<Plug>ToggleTerminal')
  noremap <unique> <Leader>` <Plug>ToggleTerminal
endif

noremap <unique> <script> <Plug>ToggleTerminal <SID>ToggleTerminal
noremap <SID>ToggleTerminal :call <SID>ToggleTerminal()<CR>

function! s:ToggleTerminal() abort
  let bufferNum = bufnr('vim-termtoggle')
  if bufferNum == -1 || bufloaded(bufferNum) != 1
    term ++close
  else
    let windowNum = bufwinnr(bufferNum)
    if windowNum == -1
      execute 'sbuffer ' . bufferNum
    else
      execute windowNum . 'wincmd w'
      hide
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
