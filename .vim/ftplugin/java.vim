compiler! javac

if isdirectory('bin') && isdirectory('src')
	let &makeprg = 'javac -d bin'
	noremap <C-b> :make $(find src -name '*.java')<CR><CR>
	inoremap <C-b> <C-o>:make $(find src -name '*.java')<CR><CR>
endif
