" my vimrc file -- https://github.com/pyllyukko/dotfiles

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file, use versions instead
set noundofile		" do not keep an undo file
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" disable bracketed paste
" https://vimhelp.org/term.txt.html#xterm-bracketed-paste
set t_BE=

" Don't use Ex mode, use Q for formatting
map Q gq
" F11 for fullscreen https://askubuntu.com/a/338569
map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set background=dark
  set hlsearch
  " C-L from http://vim.wikia.com/wiki/Example_vimrc
  " Map <C-L> (redraw screen) to also turn off search highlighting until the
  " next search
  nnoremap <C-L> :nohl<CR><C-L>
  colorscheme torte
endif

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" for added security. don't use temp files, use pipes instead.
set noshelltemp
set secure
" disable swap files
set noswapfile

" this shouldn't matter with nocompatible, but we'll set it anyway
" http://vim.wikia.com/wiki/Modeline_magic
" http://usevim.com/2012/03/28/modelines/
set nomodeline

" http://vim.wikia.com/wiki/Encryption
" viminfo can be a treasure trove of sensitive information
set viminfo=

" relative line numbers. so much easier to jump between lines
set relativenumber
" show actual line number in position 0
" http://vim.wikia.com/wiki/Display_line_numbers#Relative_line_numbers
set number

" Maintain more context around the cursor
set scrolloff=3

" use blowfish
set cryptmethod=blowfish

" spell checking stuff
" set spell
set spelllang=en

" indent with two spaces
set shiftwidth=2
set tabstop=8		" standard tab width
set noexpandtab		" tab is a tab

set visualbell

" from https://github.com/derekwyatt/vim-config
" Automatically read a file that has changed on disk
set autoread

set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=m  "remove menu bar

" http://vim.wikia.com/wiki/Dictionary_completions
set dictionary=/usr/share/dict/words
set complete+=k

" http://vim.wikia.com/wiki/Folding#Syntax_folding
set foldmethod=syntax
" http://vimdoc.sourceforge.net/htmldoc/options.html#%27foldnestmax%27
set foldnestmax=5
" sh.vim
let g:sh_fold_enabled=3	" (enables function and heredoc folding)
let g:xml_syntax_folding=1

" https://stackoverflow.com/questions/5017500/vim-difficulty-setting-up-ctags-source-in-subdirectories-dont-see-tags-file-i
set tags=./tags;~

" http://vimdoc.sourceforge.net/htmldoc/options.html#%27wildmenu%27
set wildmode=list:full
set wildmenu

" http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
set showtabline=1
" set up tab labels with tab number, buffer name, number of windows
function! GuiTabLabel()
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '+'
      break
    endif
  endfor
  " Append the tab number
  let label .= v:lnum.': '
  " Append the buffer name
  let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  if name == ''
    " give a name to no-name documents
    if &buftype=='quickfix'
      let name = '[Quickfix List]'
    else
      let name = '[No Name]'
    endif
  else
    " get only the file name
    let name = fnamemodify(name,":t")
  endif
  let label .= name
  return label
endfunction
set guitablabel=%{GuiTabLabel()}

" from http://vim.wikia.com/wiki/Showing_syntax_highlight_group_in_statusline
" more statuslines:
"   http://www.linux.com/archive/feature/120126
set laststatus=2        " always show status line
function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction
if has('statusline')
  set statusline=%#Question#                   " set highlighting
  set statusline+=%-2.2n\                      " buffer number
  set statusline+=%#WarningMsg#                " set highlighting
  set statusline+=%f\                          " file name
  set statusline+=%#Question#                  " set highlighting
  set statusline+=%h%m%r%w\                    " flags
  set statusline+=%{strlen(&ft)?&ft:'none'},   " file type
  set statusline+=%{(&fenc==\"\"?&enc:&fenc)}, " encoding
  set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
  set statusline+=%{&fileformat},              " file format
  set statusline+=%{&spelllang},               " language of spelling checker
  set statusline+=%{SyntaxItem()}              " syntax highlight group under cursor
  set statusline+=%=                           " ident to the right
  set statusline+=0x%-8B\                      " character code under cursor
  set statusline+=%-7.(%l,%c%V%)\ %<%P         " cursor position/offset
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  " Remove ALL autocommands for the current group.
  au!

  " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
  autocmd FileType text setlocal wrap linebreak nolist textwidth=0 wrapmargin=0

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  " use colorcolumn, when writing mails
  au Filetype mail set cc=+1

  " .md is markdown and not modula2
  au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

  " from http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  "   1. highlight trailing whitespace in red
  "   2. have this highlighting not appear whilst you are typing in insert mode
  "   3. have the highlighting of whitespace apply when you open new buffers
  highlight ExtraWhitespace ctermbg=red guibg=red
  " Show trailing whitespace and spaces before a tab:
  match ExtraWhitespace /\s\+$\| \+\ze\t\| \+/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t\| \+/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t\| \+/
  autocmd BufWinLeave * call clearmatches()
  " activate with 'set list'
  set listchars=eol:$,tab:>-

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Make vim work with the 'crontab -e' command
set backupskip+=/var/spool/cron/*

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" http://vim.wikia.com/wiki/VimTip1005#Simple_search_and_replace
" Escape/unescape & < > HTML entities in range (default current line).
function! HtmlEntities(line1, line2, action)
  let search = @/
  let range = 'silent ' . a:line1 . ',' . a:line2
  if a:action == 0  " must convert &amp; last
    execute range . 'sno/&lt;/</eg'
    execute range . 'sno/&gt;/>/eg'
    execute range . 'sno/&amp;/&/eg'
  else              " must convert & first
    execute range . 'sno/&/&amp;/eg'
    execute range . 'sno/</&lt;/eg'
    execute range . 'sno/>/&gt;/eg'
  endif
  nohl
  let @/ = search
endfunction
command! -range -nargs=1 Entities call HtmlEntities(<line1>, <line2>, <args>)
noremap <silent> \h :Entities 0<CR>
noremap <silent> \H :Entities 1<CR>

" load pathogen (https://github.com/tpope/vim-pathogen), if it's available
if filereadable(expand("~/.vim/autoload/pathogen.vim"))
  execute pathogen#infect()
endif

" if filereadable("/usr/share/clang/clang-format.py")
"   map <C-I> :pyf /usr/share/clang/clang-format.py<cr>
"   imap <C-I> <c-o>:pyf /usr/share/clang/clang-format.py<cr>
" endif

" https://gist.github.com/tpope/287147
" https://github.com/godlygeek/tabular
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
