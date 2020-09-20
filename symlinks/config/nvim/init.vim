filetype off                  " required
"put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

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

"Tags
Plug 'ludovicchabant/vim-gutentags'

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

" Language Server
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Asynchronous linting engine
Plug 'w0rp/ale'

"CSharp
Plug 'OmniSharp/omnisharp-vim'

"Snippets
Plug 'Shougo/neosnippet.vim'
Plug 'grvcoelho/vim-javascript-snippets'

"Vue Components
Plug 'posva/vim-vue'

"Context-sensitive snippets
Plug 'Shougo/context_filetype.vim'

"Default Snippets
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

" HTML {{{

" Fast HTML coding
" <C-Y> + n triggers completion
" ex: div'<C-Y>n'
" <div> </div>
Plug 'mattn/emmet-vim' 

" }}}

" Blade Syntax Highlighting {{{
Plug 'jwalton512/vim-blade'
"}}}

" Markdown {{{
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" }}}

" }}}

" }}}

call plug#end()

"}}}

"---------------------Environment Setup-------------------------------------
"Correct tab configuration
set shiftwidth=4
set tabstop=4

"Enables tab-completion in the commandline
set wildmenu

"Disable Python2 Support
let g:loaded_python_provider = 1

"---------------------Colorscheme Configuration------------------------------

"Make sure that neovim is aware of the terminal's color settings
set termguicolors

"Make the background transparent
let g:dracula_colorterm = 0

"Set the colorscheme
colorscheme dracula


"---------------------PLUGIN CONFIGURATION------------------------------------

" Coc {{{
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

" Gutentags {{{
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
" Store tag files in a central location
let g:gutentags_cache_dir = expand('~/.cache/ctags/')
" Clear the tag cache with GutentagsClearCache
command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

"}}}

" NeoSnippets {{{
let g:neosnippet#snippets_directory = '~/.config/nvim/snippets/'
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets/'

" When I push <C-l> and I have a snippet completely typed before the cursor,
" expand the snippet and move through the snippet with <C-l>
imap <expr><C-l> neosnippet#expandable_or_jumpable()
        \ ? "\<Plug>(neosnippet_expand_or_jump)"
        \ : "\<C-n>"
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
"
" Clojure {{{

Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-salve'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
"
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

"correct tab settings
set tabstop=4
set shiftwidth=4

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
"inoremap <BS> <nop>

"}}}

" ------------------- COMMANDS --------------------------
" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

"command to make tags file for a given root directory
command MakeTagsPHP !ctags -R --exclude@.ctagsignore . --fields=+aimlS --languages=php --output-format=e-ctags
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

"vim:tw=78:ts=8:fdm=marker
