set nocompatible              " be iMproved, required
colorscheme default

let $VIMHOME = $HOME."/.vim/"

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()"

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'gmarik/sudo-gui.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'nanotech/jellybeans.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'nathanaelkane/vim-indent-guides'

" Your stuff is going go here...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


set expandtab     " Soft tabs all the things
set tabstop=2     " 2 spaces is used almost everywhere now
set shiftwidth=2  " When using >> then use 2 spaces
set autoindent    " Well, obviously
set smartindent   " As opposed to dumb indent

set noautowrite
set number
set autoread      " Read changes from underlying file if it changes
set showmode      " Showing current mode is helpful++
set showcmd
set nocompatible  " Actually make this vim
set ttyfast       " We don't use 33.6 modems these days
set ruler

set incsearch     " Use incremental search like OMG yes
set ignorecase    " Ignore case when searching
set hlsearch      " Highlight searching
set showmatch     " Show me where things match
set diffopt=filler,iwhite "Nice diff options
set showbreak=↪   " Cooler linebreak
set noswapfile    " It's 2014, GO AWAY FFS

set esckeys       " Allow escape key in insert mode
"set cursorline    " Highlight the line we're on
set encoding=utf8 " Really, people still use ASCII

syntax enable
set background=dark
"colorscheme jellybeans
"set ofu=syntaxcomplete#Complete

" Better Completion
set completeopt=longest,menuone,preview

"Enable new file templating system
autocmd BufNewFile * :silent! exec ":0r ".$VIMHOME."templates/".&ft

"Allow :Build :Upload for .ino files
autocmd BufReadPre,FileReadPre *.ino command Build !arduino --verify %
autocmd BufReadPre,FileReadPre *.ino command Upload !arduino --upload % 
autocmd BufReadPre,FileReadPre *.ino nmap <leader>B :Build<CR>
autocmd BufReadPre,FileReadPre *.ino nmap <leader>b :Build<CR>
autocmd BufReadPre,FileReadPre *.ino nmap <leader>U :Upload<CR>
autocmd BufReadPre,FileReadPre *.ino nmap <leader>u :Upload<CR>

"Configure plugins

" ---------------
" Vundle
" ---------------
nmap <Leader>bi :BundleInstall<CR>
nmap <Leader>bu :BundleInstall!<CR> " Because this also updates
nmap <Leader>bc :BundleClean<CR>
