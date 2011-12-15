" This must be first, because it changes other options as a side effect.
set nocompatible          " We're running Vim, not Vi!
filetype off              " Only temporarily while we load pathogen...

" Load Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'jQuery'
Bundle 'ragtag.vim'

Bundle "git://github.com/tpope/vim-fugitive.git"
Bundle "git://github.com/tpope/vim-git.git"
Bundle "git://github.com/tpope/vim-repeat.git"
Bundle "git://github.com/tpope/vim-surround.git"
Bundle "git://github.com/tpope/vim-vividchalk.git"
Bundle "git://github.com/scrooloose/nerdcommenter.git"
Bundle "git://github.com/vim-ruby/vim-ruby.git"
Bundle "git://github.com/msanders/snipmate.vim.git"
Bundle "git://github.com/vim-scripts/ZoomWin.git"
Bundle "git://github.com/wincent/Command-T.git"
Bundle "git://github.com/davidoc/taskpaper.vim.git"
Bundle "git://github.com/vim-scripts/jade.vim.git"
Bundle "git://github.com/tpope/vim-haml.git"
Bundle "https://github.com/kchmck/vim-coffee-script.git"
Bundle "https://github.com/tpope/vim-rails.git"
Bundle "git://github.com/altercation/vim-colors-solarized.git"
Bundle "https://github.com/jgdavey/vim-railscasts.git"
Bundle "https://github.com/mileszs/ack.vim"
Bundle "https://github.com/kogakure/vim-sparkup"

let mapleader = ","

" disallow vi commands from files
set modelines=0

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" borrowed from the Janus vimrc
" seemingly necessary for zoomwin
set noequalalways

" Command-T configuration
let g:CommandTMaxHeight=20

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" Ack
map <Leader>a :Ack<space>

" lazy escape
imap jj <Esc>

" keep more history
set history=100

" show hidden buffers
set nohidden

" don't beep
set visualbell
set noerrorbells

" numbers, we like them
set number

" Syntax highlighting
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  " sync syntax from the start of the file
  syntax sync fromstart
  set hlsearch
endif

"ColorScheme if terminal has colors (not in GUI)
if (&t_Co > 7)
  "colorscheme summerfruit256
  colorscheme ir_black
  "assume we can use !open
  map <Leader>o :!open %<CR>
endif

" Indentation and Tab handling
set smarttab
set expandtab
set autoindent
set shiftwidth=2
set tabstop=2
set autoindent smartindent

" Line Wrapping
set nowrap
set linebreak             " Wrap at word

" Search results
set incsearch             " incremental searching
set ignorecase            " case insensitive searching
set smartcase

" Toggle search results with spacebar
map <Space> :set hlsearch!<cr>

" use Q for formatting per :h gq
nnoremap Q gq

" catch trailing whitespace
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" Swapfiles. Meh. Using Git instead.
set nobackup
set noswapfile
set nowritebackup

" show incomplete commands
set showcmd

" Split windows behavior
set splitbelow
set splitright

" kill the splash screen
set shortmess=atI

set ruler
set undolevels=1000

set showmatch

set wildmenu

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    autocmd!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal g`\"" |
      \ endif
  augroup END

  "augroup myfiletypes "forget this... make exceptions per directory below &
	"per file with modelines.
    "" Clear old autocmds in group
    "autocmd!
    "" autoindent with two spaces, always expand tabs
    "autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
    "autocmd FileType javascript set ai sw=2 sts=2 et
    "autocmd FileType php set ai noet
  "augroup END

	" noexpandtab in brownbagrx coffeescript
	autocmd BufNewFile,BufRead ~/mamp/brownbagrx/app/assets/javascripts/* set nowrap noexpandtab tabstop=2 shiftwidth=2

  augroup module
    autocmd BufRead *.module set filetype=php
  augroup END

  augroup inc
    autocmd BufRead *.inc set filetype=php
  augroup END

  augroup taskpaper
    au! BufRead,BufNewFile *.tp   setfiletype taskpaper
  augroup END

else
  set autoindent    " always set autoindenting on
endif " has("autocmd")

if has("folding")
  set foldenable
  set foldmethod=indent
  set foldlevel=3
  set foldnestmax=2
  set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
  set foldcolumn=0

  " automatically open folds at the starting cursor position
  " autocmd BufReadPost .foldo!
endif

" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

" Status line configuration (from tomasr)
" ---------------------------------------
set laststatus=2 " Always show status line
if has('statusline')
  " Status line detail:
  " %f    file path
  " %y    file type between braces (if defined)
  " %([%R%M]%)  read-only, modified and modifiable flags between braces
  " %{'!'[&ff=='default_file_format']}
  "      shows a '!' if the file format is not the platform
  "      default
  " %{'$'[!&list]}  shows a '*' if in list mode
  " %{'~'[&pm=='']}  shows a '~' if in patchmode
  " (%{synIDattr(synID(line('.'),col('.'),0),'name')})
  "      only for debug : display the current syntax item name
  " %=    right-align following items
  " #%n    buffer number
  " %l/%L,%c%V  line number, total number of lines, and column number
  fun! SetStatusLineStyle()
    if &stl == '' || &stl =~ 'synID'
      let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]}%{'~'[&pm=='']}%{fugitive#statusline()}%=#%n %l/%L,%c%V "
    else
      let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]} (%{synIDattr(synID(line('.'),col('.'),0),'name')})%=#%n %l/%L,%c%V "
    endif
  endfunc
  " Switch between the normal and vim-debug modes in the status line
  nmap _ds :call SetStatusLineStyle()<CR>
  call SetStatusLineStyle()

  " Window title
  if has('title')
    set titlestring=%t%(\ [%R%M]%)
  endif
endif

" Helper for creating Color Schemes (from vimcasts.org); ctrl-shift-P
" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" quick toggle relative number per http://news.ycombinator.com/item?id=2907730
" modified to default to number & skip norelativenumber

if v:version >= 703
  set number
  let s:relativenumber = 1
  function! <SID>ToggleRelativeNumber()
    if s:relativenumber == 0
      set number
      let s:relativenumber = 1
    elseif s:relativenumber == 1
      set relativenumber
      let s:relativenumber = 0
    endif
  endfunction
  map <silent><F10> :call <SID>ToggleRelativeNumber()<CR>
else
  set number
endif

" up/down move between visual lines instead of actual lines when wrapped
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk
nmap <silent> j gj
nmap <silent> k gk

" move around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" pinky saving remap;
nnoremap ; :
