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

set fillchars=vert:\ 
set listchars=tab:⇢\ 
" set listchars=tab:⟶\ 
set list

syntax on
filetype plugin on
filetype indent on

highlight String ctermfg=green
highlight Statement ctermfg=darkgreen
highlight Type ctermfg=121
highlight Typedef cterm=bold
highlight LineNr cterm=none ctermfg=brown
highlight CursorLine cterm=none ctermbg=235
highlight CursorLineNr cterm=bold ctermfg=10 ctermbg=235
highlight Pmenu ctermbg=black ctermfg=yellow
highlight PmenuSel ctermbg=green ctermfg=black
highlight Todo ctermbg=green ctermfg=blue
highlight Constant cterm=bold
highlight javaAnnotation ctermfg=blue
highlight Folded ctermbg=235 ctermfg=green
highlight SpecialKey ctermfg=darkgray
highlight VertSplit cterm=none ctermbg=darkgray
highlight DiffDelete ctermbg=235
highlight DiffText ctermbg=darkgreen

inoremap <S-Left> <C-o>gT
inoremap <S-Right> <C-o>gt
inoremap <A-Left> <C-o>:bp<CR>
inoremap <A-Right> <C-o>:bn<CR>
inoremap <C-l> <ESC>mmYp`ma
inoremap <C-h> <C-o>:set hlsearch! hlsearch?<CR>
inoremap <C-d> <C-o>:wa<CR>
inoremap <A-Up> <ESC>:m-2<CR>==a
inoremap <A-Down> <ESC>:m+1<CR>==a

noremap <S-Left> gT
noremap <S-Right> gt
noremap <A-Left> :bp<CR>
noremap <A-Right> :bn<CR>
noremap <C-h> :set hlsearch! hlsearch?<CR>
noremap <c-d> :wa<CR>

cabbrev bd bp\|bd #
cabbrev bdf bp\|bd! #
cabbrev wd w\|bp\|bd #

" Autoclosing brackets
let g:closing = {'{':'}', '[':']', '(':')'}

function! InsertOnce(chr)
	let a:nextChar = matchstr(getline('.'), '\%'.(col('.')+1).'c.')
	if a:chr != a:nextChar
		exe "normal! a".a:chr
		return 1
	else
		exe "normal! l"
		return 0
	endif
endfunction

for i in keys(g:closing)
	exe "inoremap ".i." ".i.closing[i]."<Left>"
	exe "inoremap ".closing[i]." <ESC>:call InsertOnce('".closing[i]."')<CR>a"
	exe "inoremap ".i."<CR> ".i."<CR>".closing[i]."<C-o>O"
	exe "inoremap ".i."<Down> ".i."<Down>"
	exe "inoremap ".i."<Right> ".i."<Right>"
	exe "inoremap ".i."<BS> <Nop>"
endfor


" Handle quotes
let g:quotes = ['"', "'"]

function! InsertQuotes(chr)
	if InsertOnce(a:chr)
		exe "normal! a".a:chr
		exe "normal! h"
	endif
endfunction

for q in g:quotes
	exe "inoremap ".q." <ESC>:call InsertQuotes(\"\\".q."\")<CR>a"
	exe "inoremap ".q."<BS> <Nop>"
	exe "inoremap ".q."<Right> ".q
	exe "inoremap ".q."<Down> ".q
endfor


function! BreakLines()
	let &l:tw = winwidth('%') - 10
	exe "normal! mm"
	exe "normal! ggVGgq"
endfunction

inoremap <C-S-b> <C-o>:call BreakLines()<CR>
map <C-S-b> :call BreakLines()<CR>

function! RemoveTrailingWS()
	exe "normal! mm"
	%s/\s\+$//ge
	exe "normal! `m"
endfunction


" PLUGINS
execute pathogen#infect()

" Airline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1

" unicode symbols
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

" NERDTree
let g:NERDTreeMouseMode = 3 " open with single click
let g:NERDTreeShowHidden = 1

function! OpenNERDTree()
	if !exists('t:NERDTreeBufName') || bufwinnr(t:NERDTreeBufName) == -1
		NERDTree
		wincmd p
	endif
endfunction

autocmd VimEnter * call OpenNERDTree()
noremap <C-n> :NERDTreeToggle<CR>

" VCoolor
inoremap <kEnter> <C-o>:VCoolor<CR>
map <kEnter> :VCoolor<CR>

" Gdiff
set diffopt+=vertical

" Ultisnips
let g:UltiSnipsExpandTrigger="<TAB>"
let g:UltiSnipsJumpForwardTrigger="<C-d>"
let g:UltiSnipsJumpBackwardTrigger="<C-z>"

" emmet
let g:user_emmet_leader_key = '<C-e>'

" Tagbar
let g:tagbar_width = 35
let g:window_tagbar_threshold = 115
autocmd VimEnter * if &columns > g:window_tagbar_threshold | TagbarOpen

function! ToggleTagbar()
	if &columns > g:window_tagbar_threshold
		TagbarOpen
	else
		TagbarClose
	endif
endfunction

autocmd VimResized * call ToggleTagbar()

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
hi MatchTag cterm=underline ctermbg=none ctermfg=none

" WebDevIcons
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_enable = 1

set background=dark
