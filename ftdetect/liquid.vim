" To capture release-notes.md and migration-notes.md which are snippet files.
" To specific for my work-case to upstream to vim-liquid plugin.
autocmd BufNewFile,BufRead *.markdown,*.mkd,*.mkdn,*.md
      \ if getline(1) =~# "^We\.re excited" |
      \   let b:liquid_subtype = 'markdown' |
      \   set filetype=liquid |
      \ elseif getline(1) =~# "^\\d.\\d\\d is the first generally" |
      \   let b:liquid_subtype = 'markdown' |
      \   set filetype=liquid | 
      \ elseif getline(2) =~# "^layout: redirect" |
      \   let b:liquid_subtype = 'markdown' |
      \   set filetype=liquid |
      \ endif
