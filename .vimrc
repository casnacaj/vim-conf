set enc=utf-8

set guifont=Monospace\ Regular\ 9

" Make file name visible.
set laststatus=2

" Higlight cursor line
set cursorline

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

" pandoc related.
NeoBundle 'vim-pandoc/vim-pandoc'
NeoBundle 'vim-pandoc/vim-pandoc-syntax'
NeoBundle 'vim-pandoc/vim-pandoc-after'
" NeoBundle 'tex/vimpreviewpandoc'

" File templates.
NeoBundle 'aperezdc/vim-template'

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



" Set how whitespace is displayed.
" To display list of chars, use :dig.
set list
set listchars=eol:¶,tab:├┄,trail:·,extends:»,precedes:«,conceal:∷,nbsp:▒
hi SpecialKey guifg=lightgrey
hi NonText guifg=lightgrey

" Set indentation.
set shiftwidth=2

" Set spaces instead of tabs.
set expandtab
set tabstop=2

" Command to switch ignore/noinore case.
command! IgnoreCase set ignorecase
command! DntIgnoreCase set noignorecase
command! DontIgnoreCase set noignorecase

" Command to show line breaks
command! ShowWindowsLineBreaks e ++ff=unix

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
map indent1 :s/^/ /ge<CR>
map unindent1 :s/^ //ge<CR>
nmap <s-space> indent1
vmap <s-space> indent1 gv
nmap <c-space> unindent1
vmap <c-space> unindent1 gv
nmap <s-tab> :s/^/  /ge \| s/\*\*\(\*\+\)/\1/ge<CR>
vmap <s-tab> :s/^/  /ge \| '<,'>s/\*\*\(\*\+\)/\1/ge<CR> gv
nmap <c-tab> :s/^  //ge \| s/\*\*\*\+/\0**/ge<CR><CR>
vmap <c-tab> :s/^  //ge \| '<,'>s/\*\*\*\+/\0**/ge<CR> gv

" Ctrl+Insert - comment (C-style)
" " Ctrl+Insert - comment (vim style)
" ; Crtl+Insert - comment (asm style)
" # Ctrl+Insert - comment (script style)
" Ctrl+Del - uncomment (all styles)
map ccomment :s/^/\/\//ge<CR>
map vimcomment :s/^/\"/ge<CR>
map asmcomment :s/^/;/ge<CR>
map shcomment :s/^/#/ge<CR>
map uncomment :s/^\(\s*\)\(\/\/\\|#\\|\"\\|;\)/\1/ge<CR>
map starit :s/\*\*\*\+/\0**/ge<CR>
map unstarit :s/\*\*\(\*\+\)/\1/ge<CR>
nmap <C-BS> ccomment
vmap <C-BS> ccomment gv
nmap "<C-BS> vimcomment
vmap "<C-BS> vimcomment gv
nmap ;<C-BS> asmcomment
vmap ;<C-BS> asmcomment gv
nmap #<C-BS> shcomment
vmap #<C-BS> shcomment gv
nmap <C-S-BS> uncomment
vmap <C-S-BS> uncomment gv
"nmap *<C-BS> starit
"vmap *<C-BS> starit gv
"nmap *<C-S-BS> unstarit
"vmap *<C-S-BS> unstarit gv

" Reload .vimrc.
command! ReloadVimRc so ~/.vimrc

" At - Refresh ctags and cscope.
function! RefreshAllTags()
  !ctags -R --extra=f --langmap=Asm:+.inc --exclude=tmp
"  !ctags -R --extra=f
  cs kill 0
" --exclude=build  !cscope -bq $(find -iregex '.+\.\(cpp\|C\|c\|h\|H\|hpp\|asm\|inc\)')
  !find -path ./tmp -prune -o -iregex '.+\.\(cpp\|C\|c\|h\|H\|hpp\|asm\|inc\|s\|S\)' -fprintf cscope.files '"\%p"\n'
  !cscope -bq
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



" Setup vim-templates plugin.
let g:templates_no_autocmd = 1
let g:templates_directory = "~/.vim/templates"
let g:templates_no_builtin_templates = 1
" let g:templates_user_variables = 


" Higlight FIXME text.
syn match FIXME_kw "FIXME" contained
hi kbYellow guibg=Yellow
hi def link FIXME_kw kbYellow

" Set colorcolumn color.
hi ColorColumn guifg=black
" Draw 80th columnt using colorcolumn.
" Turn it by default.
let &colorcolumn="81,121"
command! ColumnOn let &colorcolumn="81,121"
command! ColumnOff set colorcolumn=0

if has('gui_running')
  set spell spelllang=en_gb
endif


" Template user variables
let g:templates_user_variables = [
  \   ['CLASSNAME', 'GetClassName'],
  \   ['LOWERFILE', 'GetLowerName'],
  \ ]

function! GetClassName()
  return join([toupper(expand('%:t:r')[0]), expand('%:t:r')[1:]], "")
endfunction()

function! GetLowerName()
  return join([tolower(expand('%:t:r')[0]), expand('%:t:r')[1:]], "")
endfunction()
