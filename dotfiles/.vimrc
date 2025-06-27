" ============================================================================
" COMPLETE VIM CONFIGURATION FOR DAILY USE
" ============================================================================

" Ensure compatibility with modern Vim features
set nocompatible

" ============================================================================
" PLUGIN MANAGEMENT (using vim-plug)
" ============================================================================
" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" File Management
Plug 'scrooloose/nerdtree'                    " File explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                       " Fuzzy finder
Plug 'preservim/nerdcommenter'                " Easy commenting

" Git Integration
Plug 'tpope/vim-fugitive'                     " Git commands
Plug 'airblade/vim-gitgutter'                 " Git diff in gutter

" Language Support & Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Language server support
Plug 'sheerun/vim-polyglot'                   " Language pack
Plug 'dense-analysis/ale'                     " Linting and fixing

" UI Enhancements
Plug 'vim-airline/vim-airline'                " Status line
Plug 'vim-airline/vim-airline-themes'         " Airline themes
Plug 'morhetz/gruvbox'                        " Gruvbox color scheme
Plug 'ryanoasis/vim-devicons'                 " File icons

" Buffer Management
Plug 'ap/vim-buftabline'                      " Buffer tabs
Plug 'qpkorr/vim-bufkill'                     " Better buffer deletion

" Navigation Enhancement
Plug 'tpope/vim-unimpaired'                   " Bracket mappings
Plug 'justinmk/vim-sneak'                     " Fast 2-character search

" Text Manipulation
Plug 'tpope/vim-surround'                     " Surround text objects
Plug 'tpope/vim-repeat'                       " Repeat plugin actions
Plug 'jiangmiao/auto-pairs'                   " Auto bracket pairing
Plug 'godlygeek/tabular'                      " Text alignment

" Navigation & Movement
Plug 'easymotion/vim-easymotion'              " Enhanced movement
Plug 'christoomey/vim-tmux-navigator'         " Tmux integration

" Utility
Plug 'mbbill/undotree'                        " Undo history
Plug 'tpope/vim-obsession'                    " Session management
Plug 'junegunn/vim-easy-align'                " Easy alignment

call plug#end()

" ============================================================================
" BASIC SETTINGS
" ============================================================================

" File handling
set encoding=utf-8
set fileencoding=utf-8
set autoread                    " Auto reload files changed outside vim
set confirm                     " Confirm before closing unsaved files
set hidden                      " Allow hidden buffers

" Display
syntax enable                   " Enable syntax highlighting
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set cursorline                  " Highlight current line
set showmatch                   " Highlight matching brackets
set wrap                        " Wrap long lines
set linebreak                   " Break lines at word boundaries
set scrolloff=8                 " Keep 8 lines visible around cursor
set sidescrolloff=8             " Keep 8 columns visible around cursor
set laststatus=2                " Always show status line
set ruler                       " Show cursor position
set showcmd                     " Show command in status line
set wildmenu                    " Enhanced command completion
set wildmode=longest:full,full  " Command completion mode

" Colors and theme
set termguicolors               " Enable true color support
set background=dark
colorscheme gruvbox

" Indentation
set autoindent                  " Auto indent new lines
set smartindent                 " Smart indentation
set expandtab                   " Use spaces instead of tabs
set tabstop=4                   " Tab width
set softtabstop=4               " Soft tab width
set shiftwidth=4                " Indent width
set shiftround                  " Round indent to multiple of shiftwidth

" Search
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive if uppercase present
set incsearch                   " Incremental search
set hlsearch                    " Highlight search results
set gdefault                    " Global replace by default

" Backup and swap
set nobackup                    " Don't create backup files
set nowritebackup               " Don't create backup before overwriting
set noswapfile                  " Don't create swap files
set undofile                    " Enable persistent undo
set undodir=~/.vim/undodir      " Undo directory
if !isdirectory($HOME.'/.vim/undodir')
    call mkdir($HOME.'/.vim/undodir', 'p')
endif

" Performance
set updatetime=300              " Faster completion
set timeoutlen=500              " Faster key sequence completion
set ttimeoutlen=0               " Eliminate delay after <ESC>
set lazyredraw                  " Don't redraw during macros

" Mouse and clipboard
set mouse=a                     " Enable mouse support
if has('unnamedplus')
    set clipboard=unnamedplus   " Use system clipboard (Linux)
elseif has('unnamed')
    set clipboard=unnamed       " Use system clipboard (macOS)
endif

" Ensure global clipboard works
if executable('xclip')
    " Linux with xclip
    set clipboard+=unnamedplus
elseif executable('pbcopy')
    " macOS with pbcopy
    set clipboard+=unnamed
elseif has('win32') || has('win64')
    " Windows
    set clipboard=unnamed
endif

" Split behavior
set splitbelow                  " Open horizontal splits below
set splitright                  " Open vertical splits to the right

" ============================================================================
" KEY MAPPINGS
" ============================================================================

" Set leader key
let mapleader = " "
let maplocalleader = ","

" Quick escape
inoremap jk <Esc>
inoremap kj <Esc>

" Save and quit shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>Q :qa!<CR>

" Clear search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :BD<CR>
nnoremap <leader>bl :buffers<CR>

" Quick buffer switching (Alt + number)
nnoremap <M-1> :buffer 1<CR>
nnoremap <M-2> :buffer 2<CR>
nnoremap <M-3> :buffer 3<CR>
nnoremap <M-4> :buffer 4<CR>
nnoremap <M-5> :buffer 5<CR>
nnoremap <M-6> :buffer 6<CR>
nnoremap <M-7> :buffer 7<CR>
nnoremap <M-8> :buffer 8<CR>
nnoremap <M-9> :buffer 9<CR>

" Buffer switching with Tab/Shift-Tab
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Close buffer without closing window
nnoremap <leader>bc :BD<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>
nnoremap <leader>> :vertical resize +5<CR>
nnoremap <leader>< :vertical resize -5<CR>

" Tab management
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

" Text manipulation
vnoremap < <gv
vnoremap > >gv
nnoremap <leader>u :UndotreeToggle<CR>

" Copy/paste helpers
vnoremap <leader>y "+y                       " Copy to system clipboard
nnoremap <leader>Y "+Y                       " Copy line to system clipboard
nnoremap <leader>p "+p                       " Paste from system clipboard
nnoremap <leader>P "+P                       " Paste before from system clipboard

" Quick file navigation (Vim-native harpoon-like functionality)
nnoremap <leader>ha :call AddToQuickList()<CR>
nnoremap <leader>hh :call ShowQuickList()<CR>
nnoremap <leader>h1 :call OpenQuickFile(1)<CR>
nnoremap <leader>h2 :call OpenQuickFile(2)<CR>
nnoremap <leader>h3 :call OpenQuickFile(3)<CR>
nnoremap <leader>h4 :call OpenQuickFile(4)<CR>
nnoremap <leader>hc :call ClearQuickList()<CR>
nnoremap <leader>hr :call RemoveFromQuickList()<CR>

" Vim-sneak configuration
let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" Quick edit vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" ============================================================================
" COC EXTENSIONS AND LANGUAGE SERVERS
" ============================================================================

" Install CoC extensions automatically
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-python',
  \ 'coc-go',
  \ 'coc-rust-analyzer',
  \ 'coc-clangd',
  \ 'coc-java',
  \ 'coc-prettier',
  \ 'coc-eslint',
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-emmet',
  \ 'coc-git',
  \ 'coc-yaml',
  \ 'coc-xml',
  \ 'coc-markdownlint',
  \ 'coc-sh'
  \ ]

" ============================================================================
" PLUGIN CONFIGURATIONS
" ============================================================================

" NERDTree
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '\.DS_Store$', '\.pyc$']
let NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1

" FZF
nnoremap <leader>p :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>c :Commands<CR>

" Git (Fugitive)
nnoremap <leader>gs :Git status<CR>
nnoremap <leader>ga :Git add .<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log --oneline<CR>
nnoremap <leader>gd :Gdiffsplit<CR>

" Airline - Minimal and clean
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline_extensions=[]                   " Disable all extensions for minimal look
let g:airline_section_x=''                    " Remove file type
let g:airline_section_y=''                    " Remove file encoding
let g:airline_section_z='%l:%c'               " Only show line:column
let g:airline_left_sep=''                     " Remove separators
let g:airline_right_sep=''                    " Remove separators
let g:airline_symbols_ascii=1                 " Use ASCII symbols
set noshowmode                                " Don't show mode (airline shows it)

" Buffer line configuration - minimal
let g:buftabline_numbers=2
let g:buftabline_indicators=1
let g:buftabline_separators=0                 " No separators for cleaner look
let g:buftabline_show=1                       " Only show when multiple buffers

" CoC Configuration
" Better completion experience
set completeopt=longest,menuone,noinsert,noselect
set shortmess+=c " Don't show completion messages
set belloff+=ctrlg " Don't beep during completion

" Tab completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Trigger completion manually
inoremap <silent><expr> <c-space> coc#refresh()

" CoC mappings for navigation and actions
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)

" Show all diagnostics
nnoremap <silent> <leader>ld :CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent> <leader>do :CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>ds :CocList -I symbols<cr>

" Navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Highlight symbol under cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Format code
command! -nargs=0 Format :call CocAction('format')
nnoremap <leader>fm :Format<CR>

" Use K to show documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" ALE Configuration
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'go': ['golint', 'go vet'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['autopep8'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\}
let g:ale_fix_on_save = 1

" EasyMotion
map <leader>j <Plug>(easymotion-bd-jk)
map <leader>k <Plug>(easymotion-bd-jk)
map <leader>w <Plug>(easymotion-bd-w)

" Easy Align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" GitGutter
set updatetime=100
nnoremap <leader>gg :GitGutterToggle<CR>

" ============================================================================
" AUTOCOMMANDS
" ============================================================================

augroup VimConfig
    autocmd!

    " Auto-reload vimrc when edited
    autocmd BufWritePost $MYVIMRC source $MYVIMRC

    " Remove trailing whitespace on save
    autocmd BufWritePre * %s/\s\+$//e

    " Return to last edit position when opening files
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

    " Auto-close NERDTree if it's the only window left
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

    " File type specific settings
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd FileType javascript,typescript,html,css,json setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
    autocmd FileType markdown setlocal wrap linebreak

augroup END

" ============================================================================
" CUSTOM FUNCTIONS
" ============================================================================

" Simple Harpoon-like functionality for Vim
let g:quick_files = []
let g:quick_files_file = expand('~/.vim/quick_files')

" Load quick files on startup
function! LoadQuickFiles()
    if filereadable(g:quick_files_file)
        let g:quick_files = readfile(g:quick_files_file)
        " Filter out non-existent files
        call filter(g:quick_files, 'filereadable(v:val)')
        " Save the filtered list
        call SaveQuickFiles()
    endif
endfunction

" Save quick files to disk
function! SaveQuickFiles()
    call writefile(g:quick_files, g:quick_files_file)
endfunction

function! AddToQuickList()
    let current_file = expand('%:p')
    if current_file != '' && filereadable(current_file)
        if index(g:quick_files, current_file) == -1
            call add(g:quick_files, current_file)
            call SaveQuickFiles()
            echo "Added: " . fnamemodify(current_file, ':t')
        else
            echo "Already in list: " . fnamemodify(current_file, ':t')
        endif
    else
        echo "File not saved or doesn't exist"
    endif
endfunction

function! ShowQuickList()
    if empty(g:quick_files)
        echo "No files in quick list"
        return
    endif

    echo "Quick Files:"
    for i in range(len(g:quick_files))
        let file_exists = filereadable(g:quick_files[i]) ? "" : " [MISSING]"
        echo (i+1) . ": " . fnamemodify(g:quick_files[i], ':t') . " (" . fnamemodify(g:quick_files[i], ':h') . ")" . file_exists
    endfor
endfunction

function! OpenQuickFile(index)
    if a:index <= len(g:quick_files) && a:index > 0
        let file = g:quick_files[a:index - 1]
        if filereadable(file)
            execute 'edit ' . fnameescape(file)
        else
            echo "File no longer exists: " . fnamemodify(file, ':t')
        endif
    else
        echo "No file at index " . a:index
    endif
endfunction

function! RemoveFromQuickList()
    let current_file = expand('%:p')
    let index = index(g:quick_files, current_file)
    if index >= 0
        call remove(g:quick_files, index)
        call SaveQuickFiles()
        echo "Removed: " . fnamemodify(current_file, ':t')
    else
        echo "File not in quick list"
    endif
endfunction

function! ClearQuickList()
    let g:quick_files = []
    call SaveQuickFiles()
    echo "Quick list cleared"
endfunction

" Load quick files on startup
autocmd VimEnter * call LoadQuickFiles()

" Toggle between relative and absolute line numbers
function! ToggleNumber()
    if &relativenumber
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction
nnoremap <leader>n :call ToggleNumber()<CR>

" Create directory if it doesn't exist when saving
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" ============================================================================
" FINAL SETTINGS
" ============================================================================

" Load local vimrc if it exists
if filereadable($HOME . '/.vimrc.local')
    source $HOME/.vimrc.local
endif

" Set Python provider (for Neovim users who also use this config)
if has('python3')
    set pyx=3
endif

" Enable filetype plugins
filetype plugin indent on
