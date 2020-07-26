" slimv-scheme.vim:
"               Scheme filetype plugin for Slimv
" Version:      0.9.13
" Last Change:  04 May 2014
" Maintainer:   Tamas Kovacs <kovisoft at gmail dot com>
" License:      This file is placed in the public domain.
"               No warranty, express or implied.
"               *** ***   Use At-Your-Own-Risk!   *** ***
"
" =====================================================================
"
"  Load Once:
if exists("b:did_ftplugin") || exists("g:slimv_disable_scheme")
    finish
endif

" ---------- Begin part loaded once ----------
if !exists( 'g:slimv_scheme_loaded' )

let g:slimv_scheme_loaded = 1

" Try to autodetect Scheme executable
" Returns list [Scheme executable, Scheme implementation]
function! SlimvAutodetect( preferred )
    " Currently only MIT Scheme on Linux
    if executable( 'scheme' )
        " MIT Scheme
        return ['scheme', 'mit']
    endif

    return ['', '']
endfunction

" Try to find out the Scheme implementation
function! SlimvImplementation()
    if exists( 'g:slimv_impl' ) && g:slimv_impl != ''
        " Return Lisp implementation if defined
        return tolower( g:slimv_impl )
    endif

    return 'mit'
endfunction

" Try to autodetect SWANK and build the command to load the SWANK server
function! SlimvSwankLoader()
    if g:slimv_impl == 'mit'
        if exists( 'g:scheme_builtin_swank' ) && g:scheme_builtin_swank
            " MIT Scheme contains a built-in swank server since version 9.1.1
            return 'scheme --eval "(let loop () (start-swank) (loop))"'
        endif
        let swanks = split( globpath( &runtimepath, 'slime/contrib/swank-mit-scheme.scm'), '\n' )
        if len( swanks ) == 0
            return ''
        endif
        return '"' . g:slimv_lisp . '" --load "' . swanks[0] . '"'
    endif
    return ''
endfunction

" Filetype specific initialization for the REPL buffer
function! SlimvInitRepl()
    set filetype=scheme
endfunction

" Lookup symbol in the Hyperspec
function! SlimvHyperspecLookupScheme( word, exact, all )
    " No Hyperspec support for Scheme at the moment
    let symbol = []
    if a:exact && exists( 'g:slimv_scheme_hs_root' )
        let symbol = [a:word, g:slimv_scheme_hs_root . a:word]
    endif
    return symbol
endfunction

" Source Slimv general part
runtime ftplugin/**/slimv.vim

endif "!exists( 'g:slimv_scheme_loaded' )
" ---------- End of part loaded once ----------

runtime! ftplugin/**/scheme.vim

" The balloonexpr of MIT-Scheme is broken. Disable it.
let g:slimv_balloon = 0

" The fuzzy completion of MIT-Scheme is broken. Disable it.
let g:slimv_simple_compl = 1

" Must be called for each lisp buffer
call SlimvInitBuffer()

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

