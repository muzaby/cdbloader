"CLASS: SymbolLoader
"============================================================
let s:SymbolLoader = {}
let s:SymbolLoader.root = "/"
let s:SymbolLoader.prjroot = s:SymbolLoader.root
let s:SymbolLoader.dbscript = "mksymbols.sh"
let s:SymbolLoader.ctagsfile = "tags"
let s:SymbolLoader.cscopefile = "cscope.out"
let g:SLoader = s:SymbolLoader

" Shortcut
" <Ctrl> + <F> : executes command 'cs find c' with function name under the cursor
nmap <C-F> <ESC>:call g:SLoader.CSFindC()<CR>
" <F5> : re-generates files both of ctags and cscope
nmap <F5> <ESC>:call g:SLoader.Refresh()<CR>

function! s:SymbolLoader.GetProjectRoot()
    if self.prjroot != self.root
        return self.prjroot
    endif
    let workdir = getcwd()
    let here = getcwd()
    while here != self.root
        if filereadable(self.dbscript)
            let self.prjroot = here
            break
        endif
        exe "cd .."
        let here = getcwd()
    endwhile
    exe "cd " . workdir
    return self.prjroot
endfunction

function! s:SymbolLoader.CSFindC()
    let workdir = getcwd()
    let prjroot = self.GetProjectRoot()
    if prjroot != self.root
        let wordUnderCursor = expand("<cword>")
        exe "cd " . prjroot
        exe "cs find c " . wordUnderCursor
        exe "cd " . workdir
    else
        echo "Cannot find project home!"
    endif
endfunction

function! s:SymbolLoader.Refresh()
    let workdir = getcwd()
    let prjroot = self.GetProjectRoot()
    if prjroot != self.root
        exe "cd " . prjroot
        exe "!./" . self.dbscript
        exe "cd " . workdir
        call self.Init()
    else
        echo "Cannot find project home!"
    endif
endfunction

function! s:SymbolLoader.Init()
    let workdir = getcwd()
    let prjroot = self.GetProjectRoot()
    if prjroot != self.root
        exe "cd " . prjroot
        if filereadable(self.ctagsfile)
            exe "set tags+=" . prjroot . "/" . self.ctagsfile
        endif
        if filereadable(self.cscopefile)
            exe "cs add " . prjroot . "/" . self.cscopefile
        endif
        exe "cd " . workdir
    endif
endfunction
call s:SymbolLoader.Init()
