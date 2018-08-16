if !filereadable('Makefile')
	compiler gcc
	set makeprg=g++\ -o\ %<\ %
endif
