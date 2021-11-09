Hooks that set a filetype's buffer are first read from here, so if we want
to overwrite what Vim would generally set as the `:echo &filetype` we can
set it here first.

For instance, I set some specific files that contain certain text to liquid
filetype that otherwise aren't detect as liquid by the provided vim-liquid
because they are special case for my work.
