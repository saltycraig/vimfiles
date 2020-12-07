# Vim notes

Just stuff I forget/need to reference that I often forget and/or want
out of my brain!

## Vim Scripting Gotchas and Best Practices

* `:help eval.txt` is the bible and final say.
* I added `:API` command to bring up `:h function-list`

Comparisons Operators:

* always use `==#` to match case and e.g., `>=?` to ignore case.
* see `:h expr4` for details on comparing expressions.

Functions:

* always add `abort` keyword, e.g., `function! foo() abort `
* always use `function!`

## Vimscript vs. Vim 9 Reference


## Whitespace and Tab Settings

Explanations of and defaults for these settings:

* tabstop
* shiftwidth
* shiftround
* softtabstop
* expandtab
* autoindent

Which are all related to whitespace/tab settings.

```vim
" Whitespace/Tab Settings
" Number of spaces <Tab> counts for. Whether 1 tab byte 0x09 will be replaced
" set tabstop=8
" Governs how much to indent (e.g., >> command)
" Whether it uses spaces or tab character is up to a few settings:
"   * if 'noexpandtab': tries to use tab bytes (\x09) alone. It will use
"   spaces as needed if the result of tabstop / shiftwidth is not 0.
"   * if 'expandtab': only use space bytes.
" Unless you want mixed tab and space bytes (THE HORROR.) if you set
" tabstop and shiftwidth to different values that are non equally divisible,
" use 'expandtab'.
" set shiftwidth=8
" Rounds indenting actions to a multiple of 'shiftwidth' if this is on.
" set noshiftround
" Number of spaces that tab byte \x09 counts for when doing edits like
" when pressing <Tab> or <BS>. It uses a mix of space \x020 and tab
" \x09 bytes. Useful to keep tabstop at 8 while being able to add tabs
" and delete like it is set to softtabstop (insert/remove that many
" whitespaces, made up of space and tab characters).
"  * if 'noexpandtab': number of \x020 (space) bytes are minimized by
"  inserting as many \x09 (tab) bytes as possible.
" set softtabstop=0
" Don't use space bytes \x020 to make up tab \x09 bytes, use real tabs.
" Technically small filesizes with tab characters, but with minification
" on most web/code now being popular, this doesn't matter as much.
" set noexpandtab
" Do not copy indent from current line when starting new line: <CR>,o,O
" set noautoindent
```
