compiler javac

if filereadable('build.gradle')
	compiler gradle
	inoremap <C-b> <C-o>:make build<CR>
	nnoremap <C-b> :make build<CR>

	command! -bar -bang Build if <bang>0 || len(filter(getbufinfo(), 'v:val.changed')) == 0
				\ | 	make build
				\ | else
				\ | 	echoerr "There are unsaved files"
				\ | endif

	command! -bar Run make run
elseif isdirectory('bin') && isdirectory('src')
	set makeprg=javac\ -d\ bin\ $(find\ src\ -name\ '*.java')
	noremap <C-b> :make<CR>
	inoremap <C-b> <C-o>:make<CR>

	command! -bar -bang Build if <bang>0 || len(filter(getbufinfo(), 'v:val.changed')) == 0
				\ | 	make
				\ | else
				\ | 	echoerr "There are unsaved files"
				\ | endif

	command! -bar -nargs=1 -complete=custom,<SID>completeClass Run silent! !(cd bin; java <args>)
endif

if !exists('g:loaded_java') || !g:loaded_java
	let g:loaded_java = 1

	function! s:completePackage(argLead, cmdLine, curPos)
		let packages = split(system('ctags -R --java-kinds=p -f - src'), "\n")
		let packages = map(packages, 'matchstr(v:val, ''\(package \)\@<=.\{-}\(;\$\)\@='')')
		let packages = uniq(sort(packages))
		return join(packages, ".\n").'.'
	endfunction

	function! s:completeClass(argLead, cmdLine, curPos)
		let classes = []
		for file in globpath('src', '**/*.java', 0, 1)
			let package = matchstr(system('ctags --java-kinds=p -f - '.file),  '\(package \)\@<=.\{-}\(;\)\@=')
			if !empty(package)
				let package.='.'
			endif

			for line in split(system('ctags --java-kinds=c -f - '.file), "\n")
				call add(classes, package.matchstr(line, '\(class \)\@<=.\{-}\( {\)\@='))
			endfor
		endfor
		return join(classes, "\n")
	endfunction

	function! s:addClass(classname)
		let path = substitute(a:classname, '\.', '/', 'g').'.java'
		let dir = fnamemodify(path, ':h')
		if !isdirectory(dir)
			call system('mkdir -p src/main/java/'.dir)
		endif
		exe 'e src/main/java/'.path
		let sepIdx = strridx(a:classname, '.')
		let package = a:classname[0:sepIdx-1]
		let name = a:classname[sepIdx:]
		call setline(1, 'package '.package.';')
		call append(line('$'), '')
		call cursor('$', 1)
	endfunction

	command! -nargs=1 -complete=custom,<SID>completePackage AddClass silent! call s:addClass(<q-args>)
endif
