compiler javac

if filereadable('build.gradle')
	compiler gradle
	inoremap <C-b> <C-o>:make build<CR>
	nnoremap <C-b> :make build<CR>
elseif isdirectory('bin') && isdirectory('src')
	set makeprg=javac\ -d\ bin\ $(find\ src\ -name\ '*.java')
	noremap <C-b> :make $(find src -name '*.java')<CR><CR>
	inoremap <C-b> <C-o>:make $(find src -name '*.java')<CR><CR>
endif
