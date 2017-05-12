" vim: set foldmethod=marker foldlevel=0:       " zr(open), zm(close)

let os=substitute(system('uname'), '\n', '', '')

" PlugIn {{{
silent! if plug#begin('~/.vim/plugged')

if os == 'Darwin' || os == 'Mac'
  let g:plug_url_format = 'git@github.com:%s.git'
else
  let $GIT_SSL_NO_VERIFY = 'true'
endif
unlet! g:plug_url_format

" Colors
Plug 'tomasr/molokai'
Plug 'junegunn/seoul256.vim'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'itchyny/lightline.vim'

" Edit
Plug 'benmills/vimux' " vim과 tmux 연동하기 위한 플러그인
Plug 'junegunn/goyo.vim' "Goyo :Goyo! (on/off) 고요함
Plug 'junegunn/limelight.vim' "with Goyo
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim' "스페이스바 2번 누르면 실행되고 아직 이해 못함
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] } " 정렬 vip로 블록잡고 설정한 ga로 실행
Plug 'junegunn/vim-after-object'
Plug 'tpope/vim-repeat'  "아래 명령들 반복해서 쓸 수 있게 해줌
Plug 'tpope/vim-surround' "ysiw 시작과 끝을 감싸줌 cs는 change, ds는 delete
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' } 
Plug 'tpope/vim-endwise' "스크립트 언어들의 마지막 end 같은 것들 알아서 들여쓰기
Plug 'mbbill/undotree',  { 'on': 'UndotreeToggle'   } " U로 매핑해뒀는데 이전 이력으로 돌아갈 수 있어서 매우 좋음
Plug 'AndrewRadev/splitjoin.vim' " 시작 괄호에 커서를 둬야 실행 됨
Plug 'mileszs/ack.vim' " 선호하는 search tool 사용하여 탐색 ag, grep..
Plug 'beloglazov/vim-online-thesaurus' " 영영 사전 ons
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' } "indent line 보여줌
autocmd! User indentLine doautocmd indentLine Syntax

Plug 'nvie/vim-flake8' "python 문법체크 PEP8
Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' } " Lint

" Source Code read helper (Nerdtree, Tagbar)
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END

if v:version >= 703
  Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
endif

" Git
Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] } "dash board 조회 :GH 로 시작함
Plug 'junegunn/gv.vim' " :GV라고 사용하면 그동안의 커밋 로그 확인 가능
Plug 'tpope/vim-fugitive' " :Gblame 같은 걸로 추적하기 편리
if v:version >= 703
  Plug 'mhinz/vim-signify' " git repo의 변동사항을 좌측에 보여줌
endif

if os == 'Darwin'
  Plug 'rizzatti/dash.vim',  { 'on': 'Dash' } " Dash와 연동
endif

call plug#end()
endif

" }}}

" Setting {{{
let mapleader = ' '
let maplocalleader = ' '

" 80 chars/line
augroup vimrc
  autocmd!
augroup END

set number
set autoindent
set smartindent

set laststatus=2
set showcmd

set visualbell t_vb=".

set timeout timeoutlen=1000 ttimeoutlen=100

set shortmess=aIT

set hlsearch
set incsearch
set ignorecase smartcase

set wildmenu
set wildmode=list:full
set completeopt=menuone,preview

set tabstop=4
set shiftwidth=4
set expandtab smarttab

set scrolloff=5

set encoding=utf-8

set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→

set virtualedit=block

set foldlevelstart=99

set nocursorline

set nrformats=hex

set synmaxcol=9999

if os == 'Darwin' || os == 'Mac' || os == 'Linux'
  set backupdir=/tmp//,.  
  set directory=/tmp//,.  
  if v:version >= 703
    set undodir=/tmp//,.  
  endif
endif

if exists('&colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

set pastetoggle=<F9>

set nostartofline

set isfname-=-
set isfname-=:

if exists('&fixeol')
  set nofixeol
endif

if has('gui_running')
    silent! colorscheme seoul256
else
    silent! colorscheme molokai
endif

set tags=./tags;/
" }}}

" Mapping {{{

"noremap: none recursive map
"nnoremap: normal mode none recursive map
"inoremap: insert mode none recursive map

" Page down
noremap <C-F> <C-D>
" Page up
noremap <C-B> <C-U>

" Save, need alias .zshrc --> alias vim="stty stop '' -ixoff ; vim"
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>


" <F8> | Color scheme selector
function! s:colors(...)
  return filter(map(filter(split(globpath(&rtp, 'colors/*.vim'), "\n"),
              \                           'v:val !~ "^/usr/"'),
              \                           'fnamemodify(v:val, ":t:r")'),
              \                           '!a:0 || stridx(v:val, a:1) >= 0')
endfunction

function! s:rotate_colors()
  if !exists('s:colors')
    let s:colors = s:colors()
  endif
  let name = remove(s:colors, 0)
  call add(s:colors, name)
  execute 'colorscheme' name
  redraw
  echo name
endfunction
nnoremap <silent> <F8> :call <SID>rotate_colors()<cr>

" <F10> | NERD Tree
nnoremap <F10> :NERDTreeToggle<CR>

" <F11> | Tagbar
if v:version >= 703
  inoremap <F11> <ESC>:TagbarToggle<CR>
  nnoremap <F11> :TagbarToggle<CR>
  let g:tagbar_sort = 0
endif


" Zoom  Split window mode, Want to see only current window.
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <Leader>z :call <sid>zoom()<CR>

" Buffers
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>

" Tabs
nnoremap ]t :tabn<CR>
nnoremap [t :tabp<CR>

" Circular split windows navigation
nnoremap <TAB> <C-W>w
nnoremap <S-TAB> <C-W>W

" Markdown header
nnoremap <Leader>1 m`yypVr=``
nnoremap <Leader>2 m`yypVr-``
nnoremap <Leader>3 m`^i### <esc>``4l
nnoremap <Leader>4 m`^i#### <esc>``5l
nnoremap <Leader>5 m`^i##### <esc>``6l

" gi / gpi | go to next/previous indentation level
function! s:indent_len(str)
  return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunction

function! s:go_indent(times, dir)
  for _ in range(a:times)
    let l = line('.')
    let x = line('$')
    let i = s:indent_len(getline(l))
    let e = empty(getline(l))

    while l >= 1 && l <= x
      let line = getline(l + a:dir)
      let l += a:dir
      if s:indent_len(line) != i || empty(line) != e
        break
      endif
    endwhile
    let l = min([max([1, l]), x])
    execute 'normal! '. l .'G^'
  endfor
endfunction
nnoremap <silent> gi :<C-U>call <SID>go_indent(v:count1, 1)<CR>
nnoremap <silent> gpi :<C-U>call <SID>go_indent(v:count1, -1)<CR>

" vim-commentary
map gc <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" vim-fugitive
nmap <Leader>g :Gstatus<CR>gg<C-N>
nnoremap <Leader>d :Gdiff<CR>

" matchit.vim  '%' matching
runtime macros/matchit.vim

" ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nnoremap <Leader>a :Ack!<Space>

" vim-after-object
"    va=  visual after =
"    ca=  change after =
"    da=  delete after =
"    ya=  yank after =
autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')

" vim-easy-align
" 1. 'v' visual seclect
" 2. ga  mapped key
" 3. ' ' align with space 
" 4. result
"               int i;                   int  i;
"               char  buf[1024];   -->   char buf[1024];
"               int bytes;               int  bytes;
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '\': { 'pattern': '\\' },
\ '/': { 'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['!Comment'] },
\ ']': {
\     'pattern':       '\]\zs',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       ')\zs',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ 'f': {
\     'pattern': ' \(\S\+(\)\@=',
\     'left_margin': 0,
\     'right_margin': 0
\   },
\ 'd': {
\     'pattern': ' \ze\S\+\s*[;=]',
\     'left_margin': 0,
\     'right_margin': 0
\   }
\ }

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap gaa ga_

" vim-github-dashboard
let g:github_dashboard = { 'username': 'byung-u', 'password': $GITHUB_PW }

" indentLine
"let g:indentLine_enabled = 0

" vim-signify
let g:signify_vcs_list = ['git']
let g:signify_sign_change = '✡'

" goyo + limelight
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  " hi NonText ctermfg=101
  Limelight
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <Leader>G :Goyo<CR>

" undotree
let g:undotree_WindowLayout = 4
nnoremap U :UndotreeToggle<CR>

" gv
nnoremap <Leader>b :Gblame<CR>
nnoremap <Leader>B :Gbrowse<CR>

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] } "use flake8

" splitjoin
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nnoremap gss :SplitjoinSplit<CR>
nnoremap gsj :SplitjoinJoin<CR>

" online thesaurus
let g:online_thesaurus_map_keys = 0
nnoremap <silent> <Leader>D        :OnlineThesaurusCurrentWord<CR>

" Dash
nnoremap da :Dash<CR>

" fzf
" File preview using Highlight (http://www.andre-simon.de/doku/highlight/en/highlight.php)
let g:fzf_files_options =
  \ '--preview "(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'"'

" nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<C-W>\<C-W>" : '').":Files\<CR>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>
" nnoremap <silent> q: :History:<CR>
" nnoremap <silent> q/ :History/<CR>

inoremap <expr> <C-X><C-T> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <C-X><C-K> <plug>(fzf-complete-word)
imap <C-X><C-F> <plug>(fzf-complete-path)
imap <C-X><C-J> <plug>(fzf-complete-file-ag)
imap <C-X><C-L> <plug>(fzf-complete-line)

nmap <Leader><TAB> <PLUG>(fzf-maps-n)
xmap <Leader><TAB> <PLUG>(fzf-maps-x)
omap <Leader><TAB> <PLUG>(fzf-maps-o)

command! Plugs call fzf#run({
  \ 'source':  map(sort(keys(g:plugs)), 'g:plug_home."/".v:val'),
  \ 'options': '--delimiter / --nth -1',
  \ 'down':    '~40%',
  \ 'sink':    'Explore'})

map <Leader>v :VimuxPromptCommand<CR>
"map <Leader>vm :VimuxPromptCommand("make ")<CR>

" }}}
