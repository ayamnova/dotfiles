"filetype off                  " required
"put this line first in ~/.vimrc
"set nocompatible | filetype indent plugin on | syn on

" Python Virtual Environments
let g:python_host_prog = glob("~/.pyenv/versions/neovim2/bin/python")
let g:python3_host_prog = glob("~/.pyenv/versions/neovim3/bin/python")

" Plugins {{{

" Install Vim-Plug automatically if it is not installed
if empty(glob('~/.config/autoload/plug.vim'))
  silent !curl -fLo ~/.config/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" Editor Themes {{{

"A solid dark theme (non base16)
Plug 'dracula/vim' 

"Light-weight status line
Plug 'vim-airline/vim-airline'

"Themes for airline
Plug 'vim-airline/vim-airline-themes'
"
"Shade indent levels
Plug 'nathanaelkane/vim-indent-guides'

" TMUX Integration {{{

"Enables easy pane / window naviagation between nvim and tmux
" <CTRL-h> Move to the left
" <CTRL-j> Move to up
" <CTRL-k> Move to down
" <CTRL-l> Move to right
Plug 'christoomey/vim-tmux-navigator' 

" Complete words from tmux with <C-x><C-u>
Plug 'wellle/tmux-complete.vim'

"Makes tmux and vim share status lines
Plug 'edkolev/tmuxline.vim' 

" }}}

" EDITOR {{{

"File explorer
Plug 'scrooloose/nerdtree'

"Great defaults for complementary mappings
" [a previous file in args list
" ]a next file in args list
" [b previous buffer
" ]b next buffer
" [f previous file
" ]f next file 
Plug 'tpope/vim-unimpaired'

"Comment / uncomment things quickly
" {Visual}gc comment / uncomment selection
" - gc{motion} comment / uncomment lines for motion
Plug 'tpope/vim-commentary'

" Edit surrounding quotes / parents / etc
" - {Visual}S<arg> surrounds selection
" - cs/ds<arg1><arg2> change / delete
" - ys<obj><arg> surrounds text object
" - yss<arg> for entire line
Plug 'tpope/vim-surround'
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

"CSharp
Plug 'OmniSharp/omnisharp-vim'

"Snippets
Plug 'Shougo/neosnippet.vim'

"Context-sensitive snippets
Plug 'Shougo/context_filetype.vim'

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

" }}}

call plug#end()

"}}}

"---------------------Environment Setup-------------------------------------

"Enables tab-completion in the commandline
set wildmenu

"Disable Python2 Support
let g:loaded_python_provider = 1

"---------------------Colorscheme Configuration------------------------------

"Make sure that neovim is aware of the terminal's color settings
set termguicolors

"Set the colorscheme
colorscheme dracula


"---------------------PLUGIN CONFIGURATION------------------------------------

" NeoSnippets {{{
let g:neosnippet#snippets_directory = '~/.config/nvim/snippets/'

" When I push <C-l> and I have a snippet completely typed before the cursor,
" expand the snippet and move through the snippet with <C-l>
imap <expr><C-l> neosnippet#expandable_or_jumpable()
        \ ? "\<Plug>(neosnippet_expand_or_jump)"
        \ : "\<C-n>"
" }}}

" Deoplete {{{

" Autostart deoplete
let g:deoplete#enable_at_startup = 1

" After completing a candidate, close the preview window
autocmd CompleteDone * silent! pclose!

" When I delete a character with <C-h>, resource all the candidates
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"

" TAB
inoremap <TAB> <TAB>

" When the popup window is open and I push <CR>, close the popup window save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
        return deoplete#close_popup() . "\<CR>"
endfunction

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

" Linting Configuration {{{

let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}

" }}}

" FZF {{{
" An action can be a reference to a function that processes selected lines
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction

    let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }


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

" TERMINAL {{{
tnoremap <Esc> <C-\><C-n>
" }}}

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

" FZF searching {{{

" Files
"<leader>f to search through Git-tracked files
nnoremap <leader>f :GFiles<CR> 
"<leader>F to search through all files
nnoremap <leader>F :Files<CR>  

" Buffers
"<leader>b to search through open buffers
nnoremap <leader>b :Buffers<CR> 
"<leader>h to search through buffer history
nnoremap <leader>h :History<CR> 

" Tags
"<leader>t to search through tags in open buffer
nnoremap <leader>t :BTags<CR> 
"<leader>T to search through tags across projects (good with gutentags)
nnoremap <leader>T :Tags<CR> 

" Lines
"<leader>l to serach through lines in current buffer
nnoremap <leader>l :BLines<CR> 
"<leader>L to search through lines in loaded buffers
nnoremap <leader>L :Lines<CR> 
"<leader>' to search through marked lines
nnoremap <leader>' :Marks<CR> 
"<leader>a to search through project
nnoremap <leader>a :Ag<Space> 
"<leader>H to search through help tags
nnoremap <leader>H :Helptags!<CR> 
"<leader>C to search through commands
nnoremap <leader>C :Commands<CR> 
"<leader>: to search through history
nnoremap <leader>: :History:<CR> 
"<leader>/ to search through search history
nnoremap <leader>/ :History/<CR> 
" }}} 
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

" ARROW KEYS {{{
" Make the arrow kes resize the pane
nnoremap <Left> :vertical resize -1<CR>
nnoremap <Right> :vertical resize +1<CR>
nnoremap <Up> :resize -1<CR>
nnoremap <Down> :resize +1<CR>

" Make the Alt+{h,j,k,l} resize the pane
nnoremap <A-l> :vertical resize -1<CR>
nnoremap <A-h> :vertical resize +1<CR>
nnoremap <A-j> :resize -1<CR>
nnoremap <A-k> :resize +1<CR>
" }}}

" Turnoff backspace
inoremap <BS> <nop>

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

"Change Tab Directory Automatically To Opened File
function! OnTabEnter(path)
  if isdirectory(a:path)
    let dirname = a:path
  else
    let dirname = fnamemodify(a:path, ":h")
  endif
  execute "tcd ". dirname
endfunction()

autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))

"vim:tw=78:ts=8:fdm=marker:
