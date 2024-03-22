"
"
"###        _
"### __   _(_)_ __ ___  _ __ ___
"### \ \ / / | '_ ` _ \| '__/ __|
"###  \ V /| | | | | | | | | (__
"### (_)_/ |_|_| |_| |_|_|  \___|
"###
"###
"### # # # # # #
"###      #
"### # # # # # #
"###

": '
"init.vim
"vim runcom configuration
"copyright (c) 2017 - 2022  |  oxo

"GNU GPLv3 GENERAL PUBLIC LICENSE
"This program is free software: you can redistribute it and/or modify
"it under the terms of the GNU General Public License as published by
"the Free Software Foundation, either version 3 of the License, or
"(at your option) any later version.

"This program is distributed in the hope that it will be useful,
"but WITHOUT ANY WARRANTY; without even the implied warranty of
"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"GNU General Public License for more details.

"You should have received a copy of the GNU General Public License
"along with this program.  If not, see <https://www.gnu.org/licenses/>.
"https://www.gnu.org/licenses/gpl-3.0.txt

"@oxo@qoto.org


"# dependencies
"  n/a

"# usage
"  n/a

"# examples
"  n/a

"# '


"# loose beginnings
"{{{

if v:progname == 'vi'
  set noloadplugins
endif

set autoindent
set backspace=indent,eol,start
set clipboard+=unnamedplus	" # use system clipboard
set complete-=
set cpo-=aA			" # :read and :write shouldn't set #
set diffopt+=vertical		" # default orientation for :diffsplit
set encoding=utf-8
set foldmethod=marker
set nomodeline			" # prevent vim modeline vulnerabilities
set noshowmode
set nrformats-=octa1
set ruler
set shortmess+=filmnrwxstTI
set showcmd
set timeoutlen=1000 ttimeoutlen=0
set updatecount=10		" # rotate swapfiles default: 200
set undolevels=5000
set undofile			" # persistent undo on
set wildmenu
filetype plugin indent on
syntax enable

let mapleader="`"		" # check interference (tmux)

"#[DEV] make C-, work
"#let &t_TI = "\<Esc>[>4;2m"
"#let &t_TE = "\<Esc>[>4;m"
"#\e[27;5;9~  control-TAB
"#\e[27;5;44~ control-,
"#\e[27;5;46~ control-.
"#\e[27;5;47~ control-/
"#\e[27;5;92~ control-\

"## goto last location in non-empty files
autocmd BufReadPost *	if line("'\"") > 1 && line("'\"") <= line("$")
			\|				exe "normal! g`\""
			\|			endif

"# improve searching
set incsearch       " look cahead if search pattern is specified
set ignorecase      " ignore case in all searches...
set smartcase       " ...unless uppercase letters are used

set hlsearch        " highlight all matches
highlight clear Search
highlight       Search    ctermfg=White  ctermbg=Black  cterm=bold
highlight    IncSearch    ctermfg=White  ctermbg=Red    cterm=bold

" absolute direction for n and N...
nnoremap  <silent><expr> n  'Nn'[v:searchforward] . ":call HLNext()\<CR>"
nnoremap  <silent><expr> N  'nN'[v:searchforward] . ":call HLNext()\<CR>"

"# delete in normal mode to switch off highlighting till next search and clear messages...
nmap <silent> <BS> [Cancel highlighting]  :call HLNextOff() <BAR> :nohlsearch <BAR> :call VG_Show_CursorColumn('off')<CR>::HierClear<CR>

"double-delete to remove trailing whitespace...
nmap <silent> <BS><BS>  [Remove trailing whitespace] mz:call TrimTrailingWS()<CR>`z

function! TrimTrailingWS ()
    if search('\s\+$', 'cnw')
        :%s/\s\+$//g
    endif
endfunction

"# unicode defaults
setglobal termencoding=utf-8 fileencodings=
scriptencoding utf-8
set encoding=utf-8

autocmd BufNewFile,BufRead * try
autocmd BufNewFile,BufRead * set encoding=utf-8
autocmd BufNewFile,BufRead * endtry

"# clean $HOME
set viminfo+=n$XDG_CONFIG_HOME/nvim/viminfo
"#set runtimepath+=$XDG_CONFIG_HOME/nvim,$XDG_CONFIG_HOME/nvim/after
"# }}}


"# tab_ops
"{{{

set tabstop=8
set noexpandtab
set shiftwidth=4
set softtabstop=4
set smarttab

"# }}}


"# plugins
"{{{

call plug#begin('$XDG_CONFIG_HOME/nvim/plugins')

Plug 'chriskempson/base16-vim'
Plug 'machakann/vim-sandwich'
"#Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'gcmt/taboo.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'raimondi/delimitmate'
"#Plug 'Raimondi/delimitMate'
"#Plug 'jiangmiao/auto-pairs'
Plug 'dhruvasagar/vim-dotoo'
Plug 'gioele/vim-autoswap'
"#https://aur.archlinux.org/packages/vim-autoswap-git/
"#Plug 'thoughtstream/Damian-Conway-s-Vim-Setup/plugin/blockwise.vim'
"https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup

call plug#end()

"# non active plugins
"Plug 'christoomey/vim-tmux-navigator'
"Plug 'vimwiki/vimwiki'
"Plug 'ron89/thesaurus_query.vim'
"Plug 'terryma/vim-multiple-cursors'
"Plug 'jceb/vim-orgmode'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

source $HOME/.config/nvim/sources/damian_conway/plugin/hlnext.vim
source $HOME/.config/nvim/sources/damian_conway/plugin/visualsmartia.vim
"# }}}


"# find files
"{{{za

"## search into subfolders
"## provide tab-completion
set path+=**

"# }}}


"# swap file
"{{{
    "# location
    set directory^=$XDG_DATA_HOME/nvim/swap//

    "# DiffOrig
    "# see nvim :h DiffOrig
    command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_
	\ | diffthis | wincmd p | diffthis
"}}}


"# tag jumping
"{{{

"command! MakeTags !ctags -R .
"## ^] to jump to tag under cursor
"## g^] for ambiguous tags
"## ^t to jump back up the tag stack

"# }}}


"# statusline
"{{{

"## set airline theme
"#let g:airline_theme='minimalist'

"## manual statusline configuration

"# show the statusline
set laststatus=2

" statusline colors
"function! InsertStatuslineColor(mode)
"  if a:mode == 'i'
"    highlight sl_01 ctermbg=green
"  elseif a:mode == 'r'
"    highlight sl_01 ctermbg=blue
"  else
"    highlight sk_01 ctermbg=black
"  endif
"endfunction
"
"au InsertEnter * call InsertStatuslineColor(v:insertmode)
"au InsertChange * call InsertStatuslineColor(v:insertmode)
"au InsertLeave * highlight sl_01 ctermbg=black

" default the statusline to green when entering Vim
highlight sl_01 ctermbg=black
highlight sl_file ctermbg=black ctermfg=green
highlight sl_af ctermbg=black ctermfg=yellow

set statusline=			" clear statusline

"# lhs
set statusline+=%#sl_01#	" set color of block 01
set statusline+=\ \ \ 		" block 01
"set statusline+=\ \ \ \ 	" block 01
set statusline+=%*		" reset highlight group
set statusline+=%#sl_file#	" set color of file block
"set statusline+=%t		" filename
set statusline+=\ 		" spacer
set statusline+=%.60F		" file path
set statusline+=%r		" readonly flag
set statusline+=%m		" modified flag
set statusline+=\ 		" spacer
set statusline+=%*		" reset highlight group

"# rhs

set statusline+=%#sl_af#	" set color of after file block
set statusline+=%=		" switch to rhs
set statusline+=\ 		" spacer
set statusline+=(%v\-\%l)	" column;line [xy-coordinates]
set statusline+=. 		" dot [leading percentage]
set statusline+=%2p		" percentage of file height
set statusline+=\ 		" spacer
set statusline+=%#sl_01#	" set color of block 01
set statusline+=\ \ 		" spacer

"# }}}


"# cursor, lines & line numbers
"{{{

"## line number configuration
"### toggle line numbers absolute / relative / none
nnoremap <Leader>n :set number! relativenumber!<CR>

"### default lines
set number relativenumber
highlight LineNr cterm=NONE ctermfg=darkgrey ctermbg=NONE
highlight CursorLineNr cterm=NONE ctermfg=yellow ctermbg=NONE

"## numbers rel cmd & abs ins
"### enter insert mode; abs numbers
"### leaving insert mode; rel numbers
augroup numbertoggle
  highlight CursorLine cterm=NONE
  set cursorline
  autocmd InsertEnter * highlight CursorLineNr ctermfg=green ctermbg=NONE
  autocmd InsertLeave * highlight CursorLineNr ctermfg=yellow ctermbg=NONE
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
augroup end

"## 80 character column and >120 greyed out area
"highlight ColorColumn ctermbg=233
"let &colorcolumn="80,".join(range(120,999),",")

"## highlight column 81, on too large columns
highlight ColorColumn ctermbg=darkgrey ctermfg=grey
call matchadd('ColorColumn', '\%81v.', 100)

"## cursor definition
set guicursor=n-v-c-sm:block
			\,i-ci-ve:ver20
			\,r-cr-o:hor20
			\,a:blinkwait1000-blinkon800-blinkoff200

"# }}}


"# panes & tabs
"{{{

"# tab like a workspace
"# pane like a window
"# a tab can contain one or more panes

"# focus	A
"# move		A-S
"# resize	A-C

"## create pane
"## A-- or A-\
"### new pane below
set splitbelow
map <silent> <A--> :split<CR>
"### new pane right
set splitright
map <silent> <A-\> :vsplit<CR>

"## delete pane
"### delete current pane
"### A-d
map <silent> <A-d> :q<CR>
"### delete all other panes
"### A-delete
map <silent> <A-Del> :only<CR>

"## move pane focus
"## A-hjkl
"### focus left
map <silent> <A-h> <C-w>h
"### focus down
map <silent> <A-j> <C-w>j
"### focus up
map <silent> <A-k> <C-w>k
"### focus right
map <silent> <A-l> <C-w>l

"## move pane
"## A-S-hjkl
"### pane left
map <silent> <A-S-h> <C-w>H
"### pane down
map <silent> <A-S-j> <C-w>J
"### pane up
map <silent> <A-S-k> <C-w>K
"### pane right
map <silent> <A-S-l> <C-w>L

"## [TODO] close pane

"## resize focused pane
"## -> bottom right corner moves
"
"### small adjustments
"### A-C-nm,.
"### resize left
map <silent> <A-C-n> <c-w><
"### resize down
map <silent> <A-C-m> <c-w>+
"###[TODO] . and , NOT WORKING!!
"### resize up
imap <A-C-,> <c-w>-
"#map <silent> <A-C-,> <c-w>-
"### resize right
imap <A-C-.> <c-w>>
"#map <silent> <A-C-.> <c-w>>

"### normal adjustments
"### A-C-hjkl
"### resize left
map <silent> <A-C-h> 5<c-w><
"### resize down
map <silent> <A-C-j> 5<c-w>+
"### resize up
map <silent> <A-C-k> 5<c-w>-
"### resize right
map <silent> <A-C-l> 5<c-w>>

"### large adjustments
"### A-C-yuio
"### resize left
map <silent> <A-C-y> 10<c-w><
"### resize down
map <silent> <A-C-u> 10<c-w>+
"### resize up
map <silent> <A-C-i> 10<c-w>-
"### resize right
map <silent> <A-C-o> 10<c-w>>

"### maximize current pane (into new tab)
"### A-f
map <silent> <A-f> :tab sbp<CR>
"#map <silent> <A-f> :tab sp<CR>

"### reset all pane sizes
"### A-0
map <silent> <A-0> <c-w>=

"### mouse drag resizes
set mouse=a

"## tab line
"### tab names
let g:taboo_tab_format=" %N "
"### tab colors
hi TabLineFill cterm=underline ctermfg=232 ctermbg=232
hi TabLineSel ctermfg=White ctermbg=24
hi TabLine cterm=NONE ctermfg=Grey ctermbg=236

"## create tab
" :tabedit

"## close tab
" :q

"## goto
"### next tab
map <silent> <A-]> :tabn<CR>
"### previous tab
map <silent> <A-[> :tabp<CR>

"## tab position
"### shift left
map <silent> <A-S-[> :tabm -i<CR>
"### shift right
map <silent> <A-S-]> :tabm +i<CR>

"
"## [TODO] move pane to other tab
"

"# }}}


"# remove trailing whitespace on save
"{{{

autocmd BufWritePre * %s/\s\+$//e

"[TODO] removing empty newlines at EOF if more than one

"# }}}


"# look and feel
"{{{

"## background transparent
hi Normal ctermbg=NONE

"## distraction free writing
nnoremap <Leader><Tab> :Goyo<CR>
autocmd! User GoyoLeave source $MYVIMRC

"## vimdiff
if &diff
	hi DiffAdd						ctermbg=24
	hi DiffChange   ctermfg=181	    ctermbg=239
	hi DiffDelete   ctermfg=162		ctermbg=53
	hi DiffText					    ctermbg=102
	"hi DiffText					ctermbg=102		cterm=bold
endif

hi MatchParen	cterm=none ctermbg=none ctermfg=green

"# }}}


"# keybindings
"{{{

nnoremap ; :
nnoremap <BS> X

"# }}}


"# spell check
"{{{

"# custom dictionary
":mkspell	~/.config/vim/spell/custom_dict		custom_dict.txt

"# }}}
