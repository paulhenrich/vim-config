" This must be first, because it changes other options as a side effect.
set nocompatible          " We're running Vim, not Vi!
filetype off              " Only temporarily while we load pathogen...

" Load Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Bundle "git://github.com/tpope/vim-fugitive.git"
Bundle "git://github.com/tpope/vim-git.git"
Bundle "kien/ctrlp.vim"
Bundle "scrooloose/nerdtree"
Bundle "git://github.com/tpope/vim-repeat.git"
Bundle "git://github.com/tpope/vim-surround.git"
Bundle "git://github.com/tpope/vim-vividchalk.git"
Bundle "git://github.com/vim-ruby/vim-ruby.git"
Bundle "git://github.com/tpope/vim-haml.git"
Bundle "https://github.com/kchmck/vim-coffee-script.git"
Bundle "https://github.com/tpope/vim-rails.git"
Bundle "git://github.com/altercation/vim-colors-solarized.git"
Bundle "https://github.com/jgdavey/vim-railscasts.git"
Bundle "https://github.com/mileszs/ack.vim"
Bundle "https://github.com/Lokaltog/vim-powerline"
Bundle "https://github.com/othree/html5.vim"
Bundle "https://github.com/tpope/vim-markdown.git"
Bundle "https://github.com/vim-scripts/mayansmoke"
Bundle "git://github.com/tpope/vim-endwise.git"
Bundle "https://github.com/kien/rainbow_parentheses.vim"
Bundle "git@github.com:elixir-lang/vim-elixir.git"

call vundle#end()            " required
filetype plugin indent on    " required

let mapleader = ","

" disallow vi commands from files
set modelines=0

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :split $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" jump to far right or left of line
map L $
map H ^

" borrowed from the Janus vimrc
" seemingly necessary for zoomwin
set noequalalways

" Ctrl-P config
let g:path_to_matcher = "/Users/paulhenrich/bin/matcher"

let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -co --exclude-standard']

let g:ctrlp_match_func = { 'match': 'GoodMatch' }

function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

  " Create a cache file if not yet exists
  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    call writefile(a:items, cachefile)
  endif
  if !filereadable(cachefile)
    return []
  endif

  " a:mmode is currently ignored. In the future, we should probably do
  " something about that. the matcher behaves like "full-line".
  let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '
  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
    let cmd = cmd.'--no-dotfiles '
  endif
  let cmd = cmd.a:str

  return split(system(cmd), "\n")

endfunction

map <c-t> :CtrlP<CR>
map <leader>t :CtrlP<CR>

" async rspec
map <leader>s :w\|:silent !echo "clear; rspec --color %" > test-commands<cr>
map <leader>r :w\|!rspec %<cr>


"" test runner from gbh
function! MapCR()
  nnoremap <cr> :call RunTestFile()<cr>
endfunction
call MapCR()
nnoremap <leader>T :call RunNearestTest()<cr>
"" nnoremap <leader>r :call RunTests('')<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Are we in a test file?
    let in_test_file = match(expand("%"), '\(_spec.rb\|_test.rb\|test_.*\.py\|_test.py\)$') != -1

    " Run the tests for the previously-marked file (or the current file if
    " it's a test).
    if in_test_file
        call SetTestFile(command_suffix)
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile(command_suffix)
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@% . a:command_suffix
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    " The file is executable; assume we should run
    if executable(a:filename)
      exec ":!./" . a:filename
    " Project-specific test script
    elseif filereadable("script/test")
        exec ":!script/test " . a:filename
    " Fall back to the .test-commands pipe if available, assuming someone
    " is reading the other side and running the commands
    elseif filewritable(".test-commands")
      let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter --out tmp/quickfix'
      exec ":!echo " . cmd . " " . a:filename . " > .test-commands"

      " Write an empty string to block until the command completes
      sleep 100m " milliseconds
      :!echo > .test-commands
      redraw!
    " Fall back to a blocking test run with Bundler
    elseif filereadable("bin/rspec")
      exec ":!bin/rspec --color " . a:filename
    elseif filereadable("Gemfile") && strlen(glob("spec/**/*.rb"))
      exec ":!bundle exec rspec --color " . a:filename
    elseif filereadable("Gemfile") && strlen(glob("test/**/*.rb"))
      exec ":!bin/rails test " . a:filename
    " If we see python-looking tests, assume they should be run with Nose
    elseif strlen(glob("test/**/*.py") . glob("tests/**/*.py"))
      exec "!nosetests " . a:filename
    end
endfunction


" ZoomWin configuration
map <Leader>z :ZoomWin<CR>

" bounce to test
map <leader>a :A<cr>
" Bits stolen from Gary Bernhardt
" bounce buffer
nnoremap <leader><leader> <c-^>

" RENAME CURRENT FILE
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Ack
map <Leader>g :!git grep<space>

" lazy escape
imap jj <Esc>

" keep more history
set history=100

" resize splits sensibly
set winwidth=100
set winminwidth=35

" show hidden buffers
set hidden

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
  set bg=dark
  colorscheme wombat256
  "colorscheme summerfruit256
  "assume we can use !open
  map <Leader>o :w\|:!open %<CR>
endif

map <Leader><Leader> :w\|:!./%<CR>
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

" catch trailing whitespace
set listchars=tab:>-,trail:·,eol:$
"nmap <silent> <leader>s :set nolist!<CR>

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

set scrolloff=3
set showmatch

set wildmenu

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
  autocmd FileType markdown set wrap

  augroup module
    autocmd BufRead *.module set filetype=php
  augroup END

  augroup inc
    autocmd BufRead *.inc set filetype=php
  augroup END


else
  set autoindent    " always set autoindenting on
endif " has("autocmd")

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

"Rainbow parens
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
