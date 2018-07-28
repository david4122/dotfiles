compiler! javac

if file_readable('build.gradle')
	autocmd VimEnter *.java compiler! gradle
	inoremap <C-b> <C-o>:make build<CR>
	nnoremap <C-b> :make build<CR>
elseif isdirectory('bin') && isdirectory('src')
	let &makeprg = 'javac -d bin'
	noremap <C-b> :make $(find src -name '*.java')<CR><CR>
	inoremap <C-b> <C-o>:make $(find src -name '*.java')<CR><CR>
endif
