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
set wildmode=longest,list,full
set completeopt=longest,menuone
set autoindent
set nohlsearch
set omnifunc=syntaxcomplete#Complete
set whichwrap+=[,]
set backspace=indent,eol,start
set nofixendofline
set encoding=utf8

set fillchars=vert:\ 
set listchars=tab:⇢\ ,nbsp:•
" set listchars=tab:⟶\ 
set list

if !isdirectory('~/.vim/undo')
	call system('mkdir ~/.vim/undo')
endif
set undodir=~/.vim/undo
set undofile

syntax on
filetype plugin on
filetype indent on

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

autocmd TerminalOpen * set nobuflisted

" Mark to use by functions
let g:functions_mark = 'f'

inoremap <S-Left> <C-o>gT
inoremap <S-Right> <C-o>gt
inoremap <A-Left> <C-o>:bp<CR>
inoremap <A-Right> <C-o>:bn<CR>
inoremap <C-l> <C-\><C-o>:exe "normal! m".g:functions_mark."Yp`".g:functions_mark."a"<CR>
inoremap <C-h> <C-o>:set hlsearch! hlsearch?<CR>
inoremap <C-d> <C-o>:wa<CR>
inoremap <A-Up> <ESC>:m-2<CR>==a
inoremap <A-Down> <ESC>:m+1<CR>==a
inoremap <C-b> <C-o>:make %<CR>
inoremap <C-Up> <C-o>:cprev<CR>
inoremap <C-Down> <C-o>:cnext<CR>

noremap <S-Left> gT
noremap <S-Right> gt
noremap <A-Left> :bp<CR>
noremap <A-Right> :bn<CR>
noremap <C-h> :set hlsearch! hlsearch?<CR>
noremap <C-d> :wa<CR>
noremap <C-b> :make %<CR>

noremap ]e :cnext<CR>
noremap [e :cprev<CR>

noremap ]l :lnext<CR>
noremap [l :lprev<CR>

tnoremap <kHome> <Home>
tnoremap <kEnd> <End>

if &diff
	nnoremap ;; :qa<CR>
endif

function! s:saveAs(fname, bang)
	let a:dir = fnamemodify(a:fname, ':p:h')
	call system("mkdir -p ".a:dir)
	if a:bang | exe "w ".a:fname | else | exe "w! ".a:fname | endif
	exe "e ".a:fname
	bd #
	call system("rm ".bufname('#'))
endfunction

command! -nargs=1 -complete=file Saveas call <SID>saveAs(<f-args>, <bang>0)

function! s:mark()
	exe "normal! m".g:functions_mark."H"
	let s:mark_top_line = line('.')
	echo s:mark_top_line
endfunction

function! s:return()
	exe "normal! ".s:mark_top_line."Gzt"
	exe "normal! `".g:functions_mark
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

function! s:inQuotesOrBrackets(chrs)
	return get(g:closing, nr2char(strgetchar(a:chrs, 0)), '-')
				\ == nr2char(strgetchar(a:chrs, 1))
				\ || (strgetchar(a:chrs, 0) == strgetchar(a:chrs, 1)
				\ && index(g:quotes, nr2char(strgetchar(a:chrs, 0))) >= 0)
endfunction

function! s:removePairs(chrs)
	if <SID>inQuotesOrBrackets(a:chrs)
		return "\<Del>\<BS>"
	else
		return "\<BS>"
	endif
endfunction

inoremap <expr> <BS> <SID>removePairs(matchstr(getline('.'), '.\%'.(col('.')).'c.'))

function! s:insertBlock(chrs)
	if <SID>inQuotesOrBrackets(a:chrs)
		return "\<CR>\<C-o>O"
	else
		return "\<CR>"
	endif
endfunction

inoremap <expr> <CR> <SID>insertBlock(matchstr(getline('.'), '.\%'.(col('.')).'c.'))

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
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" CtrlP
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_dotfiles = 1

if !&diff
	" NERDTree
	let g:NERDTreeMouseMode = 3 " open with single click
	let g:NERDTreeShowHidden = 1

	autocmd VimEnter * NERDTree | vertical resize 25 | wincmd p
	noremap <C-n> :NERDTreeToggle<CR>
endif

" NERDCommenter
let g:NERDSpaceDelims = 1

" VCoolor
inoremap <kEnter> <C-o>:VCoolor<CR>
map <kEnter> :VCoolor<CR>

" Gdiff
set diffopt+=vertical

" Ultisnips
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

" emmet
noremap <C-u> <C-e>
let g:user_emmet_leader_key = '<C-e>'

" Tagbar
if !&diff
	let g:tagbar_width = 30
	let g:tagbar_singleclick = 1
	let g:window_tagbar_threshold = 115

	function! s:toggleTagbar()
		if &columns > g:window_tagbar_threshold
			TagbarOpen
		else
			TagbarClose
		endif
	endfunction

	autocmd VimEnter * call <SID>toggleTagbar()
	autocmd VimResized * call <SID>toggleTagbar()
endif

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
highlight MatchTag cterm=underline ctermbg=none ctermfg=none

" WebDevIcons
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
if exists('g:loaded_webdevicons')
	call webdevicons#refresh()
	wincmd p
endif

" Signify
if !&diff
	autocmd BufEnter * highlight SignifySignAdd ctermbg=235 ctermfg=green
	autocmd BufEnter * highlight SignifySignDelete ctermbg=235 ctermfg=blue
	autocmd BufEnter * highlight SignifySignChange ctermbg=235 ctermfg=lightgray
	let g:signify_sign_change = '~'
else
	set signcolumn=no
endif

" YouCompleteMe
let ycm_key_list_select_completion = ['<Down>', '`']
let ycm_key_list_previous_completion = ['<Up>', '~']
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_always_populate_location_list = 1
let g:airline#extensions#ycm#enabled = 1

inoremap <F7> <C-o>:YcmCompleter FixIt<CR>
nnoremap <F7> :YcmCompleter FixIt<CR>

" dbext
if file_readable('dbdata.vim')
	let g:dbext_default_profile = 'local'
	let db_data = readfile('dbdata.vim')
	let g:dbext_default_profile_local = join(db_data, ':')
endif
let g:dbext_default_history_file = '~/.dbext_history'
autocmd BufEnter Result setlocal nobuflisted
autocmd BufEnter Result set winfixheight

set background=dark
" Fix problems with Tagbar
autocmd VimEnter * AirlineRefresh
