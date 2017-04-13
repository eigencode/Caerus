set nocompatible
" 20170412.155855.vimrc4me.vim
" this only does something significant if verbose is set
"
let verbosefilename = strftime("%Y%m%d%H%M%S") . '.vim.verbosefile.log'
let set_verbosefile = "set verbosefile=" . $TEMP . "/" . verbosefilename
execute set_verbosefile 
"
"
"
set background=dark
set backup
set diffopt=iwhite,vertical,icase,filler,context:20000
set diffopt=vertical,icase,filler,context:20000
set foldmethod=marker
set foldenable
set ignorecase
set laststatus=2
set nocompatible
set expandtab
set smarttab
set nohlsearch
set noincsearch
set nowrap
set nowrapscan
set number
set ruler
set shiftwidth=4
set smarttab
set tabstop=4
set writebackup
if v:version >= 800
    set shortmess=F
else
    set shortmess=a
endif
set sidescroll=1
set noequalalways
set eol
execute pathogen#infect()
"
" MAKE BACKSPACE BEHAVE PROPERLY
"
set backspace=indent,eol,start

colorscheme koehler
source $VIM/$vimversion/syntax/syntax.vim
"
"
" Disable anoying screen beeb
"
set visualbell
set noerrorbells

"
" DO NOT WRITE MODIFIED BUFFER IF IT IS ABOUT TO LOSE ITZ BUFFER
"
set noautowriteall
"
" I  want to load unicode/utf-8  text automagically
" I  am pretty sure these 4 lines are  all that  is needed
"
set encoding=utf8
set fileencodings=ucs-bom,utf-8,latin1
setglobal fileencoding=utf-8
setglobal bomb
filetype plugin indent on
let g:go_list_type = "quickfix"

if has("win32")
    set guifont=Consolas:h14:cANSI
endif
if has("unix")
    set guifont=Liberation\ Mono\ Bold\ 15
endif

let g:vbkdir =  $HOME . '/vimbk'
if "" != $VIMBACKUPDIR
    let g:vbkdir =  $VIMBACKUPDIR
endif
let vbksuccess = 1
if !isdirectory(g:vbkdir)
    try
        call mkdir(g:vbkdir)
    catch
        echoerr "** " . g:vbkdir . " DOES NOT EXIST AND I CANNOT CREATE IT. SO YOU ARE WORKING WITHOUT A BACKUP FILE **"
        let vbksuccess = 0
    endtry
endif

if 1 == vbksuccess
    let g:vswapdir =  g:vbkdir . '/swap'
    if "" != $VIMSWAPDIR
        let g:vswapdir =  $VIMSWAPDIR
    endif
    let vswapsuccess = 1
    if !isdirectory(g:vswapdir)
        try
            call mkdir(g:vswapdir)
        catch
            echoerr "** " . g:vswapdir . " DOES NOT EXIST AND I CANNOT CREATE IT. SO YOU ARE WORKING WITHOUT A BACKUP FILE **"
            let vswapsuccess = 0
        endtry
    endif
endif

if 1 == vbksuccess && 1 == vswapsuccess
    let setbackupdir      =  'set ' . 'backupdir='   .  g:vbkdir
    let setdirectory      =  'set ' . 'directory='   .  g:vswapdir  . '//'
    execute setbackupdir
    execute setdirectory
else
    set nowritebackup
    set nobackup
endif

let  g:asciiCReturn   =  nr2char( 0x000D )
let  g:asciiEscape    =  nr2char( 0x001B )
let  g:asciiCtrlW     =  nr2char( 0x0017 )
let  g:asciiCtrlA     =  nr2char( 0x0001 )

let  g:lParenAka      =  nr2char( 0x2039 )
let  g:lParenReal     =  nr2char( 0x0028 )

let  g:rParenAka      =  nr2char( 0x203A )
let  g:rParenReal     =  nr2char( 0x0029 )

let  g:spaceAka       =  nr2char( 0x2022 )
let  g:spaceReal      =  nr2char( 0x0020 )

let  g:commaAka       =  nr2char( 0x25BC )
let  g:commaReal      =  nr2char( 0x002C )

let  g:squotAka       =  nr2char( 0x25B2 )
let  g:squotReal      =  nr2char( 0x0027 )

let  g:uLsBrakAka     =  nr2char( 0x2264 )
let  g:uLsBrakReal    =  nr2char( 0x005B )

let  g:uRsBrakAka     =  nr2char( 0x2265 )
let  g:uRsBrakReal    =  nr2char( 0x005D )

let  g:uLcBrakAka     =  nr2char( 0x25C4 )
let  g:uLcBrakReal    =  nr2char( 0x007B )

let  g:uRcBrakAka     =  nr2char( 0x25BA )
let  g:uRcBrakReal    =  nr2char( 0x007D )

let  g:lParenAkaRE    =  '[' . g:lParenAka  . ']'
let  g:rParenAkaRE    =  '[' . g:rParenAka  . ']'
let  g:spaceAkaRE     =  '[' . g:spaceAka   . ']'
let  g:squotAkaRE     =  '[' . g:squotAka   . ']'
let  g:commaAkaRE     =  '[' . g:commaAka   . ']'
let  g:uLsBrakAkaRE   =  '[' . g:uLsBrakAka . ']'
let  g:uRsBrakAkaRE   =  '[' . g:uRsBrakAka . ']'
let  g:uLcBrakAkaRE   =  '[' . g:uLcBrakAka . ']'
let  g:uRcBrakAkaRE   =  '[' . g:uRcBrakAka . ']'

let  s:rgx4tmpfx = '\v^((\d){14}[.])(([0-9a-fA-F]){4})(.+)'
let  g:xFormMatrix =
     \ [
     \         [ g:lParenReal,      g:lParenAka,        g:lParenAkaRE   ] ,
     \         [ g:rParenReal,      g:rParenAka,        g:rParenAkaRE   ] ,
     \         [ g:spaceReal,       g:spaceAka,         g:spaceAkaRE    ] ,
     \         [ g:commaReal,       g:commaAka,         g:commaAkaRE    ] ,
     \         [ g:squotReal,       g:squotAka,         g:squotAkaRE    ] ,
     \         [ g:uLsBrakReal,     g:uLsBrakAka,       g:uLsBrakAkaRE  ] ,
     \         [ g:uRsBrakReal,     g:uRsBrakAka,       g:uRsBrakAkaRE  ] ,
     \         [ g:uLcBrakReal,     g:uLcBrakAka,       g:uLcBrakAkaRE  ] ,
     \         [ g:uRcBrakReal,     g:uRcBrakAka,       g:uRcBrakAkaRE  ] ,
     \ ]

autocmd BufWritePost * call BufWritePost()
autocmd BufwritePre * call BufwritePre()
autocmd BufReadPost * call BufReadPost()
autocmd FocusGained,BufRead,BufNew * call CheckFullname()
autocmd BufRead *.daolatem call Loadmetafile()

highlight folded guibg=black guifg=cyan gui=bold

syntax off
highlight Normal ctermbg=black ctermfg=green guibg=black guifg=white
highlight LineNr guifg=white
highlight LineNr guifg=yellow
highlight LineNr term=NONE
highlight String term=NONE
highlight Number term=NONE
highlight PreProc term=NONE
highlight Function term=NONE
if &t_Co
    syntax enable
endif
"
" update syntax highlighting
"
let at_s_string = g:asciiEscape
    \ . ":doautocmd BufRead"
    \ . g:asciiCReturn
let @s = at_s_string
"
let at_t_string = g:asciiEscape
    \ . ":call Tmpfilesave()"
    \ . g:asciiCReturn
let @t = at_t_string
"
"
let map4f3seq = 'map <F3> ' . g:asciiEscape . ':cnext' . g:asciiCReturn . 'zz'
execute map4f3seq
"
let map4sf3seq = 'map <S-F3> '
    \ . g:asciiEscape
    \ . ':cprevious'
    \ . g:asciiCReturn
    \ . 'zz'
execute map4sf3seq
"
let map4cf3seq = 'map <C-F3> '
    \ . g:asciiEscape
    \ . ':vimgrep ///g **/*'
    \ . g:asciiCReturn
    \ . 'zz'
execute map4cf3seq
"
let map4cFCseq = 'map <C-F12> '
    \ . g:asciiEscape
    \ . ':call Toggleunicode()'
    \ . g:asciiCReturn
execute map4cFCseq
"
let map4cFBseq = 'map <C-F11> '
    \ . g:asciiEscape
    \ . ':call Chreko()'
    \ . g:asciiCReturn
execute map4cFBseq
"
let map4sFBseq = 'map <s-F11> '
    \ . g:asciiEscape
    \ . ':call LoadAKAfile()'
    \ . g:asciiCReturn
execute map4sFBseq
"
let map4sF9seq = 'map <S-F9> '
    \ . g:asciiEscape
    \ . ':bdelete!'
    \ . g:asciiCReturn
execute map4sF9seq
"
let map4F5seq = 'map <F5> @f'
execute map4F5seq
"
let map4cF5seq = 'map <C-F5> '
    \ . g:asciiEscape
    \ . ':call ToqTrim()'
    \ . g:asciiCReturn
execute map4cF5seq
"
let map4cF4seq = 'map <C-F4> '
    \ . g:asciiEscape
    \ . ':call Trimsrch()'
    \ . g:asciiCReturn
execute map4cF4seq
"
" let @c='1G:hi Folded guibg=black guifg=cyan gui=bold:set foldmethod=markerznzNzM'
let at_c_string = g:asciiEscape
    \ . 'gg'
    \ . ':hi Folded '
    \ . 'guibg=black '
    \ . 'guifg=cyan '
    \ . 'gui=bold'
    \ . g:asciiCReturn
    \ . ':set foldmethod=marker'
    \ . g:asciiCReturn
    \ . 'znzNzM'

" let @d='v:b2:diffthis:diffthisgg]c'
let at_d_string = g:asciiEscape
    \ . g:asciiCtrlW
    \ . 'v'
    \ . ':b2'
    \ . g:asciiCReturn
    \ . ':diffthis'
    \ . g:asciiCReturn
    \ . g:asciiCtrlW
    \ . g:asciiCtrlW
    \ . ':diffthis'
    \ . g:asciiCReturn
    \ . 'gg]c'

" let @x="/^submenuma$%mb:'a,'bs/\\v^(.)/#\\1/`b$"
let at_x_string = g:asciiEscape
    \ . '/^submenu'
    \ . g:asciiCReturn
    \ . 'ma$%mb'
    \ . ":'a,'bs/\\v^(.)/#\\1/"
    \ . g:asciiCReturn
    \ . '`b$'

let @c = at_c_string
let @d = at_d_string
let @x = at_x_string
"
" FUNCTION KEY MAPPING /*{{{*/
"
"
map <f1> @a
map <f2> @s
map <f3> @d
map <f4> @f
map <f5> @g
map <f6> @h
map <f7> @j
map <f8> @k
map <f9> @l
map <f10> @z
map <f11> @x
map <f12> @c
"
"
"/*}}}*/


function BufReadPost()
  let &modifiable = !&readonly
  return 0
endfunction

function BufWritePost()
    let b:src = g:vbkdir . '/' . b:bktempfile
    let b:dst = g:vbkdir . '/' . b:backupfile
    if filereadable(b:src)
        if 0 == rename(b:src, b:dst)
            let msg = b:tstamp . " :   BUFNAME: " . bufname("%")
            echom msg
            let msg = b:tstamp . " :    BACKUP: " . b:backupfile
            echom msg
            let msg = b:tstamp . " :WRITTEN TO: " . g:vbkdir . " DIRECTORY"
            echom msg
        else
            let msg = "**ERROR rename(" . b:src ","  . b:dst ") ] FAILED**"
            echom msg
        endif
    endif
endfunction

function RandomX32()
    if has("win32")
        let syscmdstr = 'powershell -noprofile -command "Get-Random -maximum 0x7FFFFFFF"'
        let decvalue = substitute(system(syscmdstr),'\n','','')
        let hexvalue = printf('%08X', decvalue)
        return hexvalue
    endif
    if has("unix")
        let syscmdstr = "xxd -l 4 -p /dev/urandom"
        return toupper(substitute(system(syscmdstr),'\n','',''))
    endif
endfunction

function RandomX16()
    if has("win32")
        let syscmdstr = 'powershell -noprofile -command "Get-Random -maximum 0xFFFF"'
        let decvalue = substitute(system(syscmdstr),'\n','','')
        let hexvalue = printf('%04X', decvalue)
        return hexvalue
    endif
    if has("unix")
        let syscmdstr = "xxd -l 2 -p /dev/urandom"
        return toupper(substitute(system(syscmdstr),'\n','',''))
    endif
endfunction

function BufwritePre()
    let b:tstamp = strftime("%Y%m%d%H%M%S")
    let b:fstamp = b:tstamp . '.' . RandomX16()
    let &backupext = '.' . b:fstamp
    let b:basename = expand("%:t")
    let b:bktempfile = b:basename . &backupext
    let b:separator = '.'
    if "." == matchstr(b:basename, '^[.]')
        let b:separator = ''
    endif
    if "" != matchstr(b:basename,s:rgx4tmpfx)
        let b:hvsn = substitute(b:basename,s:rgx4tmpfx,'\3','')
        let b:nvsn = (1 + str2nr(b:hvsn,16)) % 0x10000
        let b:hvsn = printf("%04X", b:nvsn)
        let b:backupfile = substitute(b:basename,s:rgx4tmpfx,'\1' . b:hvsn . '\5','')
    else
        let b:backupfile = b:fstamp . b:separator . b:basename
    endif
endfunction

function Tsav()
    let cmd = "saveas /tmp/TX" . localtime() . "XT.txt"
    execute cmd
endfunction

function Tmpfilesave()
    set fileformat=unix
    let fname = g:vbkdir . "/TX"
    let fname = fname . strftime("%Y%m%d%H%M%S")
    let fname = fname . 'XT.txt'
    let cmd =  'saveas ' . fname
    execute cmd
endfunction


function Flowfixpgf()
    execute '%s/\v[\n\r]{2,}/' . g:asciiCtrlA . '/ge'
    execute '%s/\v[\n\r]/ /ge'
    execute '%s/' . g:asciiCtrlA . '/\r\r/ge'
    execute '%s/\v^\s+//ge'
endfunction


function PrepColumns()
    let cmd = 'silent %s/\v^([^'
    \ . g:asciiCtrlA
    \ . ']+'
    \ . g:asciiCtrlA
    \ . ')[^'
    \ . g:asciiCtrlA
    \ . ']+'
    \ . g:asciiCtrlA
    \ . '/\1/'
    execute cmd

    let cmd = 'silent %s/\v^(.D'
    \ . g:asciiCtrlA
    \ . ')(([^'
    \ . g:asciiCtrlA
    \ . ']+'
    \ . g:asciiCtrlA
    \ . '){2})(\d{12}'
    \ . g:asciiCtrlA
    \ . ')/\1\2000000000000'
    \ . g:asciiCtrlA
    \ . '/'
    execute cmd
endfunction

function BuildExclusionPattern()
    let exclusions =
    \ [
    \   'wsqisqpx.default',
    \   'Windows.Prefetch',
    \   'Windows.SoftwareDistribution',
    \   'Users.ksk.AppData.Roaming',
    \   'Windows.Temporary.Internet.Files',
    \   ':..Recycle.Bin',
    \   ':.ProgramData.Microsoft.Antimalware',
    \   ':.ProgramData.Microsoft.Microsoft.Antimalware',
    \   'Microsoft.CryptnetUrlCache',
    \   'Google.Chrome.User.Data.Default',
    \   'Local.Microsoft.Windows.History',
    \   'Microsoft.Windows.PowerShell.CommandAnalysis'
    \ ]
    let idx = 1
    let limit = len( exclusions )
    let searchPattern = '(' . exclusions[ 0 ] . ')'
    while idx < limit
        let searchPattern = searchPattern . '|' . exclusions[ idx ]
        let idx = idx + 1
    endwhile
    echo searchPattern
    return searchPattern
endfunction

function PrepToc4diff()
    call PrepColumns()
"   let bigPattern = BuildExclusionPattern()
"   execute 'silent g/\v' . bigPattern . '/d'
    execute 'silent g/Windows.Prefetch/d'
    execute 'silent g/Windows.SoftwareDistribution/d'
    execute 'silent g/Users.ksk.AppData.Roaming/d'
    execute 'silent g/Windows.Temporary.Internet.Files/d'
    execute 'silent g/:..Recycle.Bin/d'
    execute 'silent g/:.ProgramData.Microsoft.Antimalware/d'
    execute 'silent g/:.ProgramData.Microsoft.Microsoft.Antimalware/d'
    execute 'silent g/Microsoft.CryptnetUrlCache/d'
    execute 'silent g/Google.Chrome.User.Data.Default/d'
    execute 'silent g/Local.Microsoft.Windows.History/d'
    execute 'silent g/Microsoft.Windows.PowerShell.CommandAnalysis/d'
    execute 1
endfunction

function InsertBlankLine()
     "
     " insert blank line at beginning        of buffer
     "
     1 yank
     0 put
     s/\v^.*$//
endfunction
"
function Chreko()
     let c2e01 = g:lParenAka . g:spaceAka . g:rParenAka
     let line = getline( '.' )
     let line = line . c2e01
     call setline( '.', line )
endfunction

function Stringreverse( text )
     let inputstr = a:text
     "
     " string to list
     "
     let inputlist = split( inputstr, '\zs' )
     "
     " reverse the list
     "
     let outputlist = reverse( inputlist )
     "
     " list to string
     "
     let outputstring = join( outputlist, '' )
     "
     " send it home
     "
     return outputstring
endfunction

function Lineright()
     "
     " get the right side (of      the cursor) piece of the line where
     " the cursor resides
     "
     let   line = getline( '.' )
     let   rightside = strpart( line, col( '.' ), strlen( line ) - 1 )
     return rightside
endfunction

function Lineleft()
     "
     " get the left side (of the cursor) piece of the line where
     " the cursor resides and reverse it
     "
     let line = getline( '.' )
     let leftside = strpart( line, 0, col( '.' ) )
     let  leftsideprime = stringreverse( leftside )
     return leftsideprime
endfunction

function Getfilestring()
     "
     " leftside will come back  reversed
     "
     let leftside = Lineleft()
     let rightside = Lineright()
     "
     " get all non whitespace to the right
     "
     let  filestringright = matchstr( rightside, '\v^\S+' )
     "
     " get all non whitespace to the left
     "
     let  filestringleft = Stringreverse( matchstr( leftside, '\v^\S+' ) )
     "
     " re-assemble the string I just extracted
     "
     let  filestring = filestringleft . filestringright
     "
     "  in powershell I remove whitespace/parens from filenames
     "  so that I can easily parse filenames and also clip them
     "  from the console easily.
     "
     "  fix all those nasty character substitutions that I did
     "  so that the returned filename is in the original form
     "  with real space charactrs and real parens
     "
     for xForm in g:xFormMatrix
        let filestring    =  substitute(  filestring,   xForm[2], xForm[0],  'g' )
     endfor

     return filestring
endfunction

function LoadAKAfile()
     let file2try = Getfilestring()
     let cmd = 'e ' . file2try
     execute cmd
endfunction

function ToggleUnicode()
     let refreshscreen = 'e'
     if "ucs-2" == &encoding
         set encoding=latin1
     else
         set encoding=ucs-2
     endif
     execute refreshscreen
endfunction

function CheckFullname()
    if 'cdiary.txt' == expand('%:t')
        set syntax=fortran
        set autoread
        set noreadonly
        set modifiable
        execute 'silent! %s/$//'
        set readonly
        set nomodifiable
    endif
endfunction

function Loadmetafile()
     "
     " assume a file with the current directory name as line 1
     " and all the files that the vim invocation wants to load
     " in the remaining lines. One file per line.
     "
     let changeset =
     \ [
     \         [ '^Microsoft[.]PowerShell[.]Core/FileSystem::', '' ] ,
     \         [ '^Env:/\s*$', '.' ]                                 ,
     \ ]

     "
     " Powershell places various adornments on filenames...
     " ...Nukeum
     "
     while len( changeset )
         let   changepair    =  changeset[ 0 ]
         let   pattern       =  changepair[ 0 ]
         let   replacement   =  changepair[ 1 ]
         let   fixup = join(   [ 'silent! %s-', pattern, '-', replacement, '-' ], '' )
         execute fixup
         "
         " after the last pair in the change set  is removed
         " from the list it will be empty and I will exit the loop
         "
         call remove( changeset, 0 )
     endwhile
     "
     " Create upper and lower window
     " to flip between as I load each file
     "
     let metaFileBufName = bufname("%")
     execute "setlocal bufhidden=hide"
     execute "setlocal buftype=nofile"
     execute "setlocal nobuflisted"
     execute "setlocal modifiable"
     set startofline
     split
     execute "goto 1"
     let workingdirectory = getline( "." )
     call setline( '.', '' )
     let nonBlankLineCount = 0
     for xForm in g:xFormMatrix
        let workingdirectory    =  substitute(  workingdirectory,   xForm[2], xForm[0],  'g' )
     endfor

     try
         execute "cd " . workingdirectory
         "
         " Specify pattern for non-blank line
         "
         let pattern = '\v^\S.*$'
         while 0 < search( pattern, 'W' )
             "
             " Found another non-blank line
             "
             let nonBlankLineCount = 1 + nonBlankLineCount
             let filestring = getline( "." )
             for xForm in g:xFormMatrix
                let filestring = substitute(  filestring,   xForm[2], xForm[0],  'g' )
             endfor
             wincmd w
             filetype plugin on
             execute "edit " . filestring
             doautocmd BufRead
             wincmd w
         endwhile
         wincmd c
     catch 
         wincmd c
         setlocal wrap
         let errMsg = printf("**ERROR: [ %s ] cd %s FAILED**", v:exception, workingdirectory)
         execute "$"
         yank
         put
         call setline( '.', '' )
         yank
         put
         call setline( '.', errMsg )
         echoerr errMsg
     endtry
     if 0 == nonBlankLineCount
        split
        wincmd n
        wincmd o
     endif
     return 0
endfunction

function Publish()
     syntax off
     highlight LineNr guifg=white
     :so $VIMRUNTIME/syntax/2html.vim
endfunction

function Trimsrch()
 :%s/\v^\S+:(.\a\s)(\S{4})(\s\d{8}[.]\d{6}\s)((\S){12}\s)/\1\3/c
endfunction

function ToqTrim()
 :%s/\v^(.\a\s)(\S{4}\s)(\d{8}[.]\d{6}\s)((\S){12}\s)/\1\3/c
endfunction

function Fixgrubcfg()
     :%s/\v^(menuentry\s+)('Windows Boot.+sda2.')/\1'DESALES_WINX'/e
     :%s/\v^(menuentry\s+)('Windows Boot.+sdb1.')/\1'AZARIAH_WINX'/e
     :%s/\v^(menuentry\s+)(\SCentOS[^']+')/\1'AZARIAH_CENTOS'/e
     :%s/\v^(menuentry\s+)(\SUbuntu[^']+')/\1'AZARIAH_UBUNTU'/e
     :%s/\v^(menuentry\s+)(\SLMDE[^']+')/\1'AZARIAH_LMDE'/e
     :%s/\v^(menuentry\s+)(\SopenSUSE[^']+')/\1'DESALES_BOOTMGR'/e
     while 0 < search( '^submenu' )
        :1
        :execute 'normal /^submenu'
        \ . g:asciiCReturn
        \ . "ma$%mb:'a,'bs/\\v^(.)/#\\1/"
        \ . g:asciiCReturn
        \ . '`b$'
     endwhile
endfunction

function Filesonly()
    execute '%s,\v.{-}([^/]+)$,\1,c'
endfunction

if "" != matchstr(v:progname , '^gvim')
    syntax enable
endif
