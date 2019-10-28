" filetype plugin indent on

" syntax highlight
syntax on

" remap  <Esc> to jj
:imap jj <Esc>
:tnoremap uu <C-\><C-n>
set number

" Share clipboard with OS
" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard
  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" search hidden files with ctrlp
let g:ctrlp_show_hidden = 1

" move up and down one visible line (not newline)
nmap j gj
nmap k gk

" allow backspace to function as you might expect
" normally vim uses behavior like not letting you use
" backspace past where the insert started
set backspace=indent,eol,start

" incremental search
set incsearch
" ignore case while searching
set ignorecase
" If a char is capatlized don't ignore its case while searching
set smartcase
" higlight terms as searching 
set hlsearch
" key to remove search highlighting
nmap <esc> :nohlsearch<CR>

" Wrap and show text after 80 chars
set textwidth=80

" add line at 80 chars
au BufNewFile,BufRead *.md setlocal colorcolumn=81

" more natural pane splitting
set splitbelow
set splitright

" better naviagtion in split panes
:nnoremap <C-H> <C-W><C-H>
:nnoremap <C-J> <C-W><C-J>
:nnoremap <C-K> <C-W><C-K>
:nnoremap <C-L> <C-W><C-L>

" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
" }}} Spaces & Tabs
"
" Scrollbak buffer {{{
function! ClearScrollback()
  if &scrollback == 0
    set scrollback=10000
  else
    set scrollback=0
  endif
endfunction

command CS call ClearScrollback()
:tnoremap <C-x> <C-\><C-n>:CS<CR><s-a>
" }}} Scrollback buffer

" ** KEEP at EOF **
" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

"make terminal buffers 'hide' so when I do C-w o to maximize one the others
"aren't lost
autocmd TermOpen * set bufhidden=hide
