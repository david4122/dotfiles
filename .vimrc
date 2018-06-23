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

set fillchars=vert:\ 
set listchars=tab:⇢\ ,nbsp:•,eol:¬
" set listchars=tab:⟶\ 
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
highlight VertSplit cterm=none ctermbg=237
highlight DiffDelete ctermbg=235
highlight DiffText cterm=none ctermbg=130 ctermfg=white
highlight DiffChange ctermbg=17
highlight DiffAdd ctermbg=22
highlight SignColumn ctermbg=235
highlight phpMethodsVar cterm=italic

autocmd BufEnter * syntax match Method "\(\.\|->\)\@<=\s*\w\+\s*(\@="
highlight Method cterm=italic

autocmd BufEnter *.php compiler! php
autocmd BufEnter *.py let &makeprg = 'python -m py_compile'

autocmd BufRead anacrontab setf crontab

inoremap <S-Left> <C-o>gT
inoremap <S-Right> <C-o>gt
inoremap <A-Left> <C-o>:bp<CR>
inoremap <A-Right> <C-o>:bn<CR>
inoremap <C-l> <C-\><C-o>:exe "normal! mfYp`fa"<CR>
inoremap <C-h> <C-o>:set hlsearch! hlsearch?<CR>
inoremap <C-d> <C-o>:wa<CR>
inoremap <A-Up> <ESC>:m-2<CR>==a
inoremap <A-Down> <ESC>:m+1<CR>==a
inoremap <C-b> <C-o>:make %<CR>

nnoremap <S-Left> gT
nnoremap <S-Right> gt
nnoremap <A-Left> :bp<CR>
nnoremap <A-Right> :bn<CR>
nnoremap <C-h> :set hlsearch! hlsearch?<CR>
nnoremap <C-d> :wa<CR>
nnoremap <C-b> :make %<CR>
nnoremap <C-Up> <C-e>
nnoremap <C-Down> <C-y>
nnoremap <C-j> :Tags<CR>

nnoremap ]e :cnext<CR>
nnoremap [e :cprev<CR>

nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>

if has('terminal')
	if exists('##TerminalOpen')
		autocmd TerminalOpen * set nobuflisted
	endif

	tnoremap <kHome> <Home>
	tnoremap <kEnd> <End>
endif

vnoremap <C-y> "+y

command! CpPath let @+ = fnamemodify(@%, ':h')

function! s:mark()
	let s:mark_cursor_pos = getcurpos()
	let s:mark_top_line = line('w0')
endfunction

function! s:return()
	exe "normal! ".s:mark_top_line."Gzt"
	call setpos('.', s:mark_cursor_pos)
endfunction

function! BreakLines()
	let &l:tw = winwidth('%') - 10
	call <SID>mark()
	exe "normal! gq"
	call <SID>return()
endfunction

function! RemoveTrailingWS()
	call <SID>mark()
	%s/\s\+$//ge
	call <SID>return()
endfunction

" close buffer and jump to last opened/previus one
" 0 - default
" 1 - write
" 2 - force
function! s:jumpAndClose(action)
	if a:action == 1 | w | endif
	if len(getbufinfo({'buflisted':1})) > 1
		if &mod && a:action != 2
			echoerr "No write since last change!"
			return
		endif
		if buflisted(@#) | b# | else | bp | endif
		if a:action == 2 | bd! # | else | bd # | endif
	else
		if a:action == 2 | bd! | else | bd | endif
	endif
endfunction

cnoreabbrev db call <SID>jumpAndClose(0)
cnoreabbrev dbf call <SID>jumpAndClose(2)
cnoreabbrev wd call <SID>jumpAndClose(1)

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
		let g:debug = a:chrs
		let a:chrs = substitute(a:chrs, '[ \t\n]', '', 'g')
		if strlen(a:chrs) == 0
			return 0
		endif
	else
		let a:chrs = matchstr(getline('.'), '.\%'.(col('.')).'c.')
	endif
	return get(g:closing, nr2char(strgetchar(a:chrs, 0)), '-')
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

function! s:openGDiffInTab()
	if(!exists(':Gdiff'))
		echoerr 'Git repository not found'
		return
	endif

	let a:line = line('.')
	tabe %
	Gdiff
	call cursor(a:line, 0)
endfunction

command! ShowGdiff call <SID>openGDiffInTab()


" PLUGINS
execute pathogen#infect()

" disable airline if term doesn'y support colors'
if system('tput colors') !~ '256'
	let g:loaded_airline = 1
endif

if &diff || (exists('g:quick_mode') && g:quick_mode)
	nnoremap ;; :qa<CR>
	set signcolumn=no
	let g:loaded_youcompleteme = 1
	let g:loaded_signify = 1
	let g:loaded_syntastic_plugin = 1
	let g:is_vdebug_loaded = 1
else
	set relativenumber

	" Tagbar
	let g:tagbar_width = 30
	let g:tagbar_singleclick = 1

	" Undotree
	let g:undotree_WindowLayout = 3
	let g:undotree_SplitWidth = 40
	let g:undotree_SetFocusWhenToggle = 1

	let t:right_pane_content = 'tagbar'
	let g:window_right_pane_threshold = 130

	function! s:toggleRightPane()
		if &columns > g:window_right_pane_threshold
			if t:right_pane_content == 'tagbar'
				TagbarOpen
			elseif t:right_pane_content == 'undotree'
				UndotreeShow
			endif
		else
			TagbarClose
			UndotreeHide
		endif
	endfunction

	autocmd VimEnter * call <SID>toggleRightPane()
	autocmd VimResized * call <SID>toggleRightPane()

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

	" NERDTree
	let g:NERDTreeMouseMode = 3 " open with single click
	let g:NERDTreeShowHidden = 1

	autocmd VimEnter * NERDTree | vertical resize 25 | wincmd p

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
	let g:ycm_add_preview_to_completeopt = 1
	let g:ycm_autoclose_preview_window_after_insertion = 1
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

" NERDCommenter
let g:NERDSpaceDelims = 1

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
let g:mta_filetypes = {
			\ 'html' : 1,
			\ 'xhtml' : 1,
			\ 'xml' : 1,
			\ 'jinja' : 1,
			\ 'php' : 1,
			\}

let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0
highlight MatchTag cterm=underline,bold ctermbg=none ctermfg=none

" WebDevIcons
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
if exists('g:loaded_webdevicons')
	call webdevicons#refresh()
	wincmd p
endif

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

" FZF
nnoremap <C-p> :Buffers<CR>
nnoremap <C-n> :Files<CR>

set background=dark
" Fix problems with Tagbar
autocmd VimEnter * AirlineRefresh

if filereadable('~/.vimrc.local')
	source ~/.vimrc.local
endif
