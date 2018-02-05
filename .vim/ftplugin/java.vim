compiler! javac

if isdirectory('bin') && isdirectory('src')
	let &makeprg = 'javac -d bin'
	noremap <C-b> <C-o>:make $(find src -name '*.java')<CR>
	inoremap <C-b> <C-o><C-b>
else
	noremap <C-b> :make %<CR>
	inoremap <C-b> <C-o>:make %<CR>
endif
