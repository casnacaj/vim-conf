
" highlight occurence of selected text
set hlsearch

" Disable default anoying Middle button behavior.
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
" Use Ctrl+Rigth click and Ctrl+Middle click for text copying.
map <C-MiddleMouse> "+gP
map <C-RightMouse> "+y

" Shift+Space - indent 1 space
" Ctrl+Space - unindent 1 space
" Shift+Tab - indent 2 spaces
" Shift+Tab - unindent 2 spaces
map indent1 :s/^/ /g<CR>
map indent2 :s/^/  /g<CR>
map unindent1 :s/^ //g<CR>
map unindent2 :s/^  //g<CR>
map <s-space> indent1 gv
map <c-space> unindent1 gv
map <s-tab> indent2 gv
map <c-tab> unindent2 gv

" Ctrl+Insert - comment (C-style)
" " Ctrl+Insert - comment (vim style)
" ; Crtl+Insert - comment (asm style)
" # Ctrl+Insert - comment (script style)
" Ctrl+Del - uncomment (all styles)
map <C-Insert> :s/^/\/\//g<CR>
map "<C-Insert> :s/^/\"/g<CR>
map ;<C-Insert> :s/^/;/g<CR>
map #<C-Insert> :s/^/#/g<CR>
map <C-Del> :s/^\(\s*\)\(\/\/\\|#\\|\"\\|;\)/\1/g<CR>

" Reload .vimrc.
command! ReloadVimRc so ~/.vimrc

" At - Refresh ctags and cscope.
function! RefreshAllTags()
"  !ctags -R --extra=f langmap=Asm:+.inc
  !ctags -R --extra=f
  cs kill 0
  !cscope -bq $(find -iregex '.+\.\(cpp\|C\|c\|h\|H\|hpp\|asm\|inc\)')
  cs add cscope.out
endfunction

command! At call RefreshAllTags()

" PyAt - refresh ctags and pycscope.
function! RefreshAllPyTags()
  !ctags -R --extra=f
  cs kill 0
  !pycscope -R
  cs add cscope.out
endfunction

command! PyAt call RefreshAllPyTags()

