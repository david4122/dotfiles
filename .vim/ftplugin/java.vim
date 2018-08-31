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

if !exists('g:loaded_java') || !g:loaded_java
	let g:loaded_java = 1

	function! s:getPackage(buf)
		for line in getbufline(a:buf, 1, '$')
			let package = matchstr(line, '\(package \)\@<=.\{-}\(;\)\@=')
			if !empty(package)
				return package
			endif
		endfor
		return ''
	endfunction

	function! s:completePackage(argLead, cmdLine, curPos)
		let packages = []
		for buf in map(filter(getbufinfo({'buflisted': 1}), 'v:val.name =~ ".java$"'), 'v:val.bufnr')
			let package = <SID>getPackage(buf)
			if !empty(package)
				call add(packages, package)
			endif
		endfor
		return join(packages, ".\n")."."
	endfunction

	function! s:addClass(classname)
		exe "e src/main/java/".substitute(a:classname, '\.', '/', 'g').'.java'
		let sepIdx = strridx(a:classname, '.')
		let package = a:classname[0:sepIdx-1]
		let name = a:classname[sepIdx:]
		call setline(1, 'package '.package.';')
		call append(line('$'), '')
		call cursor('$', 1)
	endfunction

	command! -nargs=1 -complete=custom,<SID>completePackage AddClass call s:addClass(<q-args>)
endif
