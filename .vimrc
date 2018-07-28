""""""""""""""
"  Settings  "
""""""""""""""
set nocompatible
set number
set tabstop=4
set shiftwidth=4
set softtabstop=4
set mouse=a
set noswapfile
set hlsearch
set incsearch
set noswapfile
set cursorline
set laststatus=2
set autowrite
set splitbelow
set splitright
set nostartofline
set hidden
set wildmenu
set wildmode=longest:full,full
set completeopt=longest,menuone
set autoindent
set nohlsearch
set omnifunc=syntaxcomplete#Complete
set whichwrap+=[,]
set backspace=indent,eol,start
set nofixendofline
set encoding=utf8
set display+=lastline
set breakindent
set breakindentopt+=shift:2
set wildignore+=tags,dbdata.vim,Session.vim,*.log
set virtualedit=block
set synmaxcol=0
set linebreak
set ignorecase
set smartcase
set ttymouse=sgr
set smarttab
set formatoptions+=j
set showcmd
set ttimeoutlen=50
set scrolloff=2
set sidescrolloff=5
set title
set lazyredraw

set listchars=tab:⇢\ ,nbsp:•,eol:¬
set list

let s:undo_dir = $HOME.'/.vim/undo'
if !isdirectory(s:undo_dir)
	call system('mkdir '.s:undo_dir)
endif
let &undodir = s:undo_dir
set undofile

syntax on
filetype plugin on
filetype indent on

runtime macros/matchit.vim

""""""""""""""""
"  Highlights  "
""""""""""""""""
highlight String ctermfg=142
highlight Statement ctermfg=darkgreen
highlight Type ctermfg=121
highlight Typedef cterm=bold
highlight LineNr cterm=none ctermfg=240
highlight CursorLine cterm=none ctermbg=234
highlight CursorLineNr cterm=none ctermfg=250 ctermbg=234
highlight Pmenu ctermbg=233 ctermfg=242
highlight PmenuSel ctermbg=234 ctermfg=121
highlight Todo ctermbg=green ctermfg=blue
highlight Constant cterm=bold
highlight javaAnnotation ctermfg=blue
highlight Folded ctermbg=234 ctermfg=121
highlight FoldColumn ctermbg=236 ctermfg=252
highlight SpecialKey ctermfg=237
highlight NonText ctermfg=239
highlight VertSplit cterm=none ctermbg=233
highlight DiffDelete ctermbg=235
highlight DiffText cterm=none ctermbg=130 ctermfg=white
highlight DiffChange ctermbg=17
highlight DiffAdd ctermbg=22
highlight SignColumn ctermbg=235
highlight phpMethodsVar cterm=italic
highlight DbgBreakptLine ctermbg=brown
highlight DbgBreakptSign ctermbg=brown
highlight StatusLine cterm=none ctermfg=121 ctermbg=233
highlight StatusLineNC cterm=none ctermbg=233 ctermfg=none
highlight MatchParen cterm=bold ctermbg=none ctermfg=yellow

autocmd BufEnter * syntax match Method "\(\.\|->\)\@<=\s*\w\+\s*(\@="
highlight Method cterm=italic

""""""""""""""
"  Mappings  "
""""""""""""""
inoremap <A-Left> <C-o>:bp<CR>
inoremap <A-Right> <C-o>:bn<CR>
inoremap <A-Up> <C-o><C-e>
inoremap <A-Down> <C-o><C-y>
inoremap <silent> <S-Up> <ESC>:m-2<CR>==a
inoremap <silent> <S-Down> <ESC>:m+1<CR>==a
inoremap <S-Left> <C-d>
inoremap <S-Right> <C-t>
inoremap <C-d> <C-o>:wa<CR>
inoremap <C-l> <C-\><C-o>:exe "normal! mfYp`fa"<CR>
inoremap <C-b> <C-o>:make %<CR>

nnoremap <A-Left> :bp<CR>
nnoremap <A-Right> :bn<CR>
nnoremap <A-Up> <C-e>
nnoremap <A-Down> <C-y>
nnoremap <S-Left> <<
nnoremap <S-Right> >>
nnoremap <silent> <S-Up> :m-2<CR>==
nnoremap <silent> <S-Down> :m+1<CR>==
nnoremap <C-d> :wa<CR>
nnoremap <C-b> :make %<CR>
nnoremap <C-j> :Tags<CR>
nnoremap Y y$
nnoremap <C-w><C-Up> 5<C-w>+
nnoremap <C-w><C-Down> 5<C-w>-
nnoremap <C-w><C-Left> 5<C-w><
nnoremap <C-w><C-Right> 5<C-w>>

nnoremap ]e :cnext<CR>
nnoremap [e :cprev<CR>

nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>

vnoremap <C-y> "+y
vnoremap <S-Left> <gv
vnoremap <S-Right> >gv

if has('terminal')
	if exists('##TerminalOpen')
		autocmd TerminalOpen * set nobuflisted
	endif

	tnoremap <kHome> <Home>
	tnoremap <kEnd> <End>
endif

""""""""""""""""""""""""""""
"  Commands and functions  "
""""""""""""""""""""""""""""
command! -bar -bang Db if buflisted(@#) | b# | else | bp | endif | bd<bang> #
command! -bar -bang Dw write<bang> | Db

command! CpPath let @+ = fnamemodify(@%, ':h') | echo @+

function! BreakLines()
	let &l:tw = winwidth('%') - 10
	let a:winview = winsaveview()
	exe "normal! gq"
	call winrestview(a:winview)
endfunction

function! RemoveTrailingWS()
	let a:winview = winsaveview()
	%s/\s\+$//ge
	call winrestview(a:winview)
endfunction

function! s:openedInCurrentTab(bufname)
	let a:bufnr = bufnr(a:bufname)
	return index(tabpagebuflist(), a:bufnr) >= 0
endfunction

function! s:iunmapMoving(key)
	exe "inoremap ".a:key."<Left> ".a:key."<Left>"
	exe "inoremap ".a:key."<Right> ".a:key."<Right>"
	exe "inoremap ".a:key."<Up> ".a:key."<Up>"
	exe "inoremap ".a:key."<Down> ".a:key."<Down>"
	exe "inoremap ".a:key."<kHome> ".a:key."<kHome>"
	exe "inoremap ".a:key."<kEnd> ".a:key."<kEnd>"
endfunction

" Autoclosing brackets
let g:closing = {'{':'}', '[':']', '(':')'}

function! s:insertOnce(chr)
	let a:nextChar = matchstr(getline('.'), '\%'.(col('.')).'c.')
	if a:chr != a:nextChar
		return a:chr
	else
		return "\<Right>"
	endif
endfunction

for i in keys(g:closing)
	exe "inoremap <expr> ".closing[i]." <SID>insertOnce('".closing[i]."')"
	exe "inoremap ".i." ".i.closing[i]."<Left>"
	call <SID>iunmapMoving(i)
endfor

" Handle quotes
let g:quotes = ['"', "'"]

function! s:insertQuotes(chr)
	if <SID>insertOnce(a:chr) == a:chr
		return a:chr.a:chr."\<Left>"
	else
		return "\<Right>"
	endif
endfunction

for q in g:quotes
	exe "inoremap <expr> ".q." <SID>insertQuotes(\"\\".q."\")"
	call <SID>iunmapMoving(q)
endfor

function! s:inQuotesOrBrackets(multiline)
	if a:multiline
		let a:chrs = matchstr(
					\ getline(line('.')-1)."\n".getline('.')."\n".getline(line('.')+1),
					\ '.\s*\n\s\+\n\s*.')
		let a:chrs = substitute(a:chrs, '[ \t\n]', '', 'g')
		if strlen(a:chrs) == 0
			return 0
		endif
	else
		let a:chrs = matchstr(getline('.'), '.\%'.(col('.')).'c.')
	endif
	return get(g:closing, nr2char(strgetchar(a:chrs, 0)), '\0')
				\ == nr2char(strgetchar(a:chrs, 1))
				\ || (strgetchar(a:chrs, 0) == strgetchar(a:chrs, 1)
				\ && index(g:quotes, nr2char(strgetchar(a:chrs, 0))) >= 0)
endfunction

function! s:removePairs()
	if <SID>inQuotesOrBrackets(0)
		return "\<DEL>\<BS>"
	elseif <SID>inQuotesOrBrackets(1)
		return "\<ESC>\<Up>JJi\<BS>"
	else
		return "\<BS>"
	endif
endfunction

inoremap <expr> <BS> <SID>removePairs()

function! s:insertBlock()
	if <SID>inQuotesOrBrackets(0)
		return "\<CR>\<C-o>O"
	else
		return "\<CR>"
	endif
endfunction

inoremap <expr> <CR> <SID>insertBlock()

" Automatically restore view in the window
function! s:saveWinView()
	if !exists('w:win_views')
		let w:win_views = {}
	endif
	let w:win_views[bufnr('%')] = winsaveview()
endfunction

function! s:restoreWinView()
	if exists('w:win_views') && has_key(w:win_views, bufnr('%'))
				\ && line('.') == 1 && col('.') == 1
		call winrestview(w:win_views[bufnr('%')])
		unlet w:win_views[bufnr('%')]
	endif
endfunction

autocmd BufEnter * call <SID>restoreWinView()
autocmd BufLeave * call <SID>saveWinView()

function! s:completeParams()
	if !exists('v:completed_item.menu') || empty(v:completed_item.menu)
		return
	endif

	let sepIdx = stridx(v:completed_item.menu, '|')
	let args = split(strpart(v:completed_item.menu, 0, sepIdx - 1), '\(\>, \| \[\(, \)\@=\|]\+\)')
	let index = 0
	let stack = 0
	while index < len(args)
		if empty(trim(args[index]))
			continue
		endif
		if strgetchar(args[index], 0) == char2nr(',')
			let arg = strpart(args[index], 2)
			let args[index] = '${'.(index+stack*2+1).':, ${'.(index+stack*2+2).':'.arg.'}'
			let stack = stack + 1
		else
			let args[index] = '${'.(index+stack*2+1).':'.args[index].'}'
			if index != 0
				let args[index] = ', '.args[index]
			endif
		endif
		let index = index + 1
	endwhile
	let template = join(args, '')
	for i in range(stack)
		let template = template.'}'
	endfor
	if !empty(template)
		let template = template.')$0'
		call UltiSnips#Anon(template)
	endif
endfunction

autocmd CompleteDone *.php call <SID>completeParams()

autocmd BufEnter *.php compiler! php
autocmd BufEnter *.py let &makeprg = 'python -m py_compile'

autocmd BufRead anacrontab setf crontab
autocmd BufRead .htaccess set commentstring=#\ %s
autocmd FileType smarty set commentstring={*\ %s\ *}

"""""""""""""
"  Plugins  "
"""""""""""""
call plug#begin('~/.vim/bundle')

Plug 'Valloric/YouCompleteMe', {'do': './install.py --java-completer --js-completer --clang-completer'}
Plug 'ap/vim-css-color'
Plug 'blueyed/smarty.vim', {'for': 'smarty'}
Plug 'chrisbra/csv.vim', {'for': 'csv'}
Plug 'easymotion/vim-easymotion'
Plug 'edkolev/promptline.vim'
Plug 'honza/vim-snippets'
Plug 'joonty/vdebug', {'on': 'VdebugStart'}
Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'kabbamine/vcoolor.vim', {'on': ['VCoolor', 'VCoolIns']}
Plug 'majutsushi/tagbar', {'on': 'TagbarOpen'}
Plug 'mattn/emmet-vim', {'for': ['html', 'php', 'smarty']}
Plug 'mbbill/undotree'
Plug 'mhinz/vim-signify'
Plug 'osyo-manga/vim-anzu'
Plug 'ryanoasis/vim-devicons'
Plug 'sirver/ultisnips'
Plug 'tfnico/vim-gradle', {'for': 'java'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
Plug 'valloric/matchtagalways', {'for': ['html', 'xml', 'php', 'smarty']}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/dbext.vim', {'for': ['java', 'php']}
Plug 'vim-syntastic/syntastic'
Plug 'nanotech/jellybeans.vim'

call plug#end()

" disable airline if term doesn't support colors
if system('tput colors') !~ '256'
	let g:loaded_airline = 1
	let g:webdevicons_enable = 0
else
	set fillchars=vert:\ 
endif

if &diff || (exists('g:quick_mode') && g:quick_mode)
	nnoremap ;; :qa<CR>
	set signcolumn=no
	let g:loaded_youcompleteme = 1
	let g:loaded_signify = 1
	let g:loaded_syntastic_plugin = 1
else
	set relativenumber

	" Tagbar
	let g:tagbar_width = 50
	let g:tagbar_singleclick = 1

	" Undotree
	let g:undotree_WindowLayout = 3
	let g:undotree_SplitWidth = 40
	let g:undotree_SetFocusWhenToggle = 1

	let g:window_right_pane_threshold = 150

	function! s:toggleRightPane()
		if &columns > g:window_right_pane_threshold
			if exists('t:right_pane_content') && t:right_pane_content == 'tagbar'
				TagbarOpen
			elseif exists('t:right_pane_content') && t:right_pane_content == 'undotree'
				UndotreeShow
			endif
		else
			TagbarClose
			UndotreeHide
		endif
	endfunction

	autocmd VimEnter * let t:right_pane_content = 'tagbar'
	autocmd VimEnter,VimResized * call <SID>toggleRightPane()

	function! s:swapUndotreeTagbar()
		let a:tagbar_buffer = filter(getbufinfo(),
					\ "v:val['name'] =~ 'Tagbar' && <SID>openedInCurrentTab(v:val['name'])")
		if len(a:tagbar_buffer) > 0
			TagbarClose
			UndotreeShow
			let t:right_pane_content = 'undotree'
		else
			UndotreeHide
			TagbarOpen
			let t:right_pane_content = 'tagbar'
		endif
	endfunction

	nnoremap <silent> <C-u> :call <SID>swapUndotreeTagbar()<CR>

	" Signify
	autocmd BufEnter * highlight SignifySignAdd ctermbg=235 ctermfg=green
	autocmd BufEnter * highlight SignifySignDelete ctermbg=235 ctermfg=blue
	autocmd BufEnter * highlight SignifySignChange ctermbg=235 ctermfg=lightgray
	let g:signify_sign_change = '~'

	" Syntastic
	" disable for Java files
	let g:syntastic_java_checkers = []

	" YouCompleteMe
	let ycm_key_list_select_completion = ['<Down>', '`']
	let ycm_key_list_previous_completion = ['<Up>', '~']
	let g:ycm_complete_in_strings = 1
	let g:ycm_collect_identifiers_from_comments_and_strings = 1
	let g:ycm_always_populate_location_list = 1
	let g:airline#extensions#ycm#enabled = 1

	nnoremap <C-f> :YcmCompleter FixIt<CR>
endif

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline_theme = 'jellybeans'

" unicode symbols
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_symbols.crypt = '🔒'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" VCoolor
inoremap <kEnter> <Left><C-o>:VCoolor<CR>
nnoremap <kEnter> <Left>:VCoolor<CR>

" Gdiff
set diffopt+=vertical

" Ultisnips
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
if !exists('UltiSnipsSnippetDirectories')
	let g:UltiSnipsSnippetDirectories = ['UltiSnips', '~/.vim/UltiSnips']
endif

" emmet
let g:user_emmet_leader_key = '<C-e>'

" MatchTagAlways
let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0
highlight MatchTag cterm=underline,bold ctermbg=none ctermfg=none

" dbext
if filereadable('dbdata.vim')
	let g:dbext_default_profile = 'local'
	let db_data = readfile('dbdata.vim')
	let g:dbext_default_profile_local = join(db_data, ':')
endif

let g:dbext_default_history_file = '~/.vim/dbext_history'
autocmd BufEnter Result setlocal nobuflisted
autocmd BufEnter Result set winfixheight

" Promptline
let g:promptline_preset = {
	\'a': ['\u@\h', promptline#slices#python_virtualenv()],
	\'b': ['\t', promptline#slices#jobs()],
	\'c': [promptline#slices#cwd({'dir_limit': 10})],
	\'y': [promptline#slices#vcs_branch()],
	\'warn': [promptline#slices#last_exit_code()]}

" EasyMotion
highlight EasyMotionTarget cterm=bold ctermfg=yellow

" FZF
let g:fzf_layout = {'window' : 'botright 15split'}
let g:fzf_history_dir = '~/.vim/.fzf_hist'

nnoremap <C-p> :Buffers<CR>
nnoremap <C-n> :Files<CR>

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>,
			\ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'),
			\ <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --ignore .git -g ""'}, <bang>0)


" Anzu
nnoremap <silent> <leader>h :if &hlsearch \| 
			\ AnzuClearSearchStatus \| set nohlsearch \|
		\ else \|
			\ set hlsearch \| AnzuUpdateSearchStatus \|
		\ endif<CR>


set background=dark
if system('tput colors') =~ '256'
	" Fix problems with Tagbar
	autocmd VimEnter * AirlineRefresh
endif

if filereadable('~/.vimrc.local')
	source ~/.vimrc.local
endif
