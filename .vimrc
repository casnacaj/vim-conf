"NeoBundle Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/humpl/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('/home/humpl/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------



" highlight occurence of selected text
set hlsearch

" Disable default anoying Middle button behavior.
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
" Use Ctrl+Rigth click and Ctrl+Middle click for text copying.
map <C-LeftMouse> "+gP
map <C-RightMouse> "+y

" Shift+Space - indent 1 space
" Ctrl+Space - unindent 1 space
" Shift+Tab - indent 2 spaces
" Shift+Tab - unindent 2 spaces
map indent1 :s/^/ /g<CR>
map indent2 :s/^/  /g<CR>
map unindent1 :s/^ //g<CR>
map unindent2 :s/^  //g<CR>
nmap <s-space> indent1
vmap <s-space> indent1 gv
nmap <c-space> unindent1
vmap <c-space> unindent1 gv
nmap <s-tab> indent2
vmap <s-tab> indent2 gv
nmap <c-tab> unindent2
vmap <c-tab> unindent2 gv

" Ctrl+Insert - comment (C-style)
" " Ctrl+Insert - comment (vim style)
" ; Crtl+Insert - comment (asm style)
" # Ctrl+Insert - comment (script style)
" Ctrl+Del - uncomment (all styles)
map ccomment :s/^/\/\//g<CR>
map vimcomment :s/^/\"/g<CR>
map asmcomment :s/^/;/g<CR>
map shcomment :s/^/#/g<CR>
map uncomment :s/^\(\s*\)\(\/\/\\|#\\|\"\\|;\)/\1/g<CR>
nmap <C-Insert> ccomment
vmap <C-Insert> ccomment gv
nmap "<C-Insert> vimcomment
vmap "<C-Insert> vimcomment gv
nmap ;<C-Insert> asmcomment
vmap ;<C-Insert> asmcomment gv
nmap #<C-Insert> shcomment
vmap #<C-Insert> shcomment gv
nmap <C-Del> uncomment
vmap <C-Del> uncomment gv

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

