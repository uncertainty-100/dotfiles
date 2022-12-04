
" vim plug {{{
call plug#begin()
" general purpose plugins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
if !has('nvim')
    Plug 'tmsvg/pear-tree'
endif
if has('nvim')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'windwp/nvim-autopairs'
    Plug 'chentoast/marks.nvim'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'https://github.com/kevinhwang91/nvim-ufo.git'
    Plug 'https://github.com/kevinhwang91/promise-async.git'
endif


" C/C++
if !has('nvim')
    Plug 'https://github.com/bfrg/vim-cpp-modern.git'
    Plug 'jackguo380/vim-lsp-cxx-highlight'
endif

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
    " forwards delete
    inoremap <c-n> <right><BS>
    inoremap <c-p> <right><esc>dwi

    
    " changes ^H and ^J to literal backspace and literal carriage return
    " up and down bindings
    imap <c-h> <BS>
    imap <expr> <c-j> coc#pum#visible() ? coc#pum#next(1) : "\<cr>"
    imap <expr> <c-k> coc#pum#visible() ? coc#pum#prev(1) : "\<up>"
    cnoremap <c-k> <up>
    
    " visual mode keep selection
    vmap > >gv
    vmap < <gv

    " clears highlight
    nnoremap <C-L> :nohlsearch<CR><C-L>

    " ctrl-p to fuzzy find a file in new tab
    nnoremap <c-p> :tabnew<cr>:Files<cr>

    " marks jump to position on line instead of start of line
    nnoremap ' `

    let mapleader = "\<SPACE>"

    " boilerplate code {{{
    function! TemplateHeaderGaurd()
        let file_name = toupper(substitute(expand('%:t'), '\.', '_', 'g'))
        return '#ifndef ' . file_name . "\n"
           \ . '#define ' . file_name . "\n"
           \ . '#endif'
    endfunction

    autocmd BufEnter *.h,*.hpp nnoremap <f5> :put<SPACE>=TemplateHeaderGaurd()<CR>ggJjo<CR><CR><UP>
    " }}}

    " highlight analizing
    command! WhichHi call SynStack()
    command! WhichHighlight call SynStack()
    
    function! SynStack()
        if !exists("*synstack")
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunc

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

" coc colors
highlight CocInlayHint ctermfg=102 guifg=#56B6C2 ctermbg=236


" semantic highlighting colors
highlight Keyword ctermfg=170 guifg=#C678DD
highlight Operator ctermfg=145 guifg=#afafaf
highlight Namespace ctermfg=186 guifg=#d7d787
highlight Function ctermfg=68 guifg=#5f87d7
highlight Identifier ctermfg=87 guifg=#5fffff

highlight! def link CocSemMacro Function
highlight! def link CocSemStruct Type
highlight! def link CocSemNamespace Namespace

" coc-git colors
highlight DiffAdd term=bold ctermfg=114 guifg=#98C379 ctermbg=NONE guibg=NONE
highlight DiffDelete term=bold ctermfg=204 ctermbg=NONE guifg=#E06C75 guibg=NONE
highlight DiffChange term=bold cterm=NONE ctermfg=180 gui=underline guifg=#E5C07B

" }}}

" nvim {{{
if has('nvim')
    set mouse=
    set guicursor=i:block
    lua require'nvim-treesitter.configs'.setup{highlight={enable=true}}
    "
    " marks
    lua require'marks'.setup {
                \        default_mappings = true,
                \        builtin_marks = { ".", "<", ">", "^" },
                \        cyclic = true,
                \        force_write_shada = false,
                \        refresh_interval = 250,
                \        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
                \        excluded_filetypes = {},
                \        bookmark_0 = {
                \            sign = "⚑",
                \            virt_text = "hello world",
                \            annotate = false,
                \            },
                \            mappings = {}
                \ }

    " folding
    lua vim.o.foldcolumn = '0'
                \ vim.o.foldlevel = 99
                \ vim.o.foldlevelstart = 99
                \ vim.o.foldenable = true
                \ vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:⏵]]
                \ vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
                \ vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
                \ local handler = function(virtText, lnum, endLnum, width, truncate)
                \     local newVirtText = {}
                \     local suffix = (' 🡷 %d '):format(endLnum - lnum)
                \     local sufWidth = vim.fn.strdisplaywidth(suffix)
                \     local targetWidth = width - sufWidth
                \     local curWidth = 0
                \     for _, chunk in ipairs(virtText) do
                \         local chunkText = chunk[1]
                \         local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                \         if targetWidth > curWidth + chunkWidth then
                \             table.insert(newVirtText, chunk)
                \         else
                \             chunkText = truncate(chunkText, targetWidth - curWidth)
                \             local hlGroup = chunk[2]
                \             table.insert(newVirtText, {chunkText, hlGroup})
                \             chunkWidth = vim.fn.strdisplaywidth(chunkText)
                \             if curWidth + chunkWidth < targetWidth then
                \                 suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                \             end
                \             break
                \         end
                \         curWidth = curWidth + chunkWidth
                \     end
                \     table.insert(newVirtText, {suffix, 'MoreMsg'})
                \     return newVirtText
                \ end
                \ require('ufo').setup({
                \     fold_virt_text_handler = handler,
                \     provider_selector = function(bufnr, filetype, buftype)
                \         return {'treesitter', 'indent'}
                \     end
                \ })

    tnoremap <nowait> <esc><c-w>n <c-\><c-n>
    tnoremap <nowait> <esc><c-w>h <c-\><c-n><c-w>h
    tnoremap <nowait> <esc><c-w>j <c-\><c-n><c-w>j
    tnoremap <nowait> <esc><c-w>k <c-\><c-n><c-w>k
    tnoremap <nowait> <esc><c-w>l <c-\><c-n><c-w>l
endif
" }}}
