" ~/.vimrc — Sensible Vim defaults
" Part of ~/dotfiles — managed via install.sh

" ══════════════════════════════════════════
" General
" ══════════════════════════════════════════
set nocompatible
filetype plugin indent on
syntax enable

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

set hidden                      " allow switching buffers without saving
set autoread                    " reload files changed outside vim
set backspace=indent,eol,start  " sane backspace behavior
set mouse=a                     " enable mouse support
set clipboard=unnamedplus       " use system clipboard
set updatetime=250              " faster CursorHold events
set timeoutlen=500              " mapping timeout
set ttimeoutlen=10              " key code timeout

" ══════════════════════════════════════════
" Display
" ══════════════════════════════════════════
set number                      " line numbers
set relativenumber              " relative line numbers
set cursorline                  " highlight current line
set showcmd                     " show partial commands
set showmode                    " show current mode
set laststatus=2                " always show statusline
set ruler                       " show cursor position
set signcolumn=auto             " sign column when needed
set scrolloff=8                 " lines above/below cursor
set sidescrolloff=8             " columns left/right of cursor
set wrap                        " wrap lines
set linebreak                   " wrap at word boundaries
set display+=lastline           " show partial last line

" ══════════════════════════════════════════
" Search
" ══════════════════════════════════════════
set incsearch                   " incremental search
set hlsearch                    " highlight matches
set ignorecase                  " case-insensitive search
set smartcase                   " ...unless uppercase is used

" Clear search highlight with Esc
nnoremap <Esc> :nohlsearch<CR><Esc>

" ══════════════════════════════════════════
" Indentation
" ══════════════════════════════════════════
set expandtab                   " spaces instead of tabs
set shiftwidth=4                " indent width
set tabstop=4                   " tab display width
set softtabstop=4               " tab key width
set smartindent                 " auto-indent new lines
set autoindent                  " keep indent from previous line
set shiftround                  " round indent to shiftwidth

" Filetype-specific indentation
augroup filetype_indent
    autocmd!
    autocmd FileType html,css,javascript,typescript,json,yaml,vue,svelte
                \ setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType make setlocal noexpandtab
    autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

" ══════════════════════════════════════════
" Persistent undo
" ══════════════════════════════════════════
if has('persistent_undo')
    let &undodir = expand('~/.vim/undodir')
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
    set undofile
endif

" ══════════════════════════════════════════
" Swap & Backup
" ══════════════════════════════════════════
let &directory = expand('~/.vim/swap//')
if !isdirectory(&directory)
    call mkdir(&directory, 'p')
endif
set nobackup
set nowritebackup

" ══════════════════════════════════════════
" Completion
" ══════════════════════════════════════════
set wildmenu                    " command-line completion menu
set wildmode=longest:full,full  " complete longest, then cycle
set wildignore+=*.o,*.obj,*.pyc,*.class
set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*
set completeopt=menuone,noinsert,noselect

" ══════════════════════════════════════════
" Leader key
" ══════════════════════════════════════════
let mapleader = ' '
let maplocalleader = ' '

" ══════════════════════════════════════════
" Key mappings
" ══════════════════════════════════════════
" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :ls<CR>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Move lines up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Quick split
nnoremap <leader>sh :split<CR>
nnoremap <leader>sv :vsplit<CR>

" ══════════════════════════════════════════
" Statusline
" ══════════════════════════════════════════
set statusline=
set statusline+=\ %{toupper(mode())}        " current mode
set statusline+=\ │                          " separator
set statusline+=\ %f                         " file path
set statusline+=\ %m%r                       " modified/readonly flags
set statusline+=%=                           " right-align
set statusline+=\ %{&filetype!=#''?&filetype:'none'}  " filetype
set statusline+=\ │\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ │\ %l:%c                   " line:column
set statusline+=\ │\ %p%%                    " percentage
set statusline+=\                             " trailing space

" Statusline colors
highlight StatusLine   cterm=bold ctermfg=15 ctermbg=236
highlight StatusLineNC cterm=NONE ctermfg=244 ctermbg=235

" ══════════════════════════════════════════
" Trim trailing whitespace on save
" ══════════════════════════════════════════
augroup trim_whitespace
    autocmd!
    autocmd BufWritePre * let b:pos = getpos('.')
                \ | silent! %s/\s\+$//e
                \ | call setpos('.', b:pos)
augroup END

" ══════════════════════════════════════════
" Misc
" ══════════════════════════════════════════
" Return to last edit position when opening files
augroup last_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                \ | execute "normal! g'\""
                \ | endif
augroup END

" Highlight yanked text briefly
if exists('##TextYankPost')
    augroup highlight_yank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout=200})
    augroup END
endif

" ══════════════════════════════════════════
" Local overrides
" ══════════════════════════════════════════
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
