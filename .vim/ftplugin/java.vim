compiler! javac

if isdirectory('bin') && isdirectory('src')
	let &makeprg = 'javac -d bin'
	inoremap <C-b> <C-o>:make $(find src -name '*.java')<CR>
	noremap <C-b> <C-o>:make $(find src -name '*.java')<CR>
endif
