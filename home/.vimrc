
" vim plug {{{
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tmsvg/pear-tree'
Plug 'itchyny/lightline.vim'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" C/C++
Plug 'https://github.com/bfrg/vim-cpp-modern.git'
call plug#end()

" }}}

" SETTINGS {{{

set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on

set number
set relativenumber

set cursorline

set shiftwidth=4
set tabstop=4
set expandtab

set nobackup

set scrolloff=15

set nowrap

set ignorecase
set smartcase

set showcmd
set noshowmode

set history=1000

set hlsearch
set incsearch
set showmatch

set foldmethod=syntax
set foldlevel=20
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType python setlocal foldmethod=indent
    autocmd BufRead,BufNewFile makefile,Makefile,MakeFile,MAKEFILE setlocal foldmethod=indent
augroup END

" }}}

" bindings {{{
    " movement keys for insert mode
    " insert mode cannot be inoremap else unable to navigate coc autocomplete
    imap <c-k> <down>
    imap <c-l> <up>
    cnoremap <c-k> <down>
    cnoremap <c-l> <up>

    " forwards delete
    inoremap <c-n> <right><BS>
    inoremap <c-p> <right><esc>dwi

    
    " changes ^H to literal backspace
    imap <c-h> <BS>

    " visual mode keep selection
    vmap > >gv
    vmap < <gv

    " clears highlight
    nnoremap <C-L> :nohlsearch<CR><C-L>

    let mapleader = "\<tab>"

    function! TemplateHeaderGaurd()
        let file_name = toupper(substitute(expand('%:t'), '\.', '_', 'g'))
        return '#ifndef ' . file_name . "\n"
           \ . '#define ' . file_name . "\n"
           \ . '#endif'
    endfunction

    autocmd BufEnter *.h,*.hpp nnoremap <f5> :put<SPACE>=TemplateHeaderGaurd()<CR>ggJjo<CR><CR><UP>

" }}}

" plugins {{{

" coc {{{
        
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ coc#pum#visible() ? coc#pum#next(1):
"       \ CheckBackspace() ? "\<Tab>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <expr> <tab> coc#pum#visible() ? coc#pum#confirm() : "\<tab>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

let g:coc_global_extensions = ["coc-git"]

" }}}

" lightline {{{

set laststatus=2
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [
            \       [ 'mode', 'paste' ],
            \       [ 'readonly', 'filename' ],
            \       [ 'coc_error', 'coc_warn' ],
            \       [ 'git_info' ],
            \   ],
            \   'right':[
            \       [ 'percent' ],
            \       [ 'lineinfo' ],
            \       [ 'filetype', 'fileencoding'],
            \       [ 'blame' ],
            \   ],
            \ },
            \ 'inactive': {
            \   'left': [
            \       [ 'mode', 'paste' ],
            \       [ 'readonly', 'filename' ],
            \       [ 'coc_status' ],
            \   ],
            \   'right': [
            \       [ 'percent' ],
            \       [ 'lineinfo' ],
            \       [ 'filetype', 'fileencoding'],
            \   ]
            \ },
            \ 'component_expand': {
            \   'coc_error': 'LightlineCocError',
            \   'coc_warn': 'LightlineCocWarn',
            \ },
            \ 'component_function': {
            \   'filename': 'LightlineFileName',
            \   'blame': 'LightlineGitBlame',
            \   'git_info': 'LightlineGitInfo',
            \ },
            \ 'component_type': {
            \   'coc_error': 'error',
            \   'coc_warn': 'warning',
            \ }
            \ }

function! LightlineCocError()
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    if get(info, 'error', 0)
        return info['error'] . 'E'
    endif
    return ''
endfunction


function! LightlineCocWarn()
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    if get(info, 'warning', 0)
        return info['warning'] . 'W'
    endif
    return ''
endfunction

function! LightlineFileName()
    let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
    let modified = &modified ? '*' : ''
    return filename . modified
endfunction

function! LightlineGitInfo()
    return get(g:, 'coc_git_status', '') . get(b:, 'coc_git_status', '')
endfunction

function! LightlineGitBlame()
  let blame = get(b:, 'coc_git_blame', '')
  return blame
  " return winwidth(0) > 120 ? blame : ''
endfunction

augroup lightline#coc
  autocmd!
  autocmd User CocDiagnosticChange call lightline#update()
  autocmd User CocStatusChange call lightline#update()
augroup END

" }}}


" }}}

" theme {{{

" set termguicolors
if (has("autocmd"))
    augroup colorextend
        autocmd!
        autocmd ColorScheme * call onedark#extend_highlight("LineNr", { "fg": { "cterm": 102 } })
        autocmd ColorScheme * call onedark#extend_highlight("CursorLineNr", { "fg": { "cterm": 255 } })
    augroup END
endif

colorscheme onedark

" coc-git colors
highlight DiffAdd term=bold ctermfg=114 guifg=#98C379 ctermbg=NONE guibg=NONE
highlight DiffDelete term=bold ctermfg=204 ctermbg=NONE guifg=#E06C75 guibg=NONE
highlight DiffChange term=bold cterm=NONE ctermfg=180 gui=underline guifg=#E5C07B

" }}}
