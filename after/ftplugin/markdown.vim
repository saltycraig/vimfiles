if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

setlocal complete+=k/usr/share/dict/words

" Match next and previous e.g., '### Title'
onoremap <buffer> nh :<C-u>normal! /^#\+.*$
onoremap <buffer> lh :<C-u>normal! ?^#\+.*$
onoremap <buffer> ih :<C-U>normal! /^#\+.*$

compiler vale

let b:undo_ftplugin = ""
