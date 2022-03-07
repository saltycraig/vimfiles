" https://habamax.github.io/2019/03/07/vim-markdown-frontmatter.html
" Fixes tpope/vim-markdown ftplugin (shipped with vim in runtime files)
" creating a fold on YAML frontmatter '---' when in a markdown file, like
" jekyll liquid files, which are .md but contain YAML frontmatter.
"
" This will use YAML syntax in region between --- and ---, which is fine for
" me because I don't use that style headings in Markdown, and it only will
" appear at the top of my jekyll files. May cause issues in OTHER people's .md
" files, but the ---/=== heading variant is not nearly as popular as the hash
" ### style headings.
"
unlet b:current_syntax
syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml

" Also correctly identify Liquid tags used by Jekyll, I'd rather do this than
" switch the entire filetype to 'liquid' and how to work around plugin
" integration issues not identifying liquid ft as markdown, e.g., Tagbar won't
" work correctly unless you tell it that liquid ft is markdown, and there are
" some other instances like that where having a markdown file that is marked as
" 'liquid' in &ft becomes a hindrance.
syntax match liquidTag /{[{%].*[}%]}/
highlight! link liquidTag Statement

