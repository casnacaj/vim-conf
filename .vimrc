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

NeoBundle 'vim-pandoc/vim-pandoc'
NeoBundle 'vim-pandoc/vim-pandoc-syntax'
NeoBundle 'vim-pandoc/vim-pandoc-after'
NeoBundle 'tex/vimpreviewpandoc'

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



if neobundle#tap("unite.vim")
            \ && neobundle#tap("vim-unite-giti")
            \ && neobundle#tap("vimpreviewpandoc")

    function! s:is_graph_only_line(candidate)
        return has_key(a:candidate.action__data, 'hash') ? 0 : 1
    endfunction

    let s:pandoc_diff_action = {
        \ 'description' : 'pandoc diff with vimpreviewpandoc',
        \ 'is_selectable' : 1,
        \ 'is_quit' : 1,
        \ 'is_invalidate_cache' : 0,
        \ }
    function! s:pandoc_diff_action.func(candidates)
        if s:is_graph_only_line(a:candidates[0])
                    \ || len(a:candidates) > 1 && s:is_graph_only_line(a:candidates[1])
            call giti#print('graph only line')
            return
        endif

        let from  = ''
        let to    = ''
        let file  = len(a:candidates[0].action__file) > 0
                    \               ? a:candidates[0].action__file
                    \               : expand('%:p')
        let relative_path = giti#to_relative_path(file)
        if len(a:candidates) == 1
            let to   = a:candidates[0].action__data.hash
            let from = a:candidates[0].action__data.parent_hash
        elseif len(a:candidates) == 2
            let to   = a:candidates[0].action__data.hash
            let from = a:candidates[1].action__data.hash
        else
            call unite#print_error('too many commits selected')
            return
        endif

        call vimpreviewpandoc#VimPreviewPandocGitDiff(relative_path, from, to)
    endfunction

    call unite#custom#action('giti/log', 'diff_pandoc_preview', s:pandoc_diff_action)
    unlet s:pandoc_diff_action

endif



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

