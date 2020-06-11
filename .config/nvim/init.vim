" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible
 
" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on
 
" Enable syntax highlighting
syntax on

" 'hidden' allows you to re-use the same window and switch from an unsaved 
" buffer without saving it first. Also allows you to keep an undo history for 
" multiple files when re-using the same window in this way. Note that using 
" persistent undo also lets you undo in multiple files even in the same window, 
" but is less efficient and is actually designed for keeping undo history after 
" closing Vim entirely. Vim will complain if you try to quit without saving, and
" swap files will keep you safe if your computer crashes.
set hidden
 
" Better command-line completion
set wildmenu
 
" Show partial commands in the last line of the screen
set showcmd
 
" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
 
" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline
 
 
"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.
 
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
 
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
 
" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent
 
" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline
 
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler
 
" Always display the status line, even if only one window is displayed
set laststatus=2
 
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
 
" Use visual bell instead of beeping when doing something wrong
set visualbell
 
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=
 
" Enable use of the mouse for all modes
set mouse=r
 
" Display line numbers on the left
set number

" Use 4 spaces instead of tabs
set shiftwidth=4
set softtabstop=4
set expandtab

" No visual mode when selecting with cursor
set mouse=r

" Set python providers
let g:python3_host_prog = '/usr/bin/python3'
let g:python2_host_prog = '/usr/bin/python2'

" Use clipboard as default register
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

" Highligh current line
colorscheme onedark

set cursorline
set cc=81

" File specific commands
    " R markdown
    autocmd Filetype rmd map <F6> :!echo<space>"require(rmarkdown);<space>render('<c-r>%')"<space>\|<space>R<space>--vanilla<enter>
    autocmd Filetype rmd vmap <C-b> :s/\%V.*\%V./**&**/<enter>
    autocmd Filetype rmd vmap <C-i> :s/\%V.*\%V./_&_/<enter>
    
    " pdflatex
    autocmd Filetype tex map <F6> :!dtexlive<space>pdflatex<space>'<c-r>%'<enter>
    autocmd Filetype tex map <F7> :!pdflatex<space>'<c-r>%'<enter>
    autocmd Filetype tex vmap <C-b> :s/\%V.*\%V./\\textbf{&}/<enter>
    autocmd Filetype tex vmap <C-i> :s/\%V.*\%V./\\textit{&}/<enter>

    " Shell scripts
    autocmd Filetype sh map <F6> :!sh<space>'<c-r>%'<enter>
    autocmd Filetype sh map <F7> :!sh<space>-n<space>'<c-r>%'<enter>
    autocmd Filetype sh map <F8> :!chmod<space>+x<space>'<c-r>%'<enter>:e<enter> 


