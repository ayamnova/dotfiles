filetype off                  " required
"put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on "automatically installs vim-plug if it is not installed
if empty(glob('~/.config/autoload/plug.vim'))
  silent !curl -fLo ~/.config/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" COLORS {{{

"Some really nice looking base16 themes
Plug 'chriskempson/base16-vim' 

"A solid dark theme (non base16)
Plug 'dracula/vim' 

"Shade indent levels
Plug 'nathanaelkane/vim-indent-guides'

" }}}

" SYSTEM {{{

"Light-weight status line
Plug 'vim-airline/vim-airline'

"Themes for airline
Plug 'vim-airline/vim-airline-themes'

"File explorer
Plug 'scrooloose/nerdtree' 

" TMUX {{{

"Enables easy pane / window naviagation between nvim and tmux
Plug 'christoomey/vim-tmux-navigator' 

"Makes tmux and vim share status lines
Plug 'edkolev/tmuxline.vim' 

" }}}

" EDITOR {{{

"Great defaults for complementary mappings
" [a previous file in args list
" ]a next file in args list
" [b previous buffer
" ]b next buffer
" [f previous file
" ]f next file 
Plug 'tpope/vim-unimpaired'

"Auto-close parens / quotes
Plug 'cohama/lexima.vim'

"Comment / uncomment things quickly
" {Visual}gc comment / uncomment selection
" - gc{motion} comment / uncomment lines for motion
Plug 'tpope/vim-commentary'


" Edit surrounding quotes / parents / etc
" - {Visual}S<arg> surrounds selection
" - cs/ds<arg1><arg2> change / delete
" - ys<obj><arg> surrounds text object
" - yss<arg> for entire line
"Plug 'tpope/vim-surround'


" Complete words from tmux with <C-x><C-u>
Plug 'wellle/tmux-complete.vim'

"}}}

" FILE / BUFFER HANDLING {{{

" Use FZF for fuzzy finding if available (see config below)
if executable('fzf')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
end

" Show register contents when using " or @ in normal mode
" Also shows when hitting <c-r> in insert mode
Plug 'junegunn/vim-peekaboo'

" Adds helpers for UNIX shell commands
" :Remove Delete buffer and file at same time
" :Unlink Delete file, keep buffer
" :Move Rename buffer and file
Plug 'tpope/vim-eunuch'

" }}}

" GENERAL CODING {{{

"Auto-complete pop-up menu, see config below
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

"Asynchronous linting engine
Plug 'w0rp/ale'

"Language Server Support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

"Snippets
Plug 'Shougo/neosnippet.vim'

"Default Snippets
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

" }}}

" GIT {{{

" Run Git commands from within Vim
" :Gstatus show `git status` in preview window
" - <C-N>/<C-P> next/prev file
" - - add/reset file under cursor
" - ca :Gcommit --amend
" - cc :Gcommit
" - D :Gdiff
" - p :Git add --patch (reset on staged files)
" - q close status
" - r reload status
" :Gcommit for committing
" :Gblame run blame on current file
" - <cr> open commit
" - o/O open commit in split/tab
" - - reblame commit
Plug 'tpope/vim-fugitive'


" Adds gutter signs and highlights based on git diff
" [c ]c to jump to prev/next change hunks
" <leader>hs to stage hunks within cursor
" <leader>hr to revert hunks within cursor
" <leader>hv to preview the hunk
Plug 'airblade/vim-gitgutter'

" }}}

" LANGUAGES {{{

" PYTHON {{{

"Python support for deoplete
Plug 'zchee/deoplete-jedi'

" }}}

" HTML {{{

" Fast HTML coding
" <C-Y> + n triggers completion
" ex: div'<C-Y>n'
" <div> </div>
Plug 'mattn/emmet-vim' 

" }}}

" Markdown {{{
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" }}}

" }}}

"Fuzzy file searching until I get fzf working
"Plug 'kien/ctrlp.vim'

" }}}

call plug#end()

"---------------------Environment Setup-------------------------------------

"Enables tab-completion in the commandline
set wildmenu


"---------------------Colorscheme Configuration------------------------------

"Make sure that neovim is aware of the terminal's color settings
set termguicolors

"Set the colorscheme
colorscheme dracula

"---------------------PLUGIN CONFIGURATION------------------------------------


" Pandoc {{{

" set filetypes to include .md
" let g:pandoc#filetypes#handled = ["pandoc", "markdown", "md"]

" }}}

" Deoplete {{{

" Autostart deoplete
let g:deoplete#enable_at_startup = 1

" Keybindings {{{  
" <C-j> Move down
" <C-k> Move up
" <ENTER> Accept completion
" <Tab> Move through snippet
" }}}

" Movement within 'ins-completion-menu'
imap <expr><C-j>   pumvisible() ? "\<Down>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<Up>" : "\<C-k>"

" Scroll pages in menu
inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
imap     <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
imap <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"  

" <CR>: If popup menu visible, expand snippet or close popup with selection,
"       Otherwise, check if within empty pair and use delimitMate.
"inoremap <silent><expr><CR> pumvisible() ? "\<CR>"
"	\ (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : deoplete#close_popup()) 
"	\ : deopolete#manual_complete() 
"	\ : (<SID>is_whitespace() ? "\<CR>")
"	(delimitMate#WithinEmptyPair() ? "\<C-R>=delimitMate#ExpandReturn()\<CR>" 


"inoremap <silent><expr><CR> pumvisible() ?
"	\ (neosnippet#expandable() ? neosnippet#mappings#expand_impl() : deoplete#close_popup())
"\ : (delimitMate#WithinEmptyPair() ? "\<C-R>=delimitMate#ExpandReturn()\<CR>" : "\<CR>")


" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if within a snippet, jump to next input
" 3. Otherwise, if preceding chars are whitespace, insert tab char
" 4. Otherwise, start manual autocomplete
imap <silent><expr><Tab> pumvisible() ? "\<Down>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#manual_complete()))

smap <silent><expr><Tab> pumvisible() ? "\<Down>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#manual_complete()))

inoremap <expr><S-Tab>  pumvisible() ? "\<Up>" : "\<C-h>"

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~? '\s'
endfunction "}}}

" }}}

" LanguageClient {{{

"----> Language Server Configuration
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'python': ['pyls'],
    \ }

" <leader>ld to go to definition
autocmd FileType python nnoremap <buffer>
  \ <leader>ld :call LanguageClient_textDocument_definition()<cr>
" <leader>lh for type info under cursor
autocmd FileType python nnoremap <buffer>
  \ <leader>lh :call LanguageClient_textDocument_hover()<cr>
" <leader>lr to rename variable under cursor
autocmd FileType python nnoremap <buffer>
  \ <leader>lr :call LanguageClient_textDocument_rename()<cr>


"Automatically start language servers
let g:LanguageClient_autoStart = 1

" }}}

" FZF {{{
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>

" }}}

"NERDTREE {{{
map <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeAutoDeleteBuffer=1
"}}}

"Airline {{{

"use special font symbols
let g:airline_powerline_fonts = 1

"}}}

" LEADER COMMANDS {{{ 

" change leader to comma
let mapleader=','

" unmap spacebar
nnoremap <Space> <Nop>
" change local leader to spacebar
let maplocalleader="\<Space>"

" edit zsh config with ,ez
nnoremap <leader>ez :vsp ~/.zshrc<CR>

" edit init.vim config with ,ev
nnoremap <leader>ev :vsp $MYVIMRC<CR>

" source init.vim with ,sv
nnoremap <leader>sv :source $MYVIMRC<CR>

" }}}
" activates syntax highlighting among other things
syntax on
set t_Co=256

"make line numbering relative
set relativenumber

"display command in bottom right corner
set showcmd

set path+=**


"Silver Searcher {{{
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

"}}}

"KEY BINDINGS {{{

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ to Ag command
nnoremap ,K :Ag<SPACE>

"}}}

" ------------------- COMMANDS --------------------------
" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

"command to make tags file for a given root directory
command MakeTags !ctags -R .

