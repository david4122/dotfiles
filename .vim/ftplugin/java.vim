compiler! javac

if isdirectory('bin') && isdirectory('src')
	let &makeprg = 'javac -d bin'
	noremap <C-b> :make $(find src -name '*.java')<CR><CR>
	inoremap <C-b> <C-o>:make $(find src -name '*.java')<CR><CR>
else
	noremap <C-b> :make %<CR><CR>
	inoremap <C-b> <C-o>:make %<CR><CR>
endif
