Set-StrictMode -Version Latest
$GLOBAL:ErrorActionPreference = "Inquire"   # Other setting == "SilentlyContinue"
$GLOBAL:DebugPreference = "Inquire"         # Other setting == "SilentlyContinue"
#------------------------------------------------------------------------------
# MAIN powershell profile module
#
# FOR nomad/triad
#
# Run...
#
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Remotesigned
#
# ...if powershell startup errors out of this script on a
# permission error. You do not need administrator priv to run...
#
#           set-executionpolicy -scope currentuser
#
# ...will solve the problem
#
#-----------------------------------------------------------------------------
#
# This module will take the place of $profile if
# you place the following lines in $profile ...
#
#           Set-StrictMode -Version 2
#
#           $d  = "\\$domainUsrDir"
#           $n  = $env:username
#           $m  = "$d\$n\powershell\pShellMain.psml"
#
#           if ( test-path $m -PathType leaf ) {
#               $GLOBAL:profilem = $m
#               import-Module $m
#           }
#
# ...the 'GLOBAL:' prefixes really are necessary where they are used.
# The advantage of using a module is that you are not at the mercy
# of Microsoft as to where the module lives. otoh your posh
# startup must be in the directory that $GLOBAL:profile resolves to.
# That directory probably has a space in its name. Enough said.
#
#-----------------------------------------------------------------------------
#
# =========================================================================
# \\$domainUsrDir\$uid\powershell\glblvbl.psml {{{
#
$GLOBAL:maximumHistorycount             =  32767
$GLOBAL:MaximumVariableCount            =  16383
$GLOBAL:FormatEnumerationLimit          =  64
#
# It is best never to overlook the importance of ASCII Codes
#
$GLOBAL:nullstr                         =  ""
$GLOBAL:dash                            =  [string][char][int]0x2d
$GLOBAL:slash                           =  [string][char][int]0x2f
$GLOBAL:backslash                       =  [string][char][int]0x5c
$GLOBAL:singlequote                     =  [string][char][int]0x27
$GLOBAL:doublequote                     =  [string][char][int]0x22
$GLOBAL:newline                         =  [string][char][int]0x0a
$GLOBAL:cReturn                         =  [string][char][int]0x0d
$GLOBAL:hTab                            =  [string][char][int]0x09
$GLOBAL:space                           =  [string][char][int]0x20
$GLOBAL:dollar                          =  [string][char][int]0x24
$GLOBAL:NAK                             =  [string][char][int]0x15
$GLOBAL:EOT                             =  [string][char][int]0x04
#
# there still remain some operations that are easier in COM than anywhere else
#
$GLOBAL:fso                          =   New-Object -com scripting.filesystemobject
$GLOBAL:wshell                       =   New-Object -com WScript.shell
$GLOBAL:pVerifiedS                   =   $null
$GLOBAL:pVerifiedL                   =   $null
#
# More explicit global defs are required in a module than in...
#
# \\$domainUsrDir\$uid\My Documents\windowsPowerShell\Microsoft.PowerShell_profile.ps1
#
# ...I don't like it. But, I think I`m gonna have to live with it.
#
$GLOBAL:GVtsprefix                    = $nullstr
$GLOBAL:uid                           = $env:username
$GLOBAL:folderHash                    = @{}
$GLOBAL:pathCache                     = @{}
$GLOBAL:abw                           = $null
$GLOBAL:abwL                          = $null
$GLOBAL:bin                           = $null
$GLOBAL:binL                          = $null
$GLOBAL:sqlite                        = $null
$GLOBAL:sqliteL                       = $null
$GLOBAL:bjPath                        = $null
$GLOBAL:bzipexe                       = $null
$GLOBAL:cdJournal                     = $null
$GLOBAL:cdTrail                       = $null
$GLOBAL:cmdHistoryLclD                = $null
$GLOBAL:cmdHistoryNetD                = $null
$GLOBAL:cmdHistoryTmpD                = $null
$GLOBAL:consoleTitleMode              = $null
$GLOBAL:crunchyvim                    = $null
$GLOBAL:crunchyvimexe                 = $null
$GLOBAL:din                           = $null
$GLOBAL:dinL                          = $null
$GLOBAL:docset                        = $null
$GLOBAL:docsetL                       = $null
$GLOBAL:dyd                           = $null
$GLOBAL:dydL                          = $null
$GLOBAL:eclipseDir                    = $null
$GLOBAL:eclipseimage                  = $null
$GLOBAL:eclipsevm                     = $null
$GLOBAL:eclipsevmexe                  = $null
$GLOBAL:expiredFiles                  = $null
$GLOBAL:ekd                           = $null
$GLOBAL:ekdL                          = $null
$GLOBAL:fileServer                    = $null
$GLOBAL:getLocationRE                 = $null
$GLOBAL:getLongNameRE                 = $null
$GLOBAL:getPSPathRE                   = $null
$GLOBAL:git                           = $null
$GLOBAL:gitL                          = $null
$GLOBAL:gooeyvim                      = $null
$GLOBAL:gooeyvimexe                   = $null
$GLOBAL:hDriveMountPt                 = $null
$GLOBAL:hostfile                      = $null
$GLOBAL:homeLcl                       = $null
$GLOBAL:homeLclDsk                    = $null
$GLOBAL:homeNet                       = $null
$GLOBAL:include                       = $null
$GLOBAL:includeL                      = $null
$GLOBAL:initialDirectory              = $null
$GLOBAL:j7d                           = $null
$GLOBAL:j7dL                          = $null
$GLOBAL:lib                           = $null
$GLOBAL:libL                          = $null
$GLOBAL:libpath                       = $null
$GLOBAL:libpathL                      = $null
$GLOBAL:lmportrt0Path                 = $null
$GLOBAL:localhost                     = $null
$GLOBAL:mgw                           = $null
$GLOBAL:mgwL                          = $null
$GLOBAL:netLcl                        = $null
$GLOBAL:netLclDsk                     = $null
$GLOBAL:notAfileSystemRE              = $null
$GLOBAL:oslcPath                      = $null
$GLOBAL:path                          = $null
$GLOBAL:pathL                         = $null
$GLOBAL:PERL5LIB                      = $null
$GLOBAL:PERL5LIBL                     = $null
$GLOBAL:PYTHONPATH                    = $null
$GLOBAL:PYTHONPATHL                   = $null
$GLOBAL:pfd                           = $null
$GLOBAL:pfdL                          = $null
$GLOBAL:pfx                           = $null
$GLOBAL:pfxL                          = $null
$GLOBAL:clPath                        = $null
$GLOBAL:pkPath                        = $null
$GLOBAL:psprofilBkLclD                = $null
$GLOBAL:psprofilBkNetD                = $null
$GLOBAL:pyd                           = $null
$GLOBAL:pydL                          = $null
$GLOBAL:rt1DevPath                    = $null
$GLOBAL:rt1ForceActive                = $null
$GLOBAL:rt1Path                       = $null
$GLOBAL:sambahost                     = $null
$GLOBAL:sby                           = $null
$GLOBAL:sbyL                          = $null
$GLOBAL:spc                           = $null
$GLOBAL:spcL                          = $null
$GLOBAL:sqlCmdDir                     = $null
$GLOBAL:sys32                         = $null
$GLOBAL:sys32L                        = $null
$GLOBAL:sys64                         = $null
$GLOBAL:sys64L                        = $null
$GLOBAL:sysInternals                  = $null
$GLOBAL:transcriptdir                 = $null
$GLOBAL:tStampRE                      = $null
$GLOBAL:tStemplate                    = $null
$GLOBAL:tulavnecot                    = $null
$GLOBAL:vim                           = $null
$GLOBAL:vimL                          = $null
$GLOBAL:vimBk                         = $null
$GLOBAL:vimBkL                        = $null
$GLOBAL:vimBackupDir                  = $null
$GLOBAL:vimBackupDirL                 = $null
$GLOBAL:vimLcl                        = $null
$GLOBAL:vimLclL                       = $null
$GLOBAL:vimprofile                    = $null
$GLOBAL:vimprofileL                   = $null
$GLOBAL:vimProfileDir                 = $null
$GLOBAL:vimProfileLclD                = $null
$GLOBAL:vimProfileNetD                = $null
$GLOBAL:vimprofold                    = $null
$GLOBAL:vimrc_base_name               = $null
$GLOBAL:vimrc_base_old                = $null
$GLOBAL:vimruntime                    = $null
$GLOBAL:vvvIsVerbose                  = $null
$GLOBAL:win                           = $null
$GLOBAL:winL                          = $null
$GLOBAL:dbx                           = $null
$GLOBAL:dbxL                          = $null
$GLOBAL:loh                           = $null
$GLOBAL:lohL                          = $null
$GLOBAL:JAVA_HOME                     = $null
$GLOBAL:JRE_H0ME                      = $null
$GLOBAL:JAVA_HOME                     = $null
$GLOBAL:JRE8_64                       = $null
$GLOBAL:JRE7_64                       = $null
$GLOBAL:ECLIPSE_HOME                  = $null
$GLOBAL:SMARTGIT_JAVA_HOME            = $null
$GLOBAL:ekd                           = $null
$GLOBAL:adb                           = $null
$GLOBAL:xbn                           = $null
#
#
# set up regular expressions and substitutions to manage
# space embeded pathnames from the command-line with a bit
# more convenience
#
$GLOBAL:uComma                          = [string][char][int] 0x002C
$GLOBAL:uComma_re                       = [regex] '(?six: \u002C )'
$GLOBAL:uCommaAKA                       = [string][char][int] 0x25BC
$GLOBAL:uCommaAKA_re                    = [regex] '(?six: \u25BC )'

$GLOBAL:uSQuote                         = [string][char][int] 0x0027
$GLOBAL:uSQuote_re                      = [regex] '(?six: \u0027 )'
$GLOBAL:uSQuoteAKA                      = [string][char][int] 0x25B2
$GLOBAL:uSQuoteAKA_re                   = [regex] '(?six: \u25B2 )'

$GLOBAL:uSpace                          = [string][char][int] 0x0020
$GLOBAL:uSpace_re                       = [regex] '(?six: \u0020 )'
$GLOBAL:uSpaceAKA                       = [string][char][int] 0x2022
$GLOBAL:uSpaceAKA_re                    = [regex] '(?six: \u2022 )'

$GLOBAL:uLparen                         = [string][char][int] 0x0028
$GLOBAL:uLparen_re                      = [regex] '(?six: \u0028 )'
$GLOBAL:uLparenAKA                      = [string][char][int] 0x2039
$GLOBAL:uLparenAKA_re                   = [regex] '(?six: \u2039 )'

$GLOBAL:uRparen                         = [string][char][int] 0x0029
$GLOBAL:uRparen_re                      = [regex] '(?six: \u0029 )'
$GLOBAL:uRparenAKA                      = [string][char][int] 0x203A
$GLOBAL:uRparenAKA_re                   = [regex] '(?six: \u203A )'

$GLOBAL:uLsBrak                         = [string][char][int] 0x005B
$GLOBAL:uLsBrak_re                      = [regex] '(?six: \u005B )'
$GLOBAL:uLsBrakAKA                      = [string][char][int] 0x2264
$GLOBAL:uLsBrakAKA_re                   = [regex] '(?six: \u2264 )'

$GLOBAL:uRsBrak                         = [string][char][int] 0x005D
$GLOBAL:uRsBrak_re                      = [regex] '(?six: \u005D )'
$GLOBAL:uRsBrakAKA                      = [string][char][int] 0x2265
$GLOBAL:uRsBrakAKA_re                   = [regex] '(?six: \u2265 )'

$GLOBAL:uLcBrak                         = [string][char][int] 0x007B
$GLOBAL:uLcBrak_re                      = [regex] '(?six: \u007B )'
$GLOBAL:uLcBrakAKA                      = [string][char][int] 0x25C4
$GLOBAL:uLcBrakAKA_re                   = [regex] '(?six: \u25C4 )'

$GLOBAL:uRcBrak                         = [string][char][int] 0x007D
$GLOBAL:uRcBrak_re                      = [regex] '(?six: \u007D )'
$GLOBAL:uRcBrakAKA                      = [string][char][int] 0x25BA
$GLOBAL:uRcBrakAKA_re                   = [regex] '(?six: \u25BA )'

$GLOBAL:uPound                         = [string][char][int] 0x0023
$GLOBAL:uPound_re                      = [regex] '(?six: \u0023 )'
$GLOBAL:uPoundAKA                      = [string][char][int] 0x2262
$GLOBAL:uPoundAKA_re                   = [regex] '(?six: \u2262 )'

#
# These regex transforms could be hard coded ( as in deSpaceEZ ).
# There are only 10. But then I would not have a working example
# of a posh loop through a 2 dimensional array. This, more general,
# solution will make it easy to move other troublesome characters
# out of the way.
#
$GLOBAL:chrAkaXform = ( 
    ( $uSpace_re,   $uSpaceAKA,   $uSpaceAKA_re,  $uSpace    ),
    ( $uComma_re,   $uCommaAKA,   $uCommaAKA_re,  $uComma    ),
    ( $uSQuote_re,  $uSQuoteAKA,  $uSQuoteAKA_re, $uSQuote   ),
    ( $uLparen_re,  $uLparenAKA,  $uLparenAKA_re, $uLparen   ),
    ( $uRparen_re,  $uRparenAKA,  $uRparenAKA_re, $uRparen   ),   
    ( $uLsBrak_re,  $uLsBrakAKA,  $uLsBrakAKA_re, $uLsBrak   ),
    ( $uRsBrak_re,  $uRsBrakAKA,  $uRsBrakAKA_re, $uRsBrak   ),   
    ( $uLcBrak_re,  $uLcBrakAKA,  $uLcBrakAKA_re, $uLcBrak   ),
    ( $uRcBrak_re,  $uRcBrakAKA,  $uRcBrakAKA_re, $uRcBrak   ),   
    ( $uPound_re,   $uPoundAKA,   $uPoundAKA_re,  $uPound    )   
)

$GLOBAL:regx2aka = @"
    (?six:  $uSpace_re      | 
            $uComma_re      | 
            $uSQuote_re     | 
            $uLparen_re     | 
            $uRparen_re     |
            $uLsBrak_re     | 
            $uRsBrak_re     |
            $uLcBrak_re     | 
            $uRcBrak_re     |
            $uPound_re      )

"@
$GLOBAL:regx2aka = [regex]$regx2aka.trim()

$GLOBAL:regx2org = @"
    (?six:  $uSpaceAKA_re   |
            $uCommaAKA_re   |
            $uSQuoteAKA_re  |
            $uLparenAKA_re  |
            $uRparenAKA_re  |
            $uLsBrakAKA_re  |
            $uRsBrakAKA_re  |
            $uLcBrakAKA_re  |
            $uRcBrakAKA_re  |
            $uPoundAKA_re   )
"@
$GLOBAL:regx2org = [regex]$regx2org.trim()

$GLOBAL:sowTypeAllowed = @"
    (?six: \A 
    (System[.]Array)                      |
    (System[.]String)                     |
    (System[.]Collections[.]ArrayList) \z )
"@
$GLOBAL:sowTypeAllowed = [regex]$sowTypeAllowed.trim()

$GLOBAL:LeadingWS = [regex] '(?six:  \A  \s+)'
$GLOBAL:TrailingWS = [regex] '(?six: \s+ \z )'
$GLOBAL:hostfile = "C:/Windows/system32/drivers/etc/hosts"
#
# }}}
# =========================================================================
#
# =========================================================================
# \\$domainUsrDir\$uid\powershen\akalist.psml {{{
#
Set-Alias   -scope global -name   alias         -value   "Get-Alias"
Set-Alias   -scope global -name   help          -value   "Get-Help"
Set-Alias   -scope global -name   gethelp       -value   "Get-Help"
Set-Alias   -scope global -name   gindstr       -value   "findstr"
set-Alias   -scope global -name   srt           -value   "sort.exe"
Set-Alias   -scope global -name   o2s           -value   "ostr"
Set-Alias   -scope global -name   search        -value   "Select-String"
Set-Alias   -scope global -name   sea           -value   "Select-String"
Set-Alias   -scope global -name   grepp         -value   "Select-String"
Set-Alias   -scope global -name   rtdsql        -value   "rdtsql"
Set-Alias   -scope global -name   rtdcq         -value   "rdtcq"
Set-Alias   -scope global -name   vf            -value   "setdir"
set-Alias   -scope global -name   xs            -value   "setdir"
Set-Alias   -scope global -name   cdd           -value   "setdir"
Set-Alias   -scope global -name   cd            -value   "setdir"         -force  -Option Allscope
Set-Alias   -scope global -name   diff          -value   "diff.exe"       -force  -Option Allscope
set-Alias   -scope global -name   wz            -value   "winzip32.exe"
Set-Alias   -scope global -name   so            -value   "Select-object"
Set-Alias   -scope global -name   cp            -value   "xcp"            -force  -Option Allscope
set-Alias   -scope global -name   rm            -value   "xrm"            -force  -Option Allscope
Set-Alias   -scope global -name   mv            -value   "xmv"            -force  -Option Allscope
Set-Alias   -scope global -name   gc            -value   "xgc"            -force  -Option Allscope
Set-Alias   -scope global -name   zz            -value   "7z.exe"         -force  -Option Allscope
Set-Alias   -scope global -name   ?             -value   "where.exe"      -force  -Option Allscope
#
# }}}
# =========================================================================
#
# =========================================================================
# \\$domainUsrDir\$uid\powershell\ezfunc.psml {{{
# =========================================================================
#
function ql { #{{{
     #
     # see section 7.1.2 (page 239)
     #
     #   of...
     #
     #   windows Powershell in Action, second Edition
     #   author BRUCE PAYETTE
     #   ISBN 9781935182139
     #
     # ...for a description of "function ql"
     $args
 } # }}}

function qs { #{{{
    #
    #  see section 7.1.2 (page 239)
    #
    #  of...
    #
    #  windows PowerSheil in Action, Second Edition
    #  author bruce payette
    #  ISBN 9781935182139
    #
    #  ...for a description of "function qs"
    "$args"
} # }}}

function buildKey { #{{{
      #
      #  this allows for a theoretical   maximum of
      #  10000 files loaded into a single vim session
      #
      "X" + "{0:D4}" -f $args[ 0 ]
} # }}}

function posh { #{{{
     #
     #  Command Line for windows
     #
     start-process C:/Windows/Syswow64/windowsPowerShell/v1.0/powershell.exe
} # }}}

function drives { # {{{
    Get-PSDrive -PSProvider FileSystem
} # }}}

function ShowErrorDetails { # {{{
    # see section 14.1.1 (page 559)
    #
    #   of...
    #
    #   windows Powershell in Action, second Edition
    #   author BRUCE PAYETTE
    #   ISBN 9781935182139
    #
    # ...for a description of "function ShowErrorDetails"
    param(
        $ErrorRecord = $Error[0]
    )

    $ErrorRecord | Format-List * -Force
    $ErrorRecord.InvocationInfo | Format-List *
    $Exception = $ErrorRecord.Exception
    for ( $depth = 0; $Exception -ne $null; $depth++ )
    {   
        "$depth" * 80
        $Exception | Format-List -Force *
        $Exception = $Exception.InnerException
    }
} # }}}

function initBigRegexGBLS { # {{{

      # build regular expresion only once for larger string expressions
      #
      $pfxRe = '(?ix: Microsoft.PowerShell.Core\\FileSystem:: )?'

      $fullRE  = @()
      $fullRE += '(?x:   \A \s* Path \s* [-]+   \s* '     + $pfxRe + ' (?x: (.+?) \s* \z) )'
      $fullRE += '(?x:   \A \s* '                         + $pfxRe + ' (?x: (.+?) \s* \z) )'
      $fullRE += '(?x:   \A System.String \s+   PSPath= ' + $pfxRe + ' (?x: (.+?) \s* \z) )'
      $fullRE += '(?six: \A ( (Env) | (variable) | (HKLM) | (HKCU) ) : )'

      $GLOBAL:getLocationRE           =  [regex]   $fullRE[   0  ]
      $GLOBAL:getPSPathRE             =  [regex]   $fullRE[   1  ]
      $GLOBAL:getLongNameRE           =  [regex]   $fullRE[   2  ]
      $GLOBAL:notAfileSystemRE        =  [regex]   $fullRE[   3  ]

 } # }}}

function currentDirectory { # {{{
      # $profile -replace '[\\][^\\]+\z', $nullstr
      #
      # will produce the name of the directory that contains...
      #
      #     Microsoft.PowerShell_profile.ps1
      #
      # if...
      #
      # $d == $profile -replace '[\\][^\\]+\z', $nullstr
      #
      # ...after cd $d...
      #
      # in some environments, Get-Location will
      # produce an object that is displayed
      # as follows:
      #
      # Path
      # ----
      # Microsoft.Powershell.Core\FileSystem::
      # \\$domainUsrDir\nomad\My Documents\WindowsPowerShell
      #
      # ...which is useless at best, or just plain *WRONG*
      #
      # A string (not an object) that displays as...
      #
      # \\$domainUsrDir\nomad\My Documents\WindowsPowershell
      #
      # ...is a lot more useful. That is what the code below does.
      #
      $( Get-Location | out-string ) -replace $getLocationRE, '$1'
 } # }}}
function ff1 {
    $GLOBAL:consoleTitleMode = "tskMgrInstance"
}

function setConsolewindowTitle { # {{{
    #
    #  display the current directory with
    #  embedded spaces and parens aliased
    #  to utf8 placibos
    #
    if ( "rt1path" -eq $consoleTitleMode ) {
        $host.UI.RawUI.WindowTitle = "rt1 ENVIRONMENT"
    }
    elseif ( "rt1devpath" -eq $consoleTitleMode ) {
        $host.UI.RawUI.windowTitle = "rt1 dev environment"
    }
    elseif ( "vsenvpath" -eq $consoleTitleMode ) {
        $host.UI.RawUI.windowTitle = "vs dev environment"
    }
    elseif ( "ClEnvPath" -eq $consoleTitleMode ) {
        $host.UI.RawUI.windowTitle = "CYTHON"
    }
    elseif ( "tskMgrInstance" -eq $consoleTitleMode ) {
        $host.UI.RawUI.windowTitle = "ADM " + $( currentDirDsply )
    }
    else {
        $host.UI.RawUI.WindowTitle = dspc $( currentDirectory )
    }
} # }}}

function currentDirDsply { # {{{
    #
    #  display the current directory with
    #  embedded spaces and parens aliased
    #  to utf8 placibos
    #
    dspc $( currentDirectory )
} # }}}

function rndx16bit { # {{{
      #
      #  return the random number
      #  zeropadded to 4 hex   digits
      #
      "{0:x4}" -f $( Get-Random -maximum 0xFFFF )
} # }}}

function rndx32bit { # {{{
      #
      # return   the   random number
      # zeropadded     to 4 hex digits
      #
      "{0:X8}" -f $( Get-Random )
} # }}}

function rnd32bit { # {{{
    #
    #  return the   random number
    #  zeropadded   to 10 digits
    #
    "{0:d10}" -f $( Get-Random )
} # }}}

function pidl { #{{{
    #
    #  return the   process ID of the current process
    #  zeropadded   to 5 digits
    #
    "{0:d5}" -f $PID
} # }}}

function colorcheck { # {{{
    $f1 = "{0,-12}{1}"  # format specifier 1
    $f2 = "{0,-12}"     # format specifier 2
    [Enum]::Getvalues( $host.UI.RawUI.ForegroundColor.GetType() ) |
    foreach {
        write-Host                       -NoNewLine  "[ "
        write-Host                       -NoNewLine  $( $f1 -f $_,": " )
        write-Host  -ForegroundColor  $_ -NoNewLine  $( $f2 -f $_      )
        write-Host                                   " ]"
    }

    [Enum]::Getvalues( $host.UI.RawUI.BackgroundColor.GetType() ) |
    foreach {
        write-Host                       -NoNewLine  "[ "
        write-Host                       -NoNewLine  $( $f1 -f $_,": " )
        write-Host  -BackgroundColor  $_ -NoNewLine  $( $f2 -f $_      )
        write-Host                                   " ]"
    }
} # }}}

function remote2desales { # {{{
    $s1 = "$cReturn$newline"
    $s2 = "${s1}iex ${dollar}HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1$s1"
    Write-Host -ForegroundColor Green "$s2"
    $s3 = 'etsn -computername desales -credential desales\nomad' 
    iex $s3
} # }}}

function remote2fjs { # {{{
    $s1 = "$cReturn$newline"
    $s2 = "${s1}iex ${dollar}HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1$s1"
    Write-Host -ForegroundColor Green $s2
    $s3 = 'etsn -computername fultonjsheen -credential fultonjsheen\ksk' 
    iex $s3
} # }}}

function adbshell { # {{{
    $image = s2bs( "C:/adb/adb.exe shell" )
    invoke-expression -command $image
} # }}}

function gitgui { # {{{
    $d = $doublequote
    $image = s2bs( "start C:/Git/bin/wish.exe ${d}C:/Git/libexec/git-core/git-gui${d}" )
    invoke-expression -command $image
} # }}}


function ise { # {{{
    Powershell_ISE         $args
} # }}}

function pp { # {{{
      #
      # print short names of path constituents
      #
      $pathArray = $path -split ";"
      for ( $ix = 0; $ix -lt $pathArray.length; $ix++ ) {
          $entry = dspc $pathArray[ $ix ]
          "{0:d2} {1}" -f $ix, $entry
      }
} # }}}

function ppl { # {{{
     #
     # print long names of path constituents
     #
     $pathArray = $pathcache[ "path" ]
     for ( $ix = 0; $ix -lt $pathArray.length; $ix++ ) {
          $entry = dSpc $pathArray[ $ix ]
          "{0:d2} {1}" -f $ix, $entry
     }
} # }}}

function mststampInit { # {{{
     # FACILITATE THE FOLLOWING TRANSFORMATION...
     # TRANSFORM:   2011-07-28t18:22:41.2847383-04:00
     #      INTO:   20110728.182241.2847383
     #
     if ( $null -eq $tStampRE ) {
          $datePattern           = '(?six:  (\d+)  [-] (\d+)  [-] (\d+) )'
          $timePattern           = '(?six:  (\d\d) [:] (\d\d) [:] (\d\d) [.] (\d+) )'
          $GLOBAL:tStampRE       = "(?six:  \A $datePattern [T] $timePattern .+ \z)";
          $GLOBAL:tStemplate     = '$1$2$3.$4$5$6.$7';
     }
}    # }}}

function mststamp { # {{{
     #
     # TRANSFORM: 2011-07-28t18:22:41.2847383-04:00
     #      INTO: 20110728.182241.2847383
     #
     $( get-date -format o ) -replace $tStampRE, $tStemplate
}   # }}}

function usrHost { # {{{
     $env:USERNAME      +
     "."                +
     $localhost
}   # }}}

function usrHostPid { # {{{
    $( usrHost )  +
    "."           +
    $( pidl )
} # }}}

function usrHostTStampPidRE { # {{{
    $( usrHost )    +
    '[.]'           +
    '\d+'           +
    '[.]'           +
    '\d+'           +
    '[.]'           +
    '\d+'           +
    '[.]'           +
    $( pidl )
}   # }}}

function usrHostTStampPid { # {{{
    $( usrHost )   +
    "."            +
    $( mststamp )  +
    "."            +
    $( pidl )
} # }}}

function usrHostPidTStamp { # {{{
    $( usrHostPid ) +
    "."             +
    $( mststamp )
} # }}}

function ostr { # {{{
    #
    #   transform the object passed in
    #   from a pipe, into a string
    #
    while ( $input.movenext() ) {
       $input.Current | Out-String -Stream
    }
}  # }}}

function bs2s { # {{{
    #
    #   replace dos-backslash with unix-frontslash
    #
    $target = qs $( [string]$args )
    $target -replace "$backslash$backslash", $slash
}  # }}}

function s2bs { # {{{
    #
    #   replace unix-frontslash with dos-backslash
    #
    $target = qs $( [string]$args    )
    $target -replace $slash, $backslash
}  # }}}
#
function deSpaceEZ { # {{{
      #
      # Replace spaces and parens with unicode non-whitespace.
      # This is the simplest solution (EZ) but it is not as
      # general as the one I am using in the mainline code.
      #
      if ( 0 -ne $args.count )     {
           $s = qs $( [string]$args )
      }
      else   {
           $s = $( $input | Out-String )
      }
      $s = $s -replace '(?six:   \u0020  )',  $uSpaceAKA
      $s = $s -replace '(?six:   \u0028  )',  [string][char][int] 0x2039
      $s = $s -replace '(?six:   \u0029  )',  [string][char][int] 0x203A
      $s
} # }}}
#
function dspc { # {{{
    $input | deSpace @args
} # }}}
#
function enSpaceEZ { # {{{
    #
    #   REVERSE  THE DESPACE OPERATION
    #
    #   Replace unicode non-whitespace with their origina1 values.
    #   this is the simplest solution (EZ) but it is not as
    #   general as the one I am using in the mainline code.
    #
    if ( 0 -ne $args.count ) {
        $s =   qs $( [string]$args )
    }
    else {
        #
        # NO   ARGUMENT GIVEN: Assume    data  was piped in
        #
        $s =   $( $input | Out-String    )
    }
    $s   = $s -replace '(?six:     \u2022 )', [string][char][int] 0x0020
    $s   = $s -replace '(?six:     \u2039 )', [string][char][int] 0x0028
    $s   = $s -replace '(?six:     \u203A )', [string][char][int] 0x0029
    $s
} # }}}

function deSpace { # {{{
    #
    # SUBSTITUTE UNICODE SYMBOLS FOR WHITESPACE|PARENS IN PATHNAMES
    #
    if ( $args.count ) {
        $canonicalName = qs $( [string]$args )
    }
    else {
        #
        #  No arguments given: Assume data was piped in.
        #
        $canonicalName = $( $input | Out-String )
    }

    $garnishedName = $canonicalName
    if ( $garnishedName -match $regx2aka ) {
        foreach ( $xformRow in $chrAkaXform ) {
            #
            # Must accommodate posh braindamage below:
            # without '$( qs )' the replacement fails.
            #
            $gn = $garnishedName
            $gn = $gn -replace $xformRow[ 0 ], $( qs $xformRow[ 1 ] )
            $garnishedName = $gn
        }
    }

    bs2s $garnishedName # re-orient the backslash characters
} # }}}

function enspace { # {{{
    #
    # RESTORE PATHNAME TO ITZ ORIGINAL FORM
    # ( reverse the deSpace operation )
    #
    if ( $args.count ) {
        $garnishedName = qs $( [string]$args )
    }
    else {
        #
        # No argument given. Assume data was piped in.
        #
        $garnishedName = $( $input | Out-String )
    }

    $canonicalName = $garnishedName
    if ( $canonicalName -match $regx2org ) {
        foreach ( $xformRow in $chrAkaXform ) {
            #
            # Accomodate posh braindamage below:
            # without '$( qs )' the replacement fails.
            #
            $cn = $canonicalName
            $cn = $cn -replace $xformRow[ 2 ], $( qs $xformRow[ 3 ] )
            $canonicalName = $cn
        }
    }
    s2bs $canonicalName # re-orient the slash characters
} # }}}

function enspaceArgs { # {{{
    #
    # provide a way to automagically strip
    # the spaceAKA info from the input arguments
    # this is necessary for calls to:
    #
    # Get-Content ( gc ) *
    # Copy-Item   ( cp )
    # Move-item   ( mv )
    # Remove-Item ( rm )
    #
    # because those commands can take a comma separated
    # list of entries which posh treats in a special way.
    # This is currently (20120605) coded to handle only 1 level of
    # array nesting. I am not sure if any command uses
    # more than that. ( I cant even think of how it might look
    # on the command line.)
    #
    # * currently (20121210) 'gc -wait <file>'
    # fails with
    # Get-Content : A positional parameter cannot be found that accepts argument '.\basepath.bat'.
    # At \\$domainUsrDir\nomad\powershell\pshellMain.psml:683 char:13
    # + Get-Content <<<< @argsPrime
    # + Categorylnfo : invalidArgument: (:) [Get-Content], ParameterBindingException
    # + FullyQualifiedErrorid : PositionalParameterNotFound,Microsoft.PowerShell.Commands.GetContentcommand
    #
    #  Im not quite sure how to fix this.
    #
    #
    $argsPrime = @()
    $inpArgs = $args
    foreach ( $args1 in $inpArgs ) {
        if ( $args1.gettype().fullname -match 'System.Object\[\]' ) {
            #
            #   since args1 is itself a array nested in the args array,
            #   special  processing is necessary here
            #
            $args1Prime = @()
            foreach ( $args2 in $args1 ) {
                $args1Prime += enspace $args2
            }
            #
            #   without  the leading comma (below) we just append scalars
            #   the comma ensures that argsPrime gets another
            #   *ARRAY* appended to it.
            #
            $argsPrime += ,$args1Prime
        }
        else {
            $argsPrime += enspace $args1
        }
    }
    #
    # Among the many peculiar -- not  to say braindamaged --
    # conventions in posh is the way that it strips array
    # levels unless you precede $argsPrime with a comma
    #
    ,$argsPrime
} # }}}

function showAKAmatrix { # {{{
    foreach ( $xformRow in $chrAkaXform ) {
        $outStr = $nullstr
        foreach ( $entry in $xformRow ) {
            $outStr += "<< " + $entry + " >> "
        }
        Write-Host -ForegroundColor Green $outStr
    }

} # }}}

function nSpc { # {{{
    $input | enSpace @args
}    # }}}

function dblquote { # {{{
    $doublequote + $args + $doublequote
}    # }}}

function sqlquote { # {{{
    $singlequote + $args + $singlequote
}    # }}}

function xgc { # {{{
    #
    # an alias of 'gc' gets me here
    #
    $argsPrime = enspaceArgs @args
    Get-Content @argsPrime
} # }}}

function xrm { # {{{
    #
    # an alias of rm gets me here
    #
    $argsPrime = enspaceArgs @args
    remove-item @argsPrime
} # }}}

function xmv { # {{{
    #
    # an alias of mv gets me here
    #
    $argsPrime = enspaceArgs @args
    move-item @argsPrime
} # }}}

function xcp { # {{{
    #
    # an alias of cp gets me here
    #
    $argsPrime = enspaceArgs @args
    copy-item @argsPrime
} # }}}

function guaranteeTmpDirExistence {
    #
    # if temp directory does not exist then
    # create it on the file system and create
    # a reference to it in the registry
    #
    if ( $nullstr -eq $ENV:temp ) {
        #
        # If $ENV:temp is null then this will prevent an error
        # in the test-path statement below
        #
        $ENV:temp = $( $(mststamp) + $(rnd32bit) )
    }
    if ( -not ( Test-Path -path $ENV:temp -PathType container ) ) {
        $ENV:temp = $ENV:userprofile + $GLOBAL:backslash + "temp.$( mststamp )"
        $ENV:temp = $( s2bs $ENV:temp )
        New-Item -itemtype directory -path $ENV:temp
        Set-ItemProperty -Path HKCU:\Environment -Name temp -Value $ENV:temp
    }
    $GLOBAL:temp = $( bs2s $ENV:temp )
}

function ffx { # {{{
    #
    # Run adobe acrobat
    #
    $argsPrime = enspaceArgs @args
    $argstring = nSpc $( qs $( [string]$argsPrime ) )
    if ( $nullstr -ne $argstring ) {
        if ( Test-Path -path $argstring -PathType leaf ) {
            $reader = shortname "$bin/MozFirefox/firefox.exe"
            . $reader  @argsPrime
        }
        else {
            $msg = "0UCH:<read>[ $argstring ] "
            $msg += "DOES NOT APPEAR TO BE A FILE."
            Write-Host -ForegroundColor Red $msg
        }
    }
    else {
        $reader = shortname "$bin/MozFirefox/firefox.exe"
        . $reader
    }
} # }}}

function read { # {{{
    #
    # Run adobe acrobat
    #
    $argsPrime = enspaceArgs @args
    $argstring = nSpc $( qs $( [string]$argsPrime ) )
    if ( $nullstr -ne $argstring ) {
        if ( Test-Path -path $argstring -PathType leaf ) {
            $acro11 = "$bin/Adobe/Acrobat11.0/Acrobat/Acrobat.exe"
            $reader = shortname "$bin/NitroReader3/NitroPDFReader.exe"
            if ( Test-Path -path $acro11 -PathType leaf ) {
                $reader = shortname $acro11
            }
            . $reader $(Get-Item $argstring)
        }
        else {
            $msg = "0UCH:<read>[ $argstring ] "
            $msg += "DOES NOT APPEAR TO BE A FILE."
            Write-Host -ForegroundColor Red $msg
        }
    }
    else {
        $msg = $newline + 'OUCH:<read>[ $argstring ] '
        $msg += 'IS EMPTY. READ WHAT?'
        write-Host -ForegroundColor Red $msg
    }
} # }}}

function elementlongname { # {{{
     #
     # return 8.3 filename for a folder
     #
     $target = nSpc $( s2bs $( qs $( [string]$args ) ) )

     $defstring = $( Get-Item $target                 |
                     Get-Member -name "PSPath"        |
                     %{ $_.definition }               )

     bs2s $( $defstring -replace $getLongNameRE, '$1' )
} # }}}

function fileshortname { # {{{
    #
    # return 8.3 filename for   a file
    #
    $target = nSpc $( s2bs $( qs $( [string]$args ) ) )
    $fileobj = $fso.GetFile( $target )
    $fileobj.ShortPath
} # }}}

function foldershortname { # {{{
    #
    # return 8.3 filename for  a folder
    #
    $target = nspc $( s2bs $( qs $( [string]$args ) ) )
    $folderobj = $fso.GetFolder( $target )
    $folderobj.ShortPath
} # }}}

function shortname { # {{{
    #
    # return 8.3 filename for a folder or file if it exists
    #
    $target = nspc $( qs $( [string]$args ) )
    if ( Test-Path -path $target -PathType leaf ) {
        fileshortname $target
    }
    elseif ( Test-path -path $target -PathType container ) {
        foldershortname $target
    }
    else {
        $msg = "OUCH<shortname>:[ $target        ] "
        $msg += "DOES NOT APPEAR BE A FILE OR DIRECTORY"
        write-Host -Foregroundcolor Red $msg
        write-Output $nullstr
        $nullstr
    }
} # }}}

function longname { # {{{
    #
    # return 8.3 filename for a folder or file if it exists
    #
    $target = nSpc $( qs $( [string]$args ) )
    if ( Test-Path -path $target ) {
        elementlongname $target
    }
    else {
        $msg = "OUCH<longname>:[ $target ] "
        $msg += "DOES NOT APPEAR BE A FILE OR DIRECTORY"
        write-Host -Foregroundcolor Red $msg
        write-Output $nullstr
        $nullstr
    }
} # }}}

function touch { # {{{
    #
    # change modification date for a file
    # to the current date and time. If
    # the file does not exist, then create
    # an empty one.
    #
    $timenow = Get-Date
    foreach ( $maybeAfile in $( ql $( $args ) ) ) {
        $target = nSpc $( s2bs $( qs $( $maybeAfile ) ) )
        if ( Test-Path -path $target -PathType leaf ) {
            $fileObject = Get-Item $target
            $fileobject.LastwriteTime = $timenow
        }
        else {
            Add-Content -path $target -value $nullstr
            Clear-Content -path $target
            if ( Test-Path -path $target -PathType leaf ) {
                $fileObject = Get-Item $target
                $fileobject.LastwriteTime = $timenow
            }
        }
    }
} # }}}

function shortnamequiet { # {{{
    #
    # return 8.3 filename for a folder or file
    # dont complain if it does not exist
    #
    $target = nSpc $( qs $( [string]$args ) )
    if ( Test-Path -path $target -PathType leaf ) {
        fileshortname $target
    }
    elseif ( Test-Path -path $target -PathType container ) {
        foldershortname $target
    }
    else {
        $target
    }
} # }}}

function cleave { # {{{
    $inpArg = $( qs $( [string]$args ) )

    [System.Collections.ArrayList]$SCA = $inpArg -split '[\n\r;]+'          |
                                         %{ $_ -replace $leadingWS, $nullstr }  |
                                         %{ $_ -replace $trailingWS, $nullstr }
    [System.Collections.ArrayList]$SCA
} # }}}

function sunder { # {{{
    $inpArg = $( qs $( [string]$args ) )

    $inpArg -split '[\n\r;]+'          |
    %{ $_ -replace $leadingWS, $nullstr }  |
    %{ $_ -replace $trailingWS, $nullstr }

} # }}}

function sow { # {{{
    #
    # join the members of the array (second argument)
    # into a semicolon separated string whose identifier variable name
    # (without the '$' prefix) is supplied in the string (first argument)
    # but only if the argument exists as a directory accessible
    # by the local host. The variable '<TAG>' gets the short named
    # path. The variable '<TAG>L' gets the long name path.
    #
    # Also store the '<TAG>L' array in $GLOBAL:pathCache[ $tag ]
    # and save the long and short string in a corresponding
    # environment variable.
    #
    # clean up the entries in the array and skip the ones that are
    # commented out ( start with # )
    #
    $tag = $args[0]                                 #  1st Argument
    $tag = $tag  -replace  $leadingWS,  $nullstr    #  trim  leading white space
    $tag = $tag  -replace  $trailingWS, $nullstr    #  trim  trailing white space
    #
    # $sowTypeAllowed is a global regex that only lets through
    # the desired types (Array|String) the introspection in
    # posh aint great but it is better than nothing.
    #
	$argType = $($args[1].psobject.typenames | where {$_ -match $sowTypeAllowed})
    if ( "System.String" -eq $argType ) {
        $pathArray = (, $args[1])
    }
    if ( $null -ne $argType ) {
        $pathArray = $args[1]
    }
    else {
        $argType = $args[1].psobject.typenames -join $space
        throw "Invalid Argument ( $argType ) supplied to sow"
    }
    if ( $nullstr -eq $args[1] ) {
        $m = "skipping sow for " + $args[0]
        Write-Host -Foregroundcolor Red $m
        return
    }
    $pVfydSFN = @()                                 #  path ( existence verified ) short folder name
    $pVfydLFN = @()                                 #  path ( existence verified ) long  folder name
    $uniqFolders = @{}                              #  keep duplicate entries out of path
    foreach ( $entry in $pathArray ) { # {{{
        $entry    =  $entry -replace  '[#].*',      $nullstr    #  trim  pound sign and data after
        $entry    =  $entry -replace  $leadingWS,   $nullstr    #  trim  leading white space
        $entry    =  $entry -replace  $trailingWS,  $nullstr    #  trim  trailing white space

        if ( $entry -match '\A\s*\z' ) {
            continue      #  empty, so skip
        }

        if ( $entry -match '\A\s*#' ) {
            continue       #  commented out,   so  skip
        }

        if ( $entry -match '\A[/\\]' ) {
            continue       #  Leading slash is artifact of nonexistant directory. Skip it.
        }

        $entry = bs2s $entry # normalize path separator

        if ( "tracethis" -eq "tracethisx" ) {
            $m = "path redundancy test:" + "[$entry]"
            Write-Host -Foregroundcolor Green $m
        }
        if ( -not ( Test-Path -path $entry -PathType container ) ) {
            continue       #  does not exist as a directory on this machine
        }

        if ( $null -ne $uniqFolders[ $entry ] ) {
            continue       #  already in the path
        }
        #
        # mark this folder so it does not show up
        # in the path in more than 1 place
        #
        $uniqFolders[ $entry ] = 1
        #
        # push the long folder name on the array
        # since itz existence has been verified
        #
        $pVfydLFN += $entry
        #
        # push the short folder name on the array
        #
        $pVfydSFN += bs2s $( foldershortname  $entry )

    } # }}}

    if ( 0 -ne $pVfydLFN.length ) {
        #
        # only set value if path has something in it
        #
        $GLOBAL:pathcache[ $tag ] = $pVfydLFN
        $orderedPair  = ,$( $pVfydSFN -join ';' )
        $orderedPair +=  $( $pVfydLFN -join ';' )
        foreach ( $prefix in $( ql global env ) ) {
            $xpression = '${0}:{1}, ${0}:{1}L = ${2}' -f $(ql $prefix $tag orderedPair)
            #
            # Say What?
            #
            # invoked expression will look like one
            # of the lines below. Thereby assuring
            # that each WINDOWS ENV: variable has
            # a corresponding powershell GLOBAL variable.
            # ordered pair contains 2 path strings the first
            # one is harder for most humans to read than the
            # second.
            #
            # $GLOBAL:INCLUDE, $GLOBAL:INCLUDEL = $orderedPair
            #    $ENV:INCLUDE,    $ENV:INCLUDEL = $orderedPair
            #
            invoke-Expression $xpression
        }
    }

} # }}}

function ingest { # {{{
    # take a single argument of strings separated
    # by linefeeds. The first string is a pathName
    # like "INCLUDE" the remaining strings are
    # directory paths. each directory will be added
    # to search path for pathName. String will look like:
    #
    # INCLUDE
    # $bin/VisualStudio14_0/VC/INCLUDE
    # $pfdL/Windows Kits/10/include/10.0.10240.0/ucrt
    # $pfdL/Windows Kits/NETFXSDK/4.6/include/um
    # $pfdL/Windows Kits/10/include/10.0.10240.0/shared
    # $pfdL/Windows Kits/10/include/10.0.10240.0/um
    # $pfdL/Windows Kits/10/include/10.0.10240.0/winrt#
    #
    # ...But without the '#' character
    #
    [System.Collections.ArrayList]$pathGroup = cleave $args[0]
    $pName = $pathGroup[0]
    $pathGroup.RemoveAt(0)
    sow $pName $pathGroup
} # }}}

function ePlant { # {{{
    $tag    = $args[0]                                     #  1st Argument
    $tag    = $tag    -replace  $leadingWS,    $nullstr    #  trim  leading white space
    $tag    = $tag    -replace  $trailingWS,   $nullstr    #  trim  trailing white space
    $value  = $args[1]                                     #  2nd Argument
    $value  = $value  -replace  $leadingWS,    $nullstr    #  trim  leading white space
    $value  = $value  -replace  $trailingWS,   $nullstr    #  trim  trailing white space

    foreach ( $prefix in $( ql global env ) ) {
        $xpression = '${0}:{1} = ${2}' -f $(ql $prefix $tag value)
        #
        # Say What?
        #
        # invoked expression will look like one
        # of the lines below. Thereby assuring
        # that each WINDOWS ENV: variable has
        # a corresponding powershell GLOBAL variable.
        #
        # $GLOBAL:TAG = $value
        #    $ENV:TAG = $value
        #
        invoke-Expression $xpression
    }
} # }}}



function s256 { # {{{
    #
    # generate sha256 sum
    #
    $caught = 0
    $m = @()
    $m+= $newline
    $m+= 'OUCH<s256>:[ s256 $argstring ]'
    $m+= $newline
    $m+= "USAGE: s256 [ <filename> ] "
    $m+= $newline
    $errusage = $m -join $newline

    try {
        $argstring = nSpc $( bs2s $( qs $( [string]$args ) ) )

        $prefix = usrHostTStampPid
        $file2check = bs2s "$cmdHistoryTmpD/$prefix.cointoss"

        if ( $nullstr -eq "$argstring" ) {
            throw
            #
            #   head called without arguments ( In prior version )
            #
            $input | Out-String | Set-Content $file2check
        }
        elseif ( Test-Path -path $argstring -PathType leaf ) {
            #
            # the entire argument string is a filename
            #
            $file2check = $argstring
        }
        else {
            #
            # $argstring is *NOT* a file on the file system
            #
            $m    =  $nullstr
            $m   +=  $newline
            $m   +=  "0UCH<s256>:[ $argstring  ] "
            $m   +=  "DOES NOT APPEAR  TO  BE A  FILE."
            $m   +=  $newline
            Write-Host -Foregroundcolor Red $m
            throw
        }
    }
    catch   {
        write-Host -Foregroundcolor Red $errusage
        $caught   =  1
    }


    if ( 0 -eq $caught ) {
        ## create the hash object that calculates the md5
        $hashMethod = [Type] "System.Security.Cryptography.SHA256"
        $engine = $hashMethod::Create()

        $fObj = get-item $file2check
        $datastream = New-object io.streamReader $fobj.fullname
        $octets = $engine.ComputeHash( $dataStream.BaseStream )
        $dataStream.Close()
        $transform = New-object System.Text.StringBuilder
        $octets | Foreach-object {
            [void] $transform.Append( $_.ToString("x2") )
        }
        $transform.ToString()
    }

} # }}}

function s512 { # {{{
    #
    # generate sha512 sum
    #
    $caught = 0
    $m = @()
    $m+= $newline
    $m+= 'OUCH<s512>:[ s512 $argstring ]'
    $m+= $newline
    $m+= "USAGE: s512 [ <filename> ] "
    $m+= $newline
    $errusage = $m -join $newline

    try {
        $argstring = nSpc $( bs2s $( qs $( [string]$args ) ) )

        $prefix = usrHostTStampPid
        $file2check = bs2s "$cmdHistoryTmpD/$prefix.cointoss"

        if ( $nullstr -eq "$argstring" ) {
            throw
        }
        elseif ( Test-Path -path $argstring -PathType leaf ) {
            #
            # the entire argument string is a filename
            #
            $file2check = $argstring
        }
        else {
            #
            # $argstring is *NOT* a file on the file system
            #
            $m    =  $nullstr
            $m   +=  $newline
            $m   +=  "0UCH<s512>:[ $argstring  ] "
            $m   +=  "DOES NOT APPEAR  TO  BE A  FILE."
            $m   +=  $newline
            Write-Host -Foregroundcolor Red $m
            throw
        }
    }
    catch   {
        write-Host -Foregroundcolor Red $errusage
        $caught   =  1
    }


    if ( 0 -eq $caught ) {
        ## create the hash object that calculates the checksum
        $hashMethod = [Type] "System.Security.Cryptography.SHA512"
        $engine = $hashMethod::Create()

        $fObj = get-item $file2check
        $datastream = New-object io.streamReader $fobj.fullname
        $octets = $engine.ComputeHash( $dataStream.BaseStream )
        $dataStream.Close()
        $transform = New-object System.Text.StringBuilder
        $octets | Foreach-object {
            [void] $transform.Append( $_.ToString("x2") )
        }
        $transform.ToString()
    }

} # }}}


function m5 { # {{{
    #
    # generate md5 sum
    #
    $caught = 0
    $m = @()
    $m+= $newline
    $m+= 'OUCH<m5>:[ m5 $argstring ]'
    $m+= $newline
    $m+= "USAGE: m5 [ <filename> ] "
    $m+= $newline
    $m+= "* IF <filename> ARGUMENT IS OMITTED, STDIN IS ASSUMED."
    $m+= $newline
    $m+= "* FILE NAMES CONTAINING SPACES ARE NOT SUPPORTED."
    $m+= $newline
    $errusage = $m -join $newline

    try {
        $argstring = nSpc $( bs2s $( qs $( [string]$args ) ) )

        $prefix = usrHostTStampPid
        $file2check = bs2s "$cmdHistoryTmpD/$prefix.cointoss"

        if ( $nullstr -eq "$argstring" ) {
            #
            #   head called without arguments
            #
            $input | Out-String | Set-Content $file2check
        }
        elseif ( Test-Path -path $argstring -PathType leaf ) {
            #
            # the entire argument string is a filename
            #
            $file2check = $argstring
        }
        else {
            #
            # $argstring is *NOT* a file on the file system
            #
            $m    =  $nullstr
            $m   +=  $newline
            $m   +=  "0UCH<m5>:[ $argstring  ] "
            $m   +=  "DOES NOT APPEAR  TO  BE A  FILE."
            $m   +=  $newline
            Write-Host -Foregroundcolor Red $m
            throw
        }
    }
    catch   {
        write-Host -Foregroundcolor Red $errusage
        $caught   =  1
    }


    if ( 0 -eq $caught ) {
        ## create the hash object that calculates the md5
        $hashMethod = [Type] "System.Security.Cryptography.MD5"
        $engine = $hashMethod::Create()

        $fObj = get-item $file2check
        $datastream = New-object io.streamReader $fobj.fullname
        $octets = $engine.ComputeHash( $dataStream.BaseStream )
        $dataStream.Close()
        $transform = New-object System.Text.StringBuilder
        $octets | Foreach-object {
            [void] $transform.Append( $_.ToString("x2") )
        }
        $transform.ToString()
    }

} # }}}



function m5f { # {{{
    $inparg = $args
    $canonicalName = nSpc $( bs2s $( qs $( [string]$inparg ) ) )
    $r = m5 $canonicalName
    "$r $inparg"
} # }}}

function H_T_Proxy { # {{{
    try {
        $argstring = nSpc $( bs2s $( qs $( [string]$args ) ) )

        $commandStack = @()
        #
        # the trick below is the only way I found to extract
        # all the meaningful data from the call stack without
        # dumping it out to a fiie and re-parsing it.
        #
        $oCallStack = Get-PSCallStack | Format-List | Out-String
        # $oCallStack
        #
        # after "$oCallstack = Get-PSCallstack | Format-List | Out-string"
        # oCallStack will contain something like the data   below...
        #
        #
        #   scriptName         :  \\$domainUsrDir\nomad\powershell\pShellMain.psml
        #   ScriptLineNumber   :  321
        #   InvocationInfo     :  System.Management.Automation.lnvocationlnfo
        #   Command            :  H_T_Proxy
        #   Location           :  pshellMain.psml:  Line 321
        #   Arguments          :  {vanillaenv.txt}
        #
        #   ScriptName         :  \\$domainUsrDir\nomad\powershell\pShellMain.psml
        #   ScriptLineNumber   :  472
        #   InvocationInfo     :  System.Management.Automation.lnvocationlnfo
        #   Command            :  head
        #   Location           :  pShellMain.psml:  Line 472
        #   Arguments          :  {vanillaenv.txt}
        #
        #   scriptName         :
        #   ScriptLineNumber   :  1
        #   InvocationInfo     :  System.Management.Automation.InvocationInfo
        #   Command            :  prompt
        #   Location           :  prompt
        #   Arguments          :  {}
        #
        #
        $oCallStack -split '\n' | foreach {
            if (   $_ -match   '(?six: \A Command )' ) {
                #
                # find the caller id
                #
                $commandStack += $_
            }
        }
        $pattern = [regex]'(?six: \A \s* command \s+ [:] \s* ( ( head ) | ( tail ) ) \s* \z )'
        if ( $commandStack[ 1 ] -match $pattern ) {
            $callerlD = [string]$matches[ 1 ]
        }
        else {
            $m =   @()
            $m+=   $newline
            $m+=   "0UCH< H_T_Proxy>:[ H_T_Proxy $argstring ]"
            $m+=   $newline
            $m+=   " H_T_Proxy ONLY ACCEPTS CALLS FROM FUNCTIONS NAMED 'head' OR 'tail'"
            $m+=   $newline
            $errusage = $m -join $newline
            throw
        }


        $m = @()
        $m+= $newline
        $m+= "OUCH< H_T_Proxy>:[ head $argstring ]"
        $m+= $newline
        $m+= "USAGE: $callerlD [ [ [-]<linecount> ] [ <filename> ] ]"
        $m+= $newline
        $m+= "* IF <filename> ARGUMENT IS OMITTED, STDIN IS ASSUMED."
        $m+= $newline
        $m+= "* FILE NAMES CONTAINING SPACES ARE NOT SUPPORTED."
        $m+= $newline
        $errusage = $m -join $newline

        $caught = 0
        $linecount = 16
        $prefix = usrHostTStampPid
        $tmpfname = bs2s "$cmdHistoryTmpD/$prefix.cointoss"

        if ( $nullstr -eq $argstring ) {
            #
            # head called without arguments
            #
            $input | Out-String | Set-Content -Encoding UTF8 $tmpfname
        }
        elseif ( Test-Path -path $argstring -PathType leaf ) {
            #
            # the entire argument string is a filename
            #
            Get-content $argstring                        |
            Out-String                                    |
            Set-Content -Encoding UTF8 $tmpfname
        }
        elseif ( $argstring -notmatch '(?six: \A (?:[-]){0,2} (\d+) )' ) {
            #
            #  the  argument  string  does not begin with a linecount specifier
            #
            $m = $nullstr
            $m += $newline
            $m += "OUCH< H_T_Proxy>: [ $argstring ] "
            $m += "DOES NOT APPEAR TO BE A FILE."
            $m += $newline
            write-Host -ForegroundColor Red $m
            throw
        }
        elseif ( $argstring -match '(?six: \A (?:[-]){0,2}  (\d+) \z )' ) {
            #
            # the argument string consists of *only* a linecount specifier
            #
            $linecount = [int]$matches[ 1 ]
            $input | Out-String | Set-Content -Encoding UTF8 $tmpfname
        }
        elseif ( $argstring -match '(?six: \A (?:[-]){0,2} (\d+) \s+ (\S.*) \z )' ) {
            #
            # the argument string begins with a linecount specifier but has
            # data after the specifier
            #
            $linecount = [int]$matches[ 1 ]
            $secondarg = [string]$matches[ 2 ]
            if ( Test-Path -path $secondarg -PathType leaf ) {
                #
                # the data after the linecount specifier is a
                # file on the file system
                #
                Get-Content $secondarg                         |
                Out-String                                     |
                Set-Content -Encoding UTF8 $tmpfname

            }
            else {
                #
                # the data after the linecount specifier
                # is *NOT* a file on the file system
                #
                $m = $nullstr
                $m += $newline
                $m += "OUCH< H_T_Proxy>:[ $secondarg ] "
                $m += "DOES NOT APPEAR TO BE A FILE."
                $m += $newline
                write-Host -ForegroundColor Red $m
                throw
            }
        }
        else {
            #
            # the arguments somehow evaded all the above tests
            #
            throw
        }
    }
    catch   {
        write-Host -ForegroundColor Red  $errusage
        $caught = 1
    }

    if ( 0 -eq $caught ) {
        #
        # whether heads or tails is the  outcome,
        # filter-out/remove blank lines
        #
        if ( 'head' -eq $callerlD ) {
            Get-content $tmpfname                                    |
            Out-String -stream                                       |
            Select-String -notmatch '(?six: ^ \s* $ )'               |
            Select-Object -first $linecount
        }
        else {
            Get-Content $tmpfname                                    |
            Out-String -stream                                       |
            Select-String -notmatch '(?six: ^ \s* $ )'               |
            Select-Object -last $linecount
        }
    }

} # }}}

function head { # {{{
    $input | H_T_Proxy @args
} # }}}

function tail { # {{{
    $input |  H_T_Proxy @args
} # }}}
#
# }}}
# =========================================================================
#
function ssinit { # {{{
    #
    # initialize the Folderhash structure
    # from persistant storage.
    #
    $lclFolderHash = @{}
    $cronological = @{}
    $datePart = "(?sx: \d+ [.]   \d+    [.] \d+ )"
    $hostPart = "(?six: $localhost )"
    $pattern = [regex]"(?six: \A ( $datePart ) \s+ ( $hostPart ) \s+ ( \S+ ) \s* \z )"

    #
    # fetch entire cdJournal . filter for keys gathered on this host
    #
    if ( Test-Path -path $cdJournal -PathType leaf ) {
        Get-Content $cdJournal         |
        Out-String -stream             |
        Select-String $pattern         | foreach {
            #
            # EACH LINE OF cdJournal HAS THE FORM:
            #
            #           20120531.102712.7332716   PrimeLclHost  C:/nomad
            #
            $dstamp = $_ -replace $pattern, '$1'
            $dsplydir = $_ -replace $pattern, '$3'
            $lclFolderHash[ $dsplydir ] = $dstamp
        }

        $lclFolderHash.keys | foreach {
            #
            # switch the keys with the values
            #
            $cronological[ $lclFolderHash[ $_ ] ]=$_
        }

        $cronological.keys         |
        sort-object                |
        select-object -last 64     | foreach {
            #
            # sort cronologically. take only the last 64
            #
            $GLOBAL:FolderHash[ $cronological[ $_ ] ] = $_
        }
    }

} # }}}

function showDirectoryStack { # {{{
    Param (
        [Parameter(Position=0, Mandatory=$true)]
        [System.Object]$count,
        [Parameter(Position=1, Mandatory=$true)]
        [System.Object]$filter
    )
    #
    if ( $nullstr -eq $filter ) {
        $filter = '.'
    }
    #
    $cronological = @{}
    $forDisplay   = @()

    $FolderHash.keys | foreach {
        #
        # switch the keys with the values
        #
        $cronological[ $FolderHash[ $_ ] ] = $_
    }

    $cronological.keys |
    sort-object        | foreach {
        #
        # sort cronologically. take only the last count entries
        #
        $displayPath = $cronological[ $_ ]
        if ( $displayPath -match '(?six: \A // )' ) {
            $displayPath = '  ' + $displayPath
        }
        $forDisplay += $displayPath
    }

    $GLOBAL:RawUI = (get-host).UI.RawUI
    $RawUIOriginalColor = $RawUI.ForegroundColor

    $GLOBAL:RawUI.ForegroundColor = 'Green'

    $forDisplay                        |
    Out-String -Stream                 |
    Select-String -pattern $filter     |
    select-Object -last $count         | foreach {
        write-Output $_
    }

    $GLOBAL:RawUI.ForegroundColor = $RawUIOriginalcolor

} # }}}

function ss { # {{{
    showDirectorystack 32 $args
}   # }}}

function sss { # {{{
    showDirectoryStack 128 $args
}   # }}}

function ssss { # {{{
    showDirectoryStack 256 $args
} # }}}

function pgy { # {{{
    #
    # start powergui for powershell debugging
    #
    pgui  @args
} # }}}

function setdir { # {{{
    $inpArg   = nSpc $(  bs2s $( qs $( [string]$args  ) ) )
    $inpArg   = $inpArg  -replace  $leadingWS, $nullstr           # trim leading white space
    $inpArg   = $inpArg  -replace  $trailingWS, $nullstr           # trim trailing white space

    $whereIwannaGo = $inpArg

    if (   $whereIwannaGo   -match  '(?six: \A  [.] \z ) ' ) {
        #
        # posh chokes on 'cd .' at comment: 'DlRECTORY DID NOT CHANGE'
        # but I could not figure out why because it only fails when
        # I am not running in powergui. This is a workaround.
        #
        $whereIwannaGo = currentDirectory
    }

    if ( $whereIwannaGo -ne $( currentDirectory ) -and $whereIwannaGo -ne $nullstr) {
        $iGottaGoBak = $false
        $whereIwuz = currentDirectory
        $errMsg = $nullstr
        if ( $whereIwuz -match $notAfileSystemRE ) {
            #
            #  if posh currentDirectory is Env: then
            #  Test-Path does not evaluate UNC paths properly.
            #  So...
            #  If current directory is Env: then go home first
            #
            $iGottaGoBak = $true # if the directory change fails then iGottaGoBak
            Set-Location $initialDirectory
        }
        if ( Test-Path -path $whereIwannaGo -PathType container ) {
            set-Location    $whereIwannaGo
            if ( $whereIwuz -ne $( currentDirectory ) ) {
                #
                #    CHANGE DIRECTORY SUCCEEDED
                #
                $GLOBAL:folderHash[ "$( currentDirDsply )" ] = mststamp
                #
                #    it looks like Add-Content does not check the file encoding
                #    prior to adding text. consequently the commented 'Add-Content'
                #    statements will bugger the directory history by adding plain
                #    ascii to a utf8 file. -- Go figure. I like add-content in
                #    principle so I am gonna leave these broken statements here
                #    till I figure out how to fix them by explicitely encoding
                #    my utf8 string into the destination.
                #
                #      $sout = "$( currentDirDsply )"
                #      Add-content -path $GLOBAL:cdTrail -value $sout
                #      $sout = "$( mststamp ) $( hostname ) $( currentDirDsply )"
                #      Add-Content -path $GLOBAL:cdJournal -value $sout
                #
                # The redirection works, but, I rather use Add-Content cause
                # it is more in keeping with powershell style.
                #
                $sout = "$( currentDirDsply )"
                write-Output $sout >> $cdTrail
                $sout = "$( mststamp ) $localhost $( currentDirDsply )"
                write-Output $sout >> $cdJournal
            }
            else {
                #
                #    DIRECTORY DID  NOT CHANGE
                #
                $o1 = $fso.getfolder( $whereIwuz )
                $n1 = $o1.path
                $o2 = $fso.getfolder( $whereIwannaGo )
                $n2 = $o2.path
                if ( $n1 -ne $n2 ) {
                    $errMsg  += "OUCH<setdir>:[ $whereIwannaGo ] "
                    $errMsg  += "APPEARS TO BE A DIRECTORY, BUT "
                    $errMsg  += "DIRECTORY DID NOT CHANGE"
                }
            }
        }
        else {
            $errMsg += "OUCH<setdir>:[ $whereIwannaGo ] "
            $errMsg += "DOES NOT APPEAR TO BE A DIRECTORY"
        }

        if ( $errMsg ) {
            $errMsg = $newline * 3 + $errMsg + $newline * 3
            write-Host -ForegroundColor Red $errMsg
            if   ( $iGottaGoBak ) {
                Set-Location $whereIwuz
                $iGottaGoBak = $false
            }
        }
    }

} # }}}

function nukearchiology { #{{{
    #
    # I keep timestamped copies of...
    #   history
    #   this file
    #   transcripts
    #   password files
    #
    # This creates a lot of junk in my directory hierarchy
    # but is very good for tracking things when something
    # goes horribly wrong. But, once something gets old enough
    # it is not so useful. So, this it what I use to clean
    # up all the bread crumbs I have left in the forest to
    # find my way back home.
    #
    $nukeCandidatex = $expiredFiles
    if (   Test-Path -path $nukeCandidateX -PathType leaf ) {
        Get-Content  $nukecandidatex |
        sort-object  -unique | foreach  {
            $artifact = $_
            if ( Test-Path -path $artifact -PathType leaf ) {
                $fObj = get-Item $artifact
                $tMod = "{0:yyyy.MM.dd.HH.mm.ss}" -f $fObj.LastwriteTime
                write-Host -ForegroundColor Magenta "NUKING -> [ $tMod $artifact ]"
                Remove-Item $artifact
            }
        }
        Remove-Item $nukeCandidatex
    }
} #}}}

function rdtdvsql { # {{{
    $originalLocation = $pwd
    setdir "//$domainUsrDir/$uid/Desktop/HomeSkutz/TS"
    . $sys64L/mstsc.exe /f /v:SqlDvSrvr
    Set-Location $originalLocation
} # }}}

function rdtsql { # {{{
    $originalLocation = $PWD
    setdir "//$domainUsrDir/$uid/Desktop/HomeSkutz/TS"
    . $sys64L/mstsc.exe /f /v:SqlPrdSrvr
    Set-Location $originalLocation
} # }}}

function rdtdesales { # {{{
    $originalLocation = $PWD
    setdir "$bin"
    . $sys64L/mstsc.exe /f deSalesWifiNomad.rdp
    Set-Location $originalLocation
} # }}}


function sevenbit { # {{{
    #
    # ASCII ENCODE THE DESIRED DATA
    #
    $argstring = nSpc $( bs2s $( qs $( [string]$args ) ) )
    if ( $nullstr -eq $argstring ) {
        #
        # null argument implies input from stdin
        #
        $w2s = "$cmdHistoryTmpD/"
        $w2s += "$( usrHostTStampPid ).$(  rnd32bit ).ascii.txt"
        $where2save = bs2s $w2s
        $input | Out-String | set-Content -encoding ascii   $where2save
        write-Output "7-BIT ASCII CONTENT IS IN: [ $where2save ]"
    }
    else{
        $elementAvailable = $false
        $elementObjects = Get-item -force $( nspc $argstring ) -ErrorAction silentlyContinue
        foreach ( $e2check in $elementobjects ) {
            if ( $null -ne $e2check ) {
                $elementAvailable = $e2check.mode -notmatch "d"
            }
        }
        if ( $elementAvailable ) {
            Get-Item -force $( nSpc $argstring  ) | foreach {
                # {{{
                    # handle any wildcard expansion that may
                    # be embedded in '$argstring'
                # }}}
                $entry = $_
                if ( $entry.mode -notmatch "d" ) {
                    $fullPathName = $( bs2s ($entry.FullName).ToString() )
                    $w2s = "$cmdHistoryTmpD/"
                    $w2s += "$( usrHostTStampPid ).$( rnd32bit ).MAYBE-UTF-8.txt"
                    $where2save = bs2s $w2s
                    Move-item $fullPathName $where2save
                    get-content $where2save | Set-Content -encoding ascii $fullPathName
                    $infomsg = "ORIGINAL [ $fullPathName ] CONTENT PRESERVED IN: [ $where2save ]"
                    write-Host -Foregroundcolor Green $infomsg
                }
                else {
                    $errormessage = "OUCH<sevenbit>:[ $entry ] IS A DIRECTORY."
                    write-Host -ForegroundCo1or Red $errormessage
                }
            }
        }
        else   {
            $errormessage     =  "OUCH<sevenbit>:[ $argstring ] "
            $errormessage    +=  "DOES NOT APPEAR TO MATCH ANY EXISTING file."
            Write-Host -Foregroundcolor Red $errormessage
        }
    }
} # }}}

function parsevimargs { # {{{
    #
    # {{{
    #
    # This long winded routine is intended to overcome some problems associated with
    # the way the powershell mangles command-line arguments and the way microsoft
    # is enamored of spaces in file names. It should not be this hard.
    #
    # Powershell will try to figure out what you "mean"
    #   so...
    #
    #   given 3 files:
    #                 1   tv.pl
    #                 2   op_imp_m3.ini
    #                 3   very silly name
    #
    #   parsevimargs tv.pl,op_imp_m3.ini,very silly name
    #
    #   ...will provide 3 arguments to parsevimargs. they are:
    #
    #                 1   tv.pl op_imp_m3.ini very
    #                 2   silly
    #                 3   name
    #
    #   ...not what most would expect.
    #
    #   since I expect them to be file names, I re-examine the components and test
    #   to see if the files exist and make a marginally good faith effort
    #   to create a list of existing file names in a
    #   meta-load file (a file that contains a list of files to load.)
    #   vimrc uses the single meta-load file to load the files.
    #   into its window buffers
    #
    # }}}
    #
    $prefix = usrHostTStampPid
    #
    #   $vimMetaLoad is a temp file that will contain a
    #   linefeed separated list of filenames that vim
    #   should try to load into itz buffers
    #
    $vimMetaLoad = bs2s "$cmdHistoryTmpD/$prefix.vimtmp.daolatem"
    $currentdirectory = bs2s $( pwd )
    #
    # first line of the metaload file is the current directory
    #
    Set-Content -path $vimMetaLoad -Encoding UTF8 -value $currentdirectory

    if ( 1 -eq $args.count ) { # {{{
        $arg00 = [string] $args[ 0 ]
        if ( "-" -eq $arg00 ) {
            #
            # this semantic means:
            #           1          look for piped input
            #           2          redirect that input to a temp file
            #           3          open that temp file
            #
            $vimtmp =    bs2s "$cmdHistoryTmpD/$prefix.vimtmp.txt"
            $input > $vimtmp
            $args[ 0 ] = $vimtmp
            if ( $vvvIsVerbose ) {
                write-Host -ForegroundColor Green $( dspc $vimtmp )
            }
        }
    } # }}}


    $count = 0
    $expandedArgs = @{}
    foreach(    $subcomponent in $args ) { # {{{ split argument list on whitespace
        #
        #   work my way through all the supplied
        #   command line arguments and put them
        #   in a structure I can control ( a hash )
        #   I will create text hash keys that will
        #   easily sort into the correct order.
        #   buildkey creates a decimal number based
        #   key that is zero-padded to 4 places.
        #   so, '$expandedargs' indexes are...
        #
        #    0000
        #    0001
        #    0002
        #
        #
        #
        #    0DDD
        #
        #   in the event that more than 9999 arguments
        #   are supplied on the command-1ine, an un-handled
        #   error will occur. I don`t think powershell
        #   allows that many arguments, so it will barf
        #   before I do.
        #
        $stringcomponent = [string] $subcomponent
        if ( $stringcomponent -match "\s+" ) {
            #
            # I found whitespace within an element
            # of the args array
            #
            $stringcomponent -split "\s+" | foreach {
                $expandedArgs[ $( buildKey $count ) ] = $_
                $count = $count + 1
            }
        }
        else    {
            $expandedArgs[ $( buildKey $count ) ] = $stringcomponent
            $count = $count + 1
        }
    } # }}}

    #
    # reason for @(  $expandedArgs.keys | sort-object ) {{{
    #
    # unless I wrap '@( )' around '$expandedArgs.keys | sort-object'
    # the use-case of a single argument without embedded spaces will fail.
    # '$orderedKeys.count' will be undefined   (in this use-case) because
    # 'sort-object' returns an array *ONLY* if more than 1 entry
    # gets sorted [  go figure ]. otherwise it returns a string. (and string has
    # no 'count' property)
    #
    # }}}
    #
    $orderedKeys = @( $expandedArgs.keys | sort-object )
    $failsafe = 0
    if ( $orderedKeys.count ) {
        #
        # 1 or more arguments were provided on command line
        #
        $startPos = 0
        :out while ( $failsafe++ -lt 10000 ) { # {{{ Failsafe exit
            # {{{
            #  This loop is moderately tricky.
            #  It is pretty well tested
            #  I do not think there is any way to
            #  get stuck inside it. But the failsafe
            #  makes sure.
            #
            #  EXECUTIVE SUMMARY: work my way through the argument list until
            #  I find a plausible way to split them up such that all the arguments
            #  actually refer to readable files ( as opposed to partial file names )
            # }}}
            $errMsg = $nullstr
            $elementname = $nullstr
            for ( $ix = $startPos; $ix -lt $orderedKeys.count; $ix++ ) {
                # {{{ might come back here with new startpos
                $index = $orderedKeys[ $ix ]
                #
                # get the next file-name component
                #
                $suffix = $expandedArgs[ $index ]
                #
                # append it to the previous
                #
                $elementname = "$elementname $suffix"
                #
                # trim the leading whitespace
                #
                $elementname = $elementname -replace $leadingWS, $nullstr
                $elementAvailable = $false
                $elementObjects = $null
                # {{{
                # continue if element does not exist. otherwise, get the object.
                #
                # The 'elementAvailable' was murderous to get to
                # because hidden files are even hidden from "test-path".
                #
                # The only way to see hidden entries (files/directories) is either
                # "get-childitem -force" or "get-item -force". But, both of
                # those generate errors for elements which are not found.
                #
                # 'try-catch' does not supress these errors.
                #
                # 'trap' does not supress these errors.
                #
                # '-ErrorAction silentlyContinue' did the trick.
                #
                # The acid test was having wild carded hidden files and $profile
                # as arguments to the same "vvv" invocation. It should not be this hard.
                # }}}
                $elementobjects = Get-Item -force $( nspc $elementname ) -ErrorAction silentlycontinue
                foreach ( $e2check in $elementobjects ) {
                    # {{{
                    #  $elementObjects will be $null on a partial path
                    #  if that happens then element remains unavalible
                    #  skip the directories that match wild card specs
                    # }}}
                    if ( $null -ne $e2check ) {
                        $elementAvailable = $e2check.mode -notmatch "d"
                    }
                }
                if ( $elementAvailable ) {
                    # {{{ Process an elementpath because powershell says it exists
                    #
                    # a file exists with the name '$elementname'
                    #
                    Get-Item -force $( nspc  $elementname ) | foreach {
                        # {{{
                        #   handle any wildcard expansion that may
                        #   be embedded in '$elementname1
                        # }}}
                        $entry = $_
                        if ( $entry.mode -notmatch "d" ) {
                            $fullPathName = $( bs2s ($entry.FullName).ToString()                                         )
                            # {{{
                            # append the next filename to meta-load file
                            # }}}
                            Add-Content -path $vimMetaLoad -Encoding utf8 -value $( dSpc $fullPathName )
                        }
                    }
                    # {{{
                    #  I am done with this element, so make sure
                    #  it does not become the prefix for the next element
                    # }}}
                    $elementname = $nullstr
                    $startPos = $ix + 1
                    # {{{
                    # any previously build up error message  from the 'else'
                    # clause (below) needs to be cleared
                    # }}}
                    $errMsg = $nullstr
                    if ( $ix -eq $orderedKeys.count - 1 ) {
                        # {{{
                        # everything in the argument list has been processed
                        # }}}
                        break out
                    }
                    # }}}
                }
                else { # {{{ set up a retry from a different startpos or exit altogether
                    # {{{
                    # '$elementname1 was not found, but it might be the prefix
                    # for another $elementname that will be  found, so save
                    # the error message. But, do not display it yet
                    # }}}
                    $errMsg = $errMsg + $newline + "NOT FOUND:: [ $elementname ]"
                    if ( $ix -eq $orderedKeys.count - 1 ) {
                        # {{{
                        #  I have reached the end of all imput arguments
                        #  so, this argument really has no match on the filesystem
                        # }}}
                        write-Host -ForegroundColor Red $errMsg
                        # {{{
                        #  move the cursor to the next commandline argument
                        # }}}
                        $startPos = $startPos + 1
                        # {{{
                        #  I already printed the error message, so, clear it.
                        # There is no need to repeat myself.
                        # }}}
                        $errMsg = $nullstr
                    }
                    if ( $startPos -eq $orderedKeys.count ) {
                        # {{{
                        # the cursor has reached the end of all imput arguments
                        # so, now we are really finished. Asta.
                        # }}}
                        write-Host -ForegroundColor Red $errMsg
                        break out
                    }
                } # }}}
                # }}}
            }
        }  # }}}
    }

    if ( $vvvIsVerbose ) {
        write-Host -ForegroundColor Green $( dspc $vimMetaLoad )
    }
    $vimMetaLoad
} # }}}

function vimfallback { # {{{
    write-output $nullstr
    $errmsg = "OUCH<vimfallback>:[ ** CURRENT HOSTNAME APPEARS TO BE $localhost ** ]"
    write-Host -ForegroundColor Red $errmsg
    write-output $nullstr
    write-Host -ForegroundColor Red
    $errmsg = "** [ $gooeyvimexe ] DOES NOT APPEAR BE A FILE ON $localhost **"
    write-Host -ForegroundColor Red $errmsg
    write-output $nullstr
    $wordpad = shortname '$pfd/windows NT/Accessories/wordpad.exe'
    if ( $nullstr -ne $wordpad ) {
        foreach( $component in $args ) {
            $expression2invoke = $wordpad + $space + $(sqlquote $component)
            invoke-Expression $expression2invoke
        }
    }
} # }}}

function cqjava { # {{{
    $exe2run = shortname $pfdL/IBM/RationalSDLC/common/JAVA5.0/jre/bin/java.exe
    $expression2invoke = $exe2run + $space + $args
    . $exe2run $args
} # }}}

function starteclipse { # {{{
    if ( Test-Path -path $eclipseimage -PathType leaf ) {
        $originalLocation = $PWD
        setdir $eclipseDir
        #
        # eclipse will not run with any of...
        #
        #    $pfxL/java/jdkl.6.0_18/jre/bin
        #    $pfxL/java/jdkl.6.0_18/bin
        #    $pfdL/java/jdkl.6.0_18/jre/bin
        #    $pfdL/java/jdkl.6.0_18/bin
        #
        # ...in the path, unless the vm is explicitely called out.
        #    go figure.
        #
        invoke-Expression "$eclipseimage -vm $eclipsevm"
        Set-Location $originalLocation
    }
    else {
        $errMsg = $newline + "NOT FOUND:: [ $eclipseimage ]"
        write-Host -ForegroundColor Red $errmsg
        write-output $nullstr
    }
} # }}}

function vvv { # {{{
    # {{{
    # call gvim in a round about way.
    # the striking thing about this line
    # is that in order to make sure
    # parsevimargs gets the same arguments
    # as vvv you must:
    # parsevimargs @args
    # because:
    # parsevimargs $args
    #
    # *WILL NOT WORK*
    #
    # I suspect this is a deep dark secret
    # of powershell. I did not see it documented
    # anywhere, but I thought I`d give it a try
    # and @args *does* work. it is best not to
    # argue with success.
    # }}}

    $iGottaGoBak = $false
    if ( ( currentDirectory      ) -match $notAfileSystemRE    ) {
        $iGottaGoBak = $true
        Push-Location $initialDirectory
    }

    $metaFile = $( $input | parsevimargs @args )

    if ( Test-Path -path $gooeyvimexe -PathType leaf )         {
        $cmd2run = "$gooeyvimexe -u $vimprofile $metaFile"
        write-Host -ForegroundColor DarkYellow $cmd2run
        Invoke-Expression $cmd2run
    }
    else {
        vimfallback @args
    }

    if ( $iGottaGoBak ) {
        Pop-Location
        $iGottaGoBak = $false
    }
} # }}}

function vvvr { # {{{
    $iGottaGoBak = $false
    if ( ( currentDirectory ) -match $notAfileSystemRE ) {
        $iGottaGoBak = $true
        Push-Location $initialDirectory
    }

    $metaFile = $( $input | parsevimargs @args )

    if ( Test-Path -path $gooeyvimexe -PathType leaf ) {
        $cmd2run = "$gooeyvimexe -u $vimprofile -R $metaFile"
        write-Host -ForegroundColor DarkYellow $cmd2run
        Invoke-Expression $cmd2run
    }
    else {
        vimfallback @args
    }

    if ( $iGottaGoBak ) {
        Pop-Location
        $iGottaGoBak = $false
    }
} # }}}

function vv { # {{{
    $iGottaGoBak = $false
    if ( ( currentDirectory ) -match $notAfileSystemRE ) {
        $iGottaGoBak = $true
        Push-Location $initialDirectory
    }

    $metaFile = $( $input | parsevimargs @args )

    if ( Test-Path -path $crunchyvimexe -PathType leaf ) {
        $cmd2run = "$crunchyvimexe -u $vimprofile $metaFile"
        write-Host -ForegroundColor DarkYellow $cmd2run
        Invoke-Expression $cmd2run
    }
    else {
        vimfallback @args
    }

    if ( $iGottaGoBak ) {
        Pop-Location
        $iGottaGoBak = $false
    }
} # }}}

function vvr { # {{{
    $iGottaGoBak = $false
    if ( ( currentDirectory ) -match $notAfileSystemRE ) {
        $iGottaGoBak = $true
        Push-Location $initialDirectory
    }

    $metaFile = $( $input | parsevimargs @args )

    if ( Test-Path -path $crunchyvimexe -PathType leaf ) {
        $cmd2run = "$crunchyvimexe -u $vimprofile -R $metaFile"
        write-Host -ForegroundColor DarkYellow $cmd2run
        Invoke-Expression $cmd2run
    }
    else {
        vimfallback @args
    }

    if ( $iGottaGoBak ) {
        Pop-Location
        $iGottaGoBak = $false
    }
} # }}}

function absrmpw { # {{{
    $image = s2bs( "$bin/AnyBizSoft/PDFPasswordRemover/PDFPasswordRemover.exe" )
    invoke-expression -command $image
} # }}}

function  __displayHistory { # {{{
    $fnCtl = $args;
    if ( 1 -eq $fnCtl.count ) {
        #
        # the caller ( one of hh, hhh, hhhh )
        # did not receive any filter on the
        # command line. so create the filter
        # that accepts everything.
        #
        $fnCtl = ( ".", $args[ 0 ] )
    }
    Get-History -count $fnCtl[ 1 ] | foreach {
        $hisObj = $_
        $cmdld = $hisObj.id
        $cmdLine = $hisObj.CommandLine
        #
        # split multi-line commands into an array
        # so that I can better control the display
        # of those lines.
        #
        $cmdLineArray = $cmdLine -split '[\n\r]+'
        if ( $cmdLine -match $fnCtl[ 0 ] ) {
            foreach ( $l in $cmdLineArray ) {
                write-Output "$cmdld$htab$l"
            }
        }
    }
} # }}}

function hh { # {{{
    #
    # __displayHistory will accept 1 or 2 arguments.
    # if it receives 2 arguments then 1 of them is passed
    # through from hh, hhh, or hhhh. That argument is a
    # string which __displayHistory filters on.
    #
    # hh and friends will append the number parameter either
    # on to an empty array or onto an array that contains
    # a filter string.
    #
    $args += 64;
    __displayHistory @args
} # }}}

function hhh { # {{{
    $args += 256;
    __displayHistory @args
} # }}}

function hhhh { # {{{
    $args += $MaximumHistorycount;
    __displayHistory @args
} # }}}

function clenv1 { # {{{
    #
    # environment for clion
    #
    pathrm C:/unx/msys64/mingw64/bin
    pathrm C:/unx/msys64/usr/bin
    pathrm C:/git/bin
    if (Test-Path variable:global:PYTHONHOME) {
        Remove-Item variable:global:PYTHONHOME
    }
    if (Test-Path variable:global:PYTHONHOMEL) {
        Remove-Item variable:global:PYTHONHOMEL
    }
    if (Test-Path Env:/PYTHONHOME) {
        Remove-Item Env:/PYTHONHOME
    }
    if (Test-Path Env:/PYTHONHOMEL) {
        Remove-Item Env:/PYTHONHOMEL
    }
    $GLOBAL:consoleTitleMode = 'ClEnvPath'
    $RawUI = (get-host).UI.RawUI
    $RawUI.backgroundcolor = 'DarkMagenta'
    SetConsolewindowTitle
    clear-Host

} #}}}

function clpath { # {{{
    $heredoc = @"
    PATH
    $din
    $bin
    $sqlite
    $adb
    $sysinternals
    $bin/JetBrains/PyCharm/bin
    $bin/JetBrains/CLion/bin
    $bin/7Zip
    $bin/Vim/vim74
    $bin/PuTTY
    $bin/jdk1.8.0.40/bin
    $abwL/eclipse
    $abwL/sdk/platform-tools
    $j7d
    $ekd
    $pfdL/firefox
    $spc/bin
    $sby/bin
    $sby/site/bin
    $pyd
    $pyd/Lib
    $pyd/Tools/Scripts
    $pyd/Scripts
    $win/system32
    $win
    $win/System32/Wbem
    $win/system32/WindowsPowerShell/v1.0
    $pfdL/QuickTime/QTSystem
    $pfxL/Common Files/Microsoft Shared/Windows Live
    $pfdL/Common Files/Microsoft Shared/Windows Live
    $win/system32
    $win
    $win/System32/Wbem
    $win/System32/WindowsPowerShell/v1.0
    $pfdL/Windows Live/Shared
    $bin/WIDCOMMbluetooth
    $bin/WIDCOMMbluetooth/syswow64
    $pfdL/Microsoft SQL Server/100/Tools/Binn
    $pfxL/Microsoft SQL Server/100/Tools/Binn
    $pfxL/Microsoft SQL Server/100/DTS/Binn
    $pfdL/Windows Live/Writer
    $pfdL/Calibre2
    $xbn
    $bin/qchat
"@
    ingest $heredoc
}   # }}}

function pypath { # {{{
    $heredoc = @"
    PYTHONPATH
    $bin
    $bin/PyCharmPro/debug-eggs/pycharm-debug-py3k
    $bin/JetBrains/PyCharm/debug-eggs/pycharm-debug-py3k
"@
    ingest $heredoc
} # }}}

function clenv { # {{{
    #
    # environment for clion
    #
    if (Test-Path variable:global:PYTHONHOME) {
        Remove-Item variable:global:PYTHONHOME
    }
    if (Test-Path variable:global:PYTHONHOMEL) {
        Remove-Item variable:global:PYTHONHOMEL
    }
    if (Test-Path Env:/PYTHONHOME) {
        Remove-Item Env:/PYTHONHOME
    }
    if (Test-Path Env:/PYTHONHOMEL) {
        Remove-Item Env:/PYTHONHOMEL
    }
    clpath
    $GLOBAL:consoleTitleMode = 'ClEnvPath'
    $RawUI = (get-host).UI.RawUI
    $RawUI.backgroundcolor = 'DarkMagenta'
    SetConsolewindowTitle
    clear-Host

} #}}}

function vsenv { # {{{
    $envChain = @()

    $envChain += @"
    DevEnvDir
    $bin/VisualStudio14_0/Common7/IDE
"@

    $envChain += @"
    FrameworkDIR32
    $win/Microsoft.NET/Framework
"@

    $envChain += @"
    FrameworkDIR64
    $win/Microsoft.NET/Framework64
"@

    $envChain += @"
    INCLUDE
    $bin/VisualStudio14_0/VC/INCLUDE
    $pfdL/Windows Kits/10/include/10.0.10240.0/ucrt
    $pfdL/Windows Kits/NETFXSDK/4.6/include/um
    $pfdL/Windows Kits/10/include/10.0.10240.0/shared
    $pfdL/Windows Kits/10/include/10.0.10240.0/um
    $pfdL/Windows Kits/10/include/10.0.10240.0/winrt
"@

    $envChain += @"
    LIB
    $bin/VisualStudio14_0/VC/LIB/amd64
    $pfdL/Windows Kits/10/lib/10.0.10240.0/ucrt/x64
    $pfdL/Windows Kits/NETFXSDK/4.6/lib/um/x64
    $pfdL/Windows Kits/10/lib/10.0.10240.0/um/x64
"@

    $envChain += @"
    LIBPATH
    $win/Microsoft.NET/Framework/v4.0.30319
    $bin/VisualStudio14_0/VC/LIB/amd64
    $pfdL/Windows Kits/10/UnionMetadata
    $pfdL/Windows Kits/10/References
    $pfdL/Windows Kits/10/References/Windows.Foundation.UniversalApiContract/1.0.0.0
    $pfdL/Windows Kits/10/References/Windows.Foundation.FoundationContract/1.0.0.0
    $pfdL/Windows Kits/10/References/indows.Networking.Connectivity.WwanContract/1.0.0.0
"@

    $envChain += @"
    NETFXSDKDir
    $pfdL/Windows Kits/NETFXSDK/4.6
"@

    $envChain += @"
    PATH
    $bin
    $sqlite
    $adb
    $sysinternals
    $bin/JetBrains/CLion/bin
    $bin/7Zip
    $bin/Vim/vim74
    $bin/PuTTY
    $pyd
    $pyd/Lib
    $pyd/Tools/Scripts
    $pyd/Scripts
    $win/system32/WindowsPowerShell/v1.0
    $bin/VisualStudio14_0/Common7/IDE/CommonExtensions/Microsoft/TestWindow
    $pfdL/MSBuild/14.0/bin
    $bin/VisualStudio14_0/Common7/IDE
    $bin/VisualStudio14_0/VC/BIN/x86_amd64
    $bin/VisualStudio14_0/VC/BIN
    $bin/VisualStudio14_0/Common7/Tools
    $win/Microsoft.NET/Framework/v4.0.30319
    $bin/VisualStudio14_0/VC/VCPackages
    $bin/VisualStudio14_0/Team Tools/Performance Tools
    $pfdL/Windows Kits/10/bin/x86
    $pfdL/Microsoft SDKs/Windows/v10.0A/bin/NETFX 4.6 Tools
    $pyd/Scripts
    $pyd
    C:/ProgramData/Oracle/Java/javapath
    $pfxL/Common Files/Microsoft Shared/Windows Live
    $pfdL/Common Files/Microsoft Shared/Windows Live
    $win/SYSTEM32
    $win
    $win/SYSTEM32/WBEM
    $win/SYSTEM32/WINDOWSPOWERSHELL/V1.0
    $pfdL/Windows Kits/8.1/Windows Performance Toolkit
    $bin/Calibre2
    $bin/nodejs
    $pfxL/Microsoft SQL Server/120/Tools/Binn
    $pfdL/Windows Kits/10/Windows Performance Toolkit
    $pfxL/Intel/WiFi/bin
    $pfxL/Common Files/Intel/WirelessCommon
    $spc/bin
    $sby/bin
    $sby/site/bin
    $home/AppData/Roaming/npm
"@

    $envChain += @"
    ProgramW6432
    $pfxL
"@

    $envChain += @"
    VCINSTALLDIR
    $bin/VisualStudio14_0/VC
"@

    $envChain += @"
    VS140COMNTOOLS
    $bin/VisualStudio14_0/Common7/Tools
"@

    $envChain += @"
    VSINSTALLDIR
    $bin/VisualStudio14_0
"@

    $envChain += @"
    WindowsLibPath
    $pfdL/Windows Kits/10/UnionMetadata
    $pfdL/Windows Kits/10/References
    $pfdL/Windows Kits/10/References/Windows.Foundation.UniversalApiContract/1.0.0.0
    $pfdL/Windows Kits/10/References/Windows.Foundation.FoundationContract/1.0.0.0
    $pfdL/Windows Kits/10/References/indows.Networking.Connectivity.WwanContract/1.0.0.0
"@

    $envChain += @"
    WindowsSDK_ExecutablePath_x64
    $pfdL/Microsoft SDKs/Windows/v10.0A/bin/NETFX 4.6 Tools/x64
"@

    $envChain += @"
    WindowsSDK_ExecutablePath_x86
    $pfdL/Microsoft SDKs/Windows/v10.0A/bin/NETFX 4.6 Tools
"@

    $envChain += @"
    WindowsSdkDir
    $pfdL/Windows Kits/10
"@

    foreach ( $entry in $envChain ) { # {{{
        ingest $entry
    } # }}}

    ePlant windows_tracing_logfile C:/BVTBin/Tests/installpackage/csilogfile.log
    ePlant WindowsSDKLibVersion 10.0.10240.0
    ePlant WindowsSDKVersion 10.0.10240.0
    ePlant windows_tracing_flags 3
    ePlant VisualStudioVersion 14.0
    ePlant FrameworkVersion v4.0.30319
    ePlant FrameworkVersion32 v4.0.30319
    ePlant FrameworkVersion64 v4.0.30319
    ePlant Framework40Version v4.0
    ePlant consoleTitleMode 'ClEnvPath'

    $RawUI = (get-host).UI.RawUI
    $RawUI.backgroundcolor = 'DarkMagenta'
    SetConsolewindowTitle
    clear-Host

} #}}}

function lnxDell { # {{{
    putty -v -load bessetteNomad0 -2
}   # }}}

function philomena { # {{{
    putty -v -load Philomena -2
}   # }}}

function florian { # {{{
    putty -v -load florianjpk -2
}   # }}}

function RBellarmine { # {{{
    putty -v -load RBellarmine -2
}   # }}}

function cascia { # {{{
    putty -v -load Cascia -2
}   # }}}

function wojtyla { # {{{
    putty -v -load wojtyla -2
}   # }}}

function cyril { # {{{
    putty -v -load cyrilRJ45 -2
}   # }}}

function andre { # {{{
    putty -v -load bessetteNomadRJ45 -2
}   # }}}


function xl { # {{{
    #
    # run excel 2007 from command line
    #
    $image = shortname "$pfd/Microsoft/Office 2010/Officel4/excel.exe"
    $param = nSpc $( bs2s "$args" )
    if ( Test-Path -path $image ) {
        . $image $param
    }
    else {
        write-error "HOSTNAME: $localhost [CANNOT FIND] $image"
    }
} # }}}

function pgui { # {{{
    #
    # Start powergui for powershell debugging
    #
    $originalLocation = $pwd
    setdir c:/doc
    $longImageName = "c:/i_hope_this_file_does_not_exist"
    $i0 = "$pfd/PowerGUI/ScriptEditor.exe"
    $i1 = "$bin/PowerGUI/ScriptEditor.exe"
    if ( Test-Path -path "$i0" -PathType leaf ) {
        $longImageName = $i0
    }
    if ( Test-Path -path "$i1" -PathType leaf ) {
        $longImageName = $i1
    }
    $image = s2bs $longImageName
    if ( Test-Path -path $image ) {
        $param = nSpc $( bs2s "$args" )
        invoke-expression -command "start $image $param"
    }
    else {
        write-error "HOSTNAME: $localhost [CANNOT FIND] $i0 or $i1"
    }
    Set-Location $originalLocation
} # }}}

function mail { # {{{
    #
    # run word 2007 from command line
    #
    $originalLocation = $pwd
    setdir c:/doc
    $longImageName = "$pfd/Microsoft/Office 2010/Office14/outlook.exe"
    $image = shortname $longImageName
    if ( Test-Path -path $image ) {
        $param = nspc $( bs2s "$args" )
        . $image $param
    }
    else {
        write-error "HOSTNAME: $localhost [CANNOT FIND] $longImageName"
    }
    Set-Location $originalLocation
} # }}}

function xx { # {{{
    c:/Windows/explorer.exe $pwd
} # }}}

function ww { # {{{
    #
    # run word 2007 from command line
    #
    $image = shortname "$pfd/Microsoft/Office 2010/0fficel4/winword.exe"
    if ( Test-Path -path $image ) {
        $param = nSpc $( bs2s "$args" )
        . $image $param
    }
    else {
        write-error "hostname; $localhost [cannot find] $image"
    }
} # }}}

function aqrev { # {{{
    setdir "$pfdL/AccuRev/bin"
    $image = shortname "$pfdL/AccuRev/bin/acgui.exe"
    . $image
} # }}}

function displayChildren( $typeFilter ) { # {{{
    #
    # generate output like...
    #
    # F 2009.07.13.21.39.25 000000193536 notepad.exe
    # F 2009.07.13.21.39.39 000000044032 psxrun.exe
    # F 2009.07.13.21.39.57 000000010240 write.exe
    # F 2010.11.20.04.24.28 000000071168 bfsvc.exe
    # F 2010.11.20.04.24.46 000002872320 explorer.exe
    #
    # .. ,or.,.
    #
    # D 2012.11.02.05.41.57 000000000000 C:/Windows/lnstaller
    # D 2012.11.04.21.11.28 000000000000 C:/windows/inf
    # D 2012.11.26.11.31.42 000000000000 C:/windows/Temp
    # D 2012.11.26.16.01.07 000000000000 C:/windows/Prefetch
    # F 1998.10.29.17.45.06 000000306688 C:/windows/lsUninst.exe
    # F 2005.04.13.10.24.52 000000036864 C:/Windows/ismifcom.dll
    # F 2009.02.12.12.14.56 000000000662 C:/Windows/view.bat
    # F 2009.02.12.12.14.56 000000000658 C:/Windows/vim.bat
    # F 2009.02.12.12.14.56 000000000987 C:/windows/gvimdiff.bat
    #
    $input | foreach {
        $iObj = $_
        $pathstring = $nullstr
        $iObj | Get-Member -Name "PSPath" | foreach {
            #
            # extract the path string from the input object
            #
            $pathString = $iobj.PSPath -replace $getPSPathRE, '$1'
        }

        if ( $nullstr -eq $pathstring ) {
            $m = $nullstr
            $m += $newline
            $m += $newline
            $m += "<<< displayChildren >>> input is B0GUS!!"
            $m += $newline
            $m += $newline
            write-Host -ForegroundColor Red $m
        }
        else {
            $eTag = 'F'

            if ( Test-Path -LiteralPath $pathstring -PathType container ) {
                $eTag = 'D'
            }

            if ( $typeFilter -match $eTag ) {
                #
                # this particular directory iobj matches what the
                # caller asked for
                #
                switch -regex ( $typeFilter ) {
                    '(?six: \A ; )' {
                        $itemName = ($iobj.PSChildName).ToString() # name only
                    }
                    '(?six: \A : )' {
                        $itemName = ($iObj.FullName).ToString() # Name with directory
                    }
                    default {
                        $itemName = ($iObj.FullName).ToString() # Name with directory
                    }
                }

                $itemName2Display = dSpc $itemName
                if ( $typeFilter -match '(?sx: \A .? [FD] 1 \z )' ) {
                    #
                    # caller has requested a short listing
                    #
                    write-output "$itemName2Display"
                }
                else {
                    #
                    # caller has requested a full listing
                    #
                    $whenever = "{0:yyyy.MM.dd.HH.mm.ss}" -f $iobj.LastwriteTime
                    $eLength = 0
                    if ( "F" -eq $eTag ) {
                        #
                        # element is a file
                        # (windows does not make much use of links like unix)
                        #
                        $eLength = $iobj.Length
                    }
                    $eSize = "{0:D12}" -f $eLength
                    write-output "$eTag $whenever $eSize $itemName2Display"
                }
            }
        }
    }
} # }}}

function displayChildrenFromxml ( $xmltempfilename, $typeFilter ) { # {{{
    import-Clixml $xmltempfilename |
    foreach {
        $entry = $_
        $itemName = ($entry.FullName).ToString()
        $itemName2Display = dSpc $itemName
        $whenever = "{0:yyyy.MM.dd.HH.mm.ss}" -f $entry.LastWriteTime
        $eLength = 0
        $eTag = "D"
        if ( -not ( Test-Path -path $itemName -PathType container ) ) {
            $eLength = $entry.Length
            $eTag = "F"
        }
        $esize = "{0:D12}" -f $eLength
        if ( $typeFilter -match $eTag ) {
            write-output "$eTag $whenever $eSize $itemName2Display"
        }
    }
} # }}}

function ll { # {{{
    #
    # long listing with directories listed first
    #
    Get-ChildItem -Force $( nspc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ":D"

    Get-ChildItem -Force $( nspc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ":F"
} # }}}

function ll1c { # {{{
    #
    # 1column listing with directories listed first
    #
    Get-ChildItem -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    Sort LastWriteTime |
    displayChildren ":D1"

    Get-ChildItem -Force $( nspc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ":F1"
} # }}}

function lf1c { # {{{
    #
    # short listing with files only
    #
    Get-ChildItem -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ":F1"
} # }}}

function ld1c { # {{{
    #
    # short listing with directories only
    #
    Get-ChildItem -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ":D1"
} # }}}

function ls1c { # {{{
    #
    # short (name only) listing with directories listed first
    #
    Get-ChildItem -Force $( nspc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ":D1"

    Get-ChildItem -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ":F1"
} # }}}

function llf { # {{{
    #
    # long listing (name only) with files only
    #
    Get-ChildItem -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    Sort LastWriteTime |
    displayChildren ";F"
} # }}}

function llff { # {{{
    #
    # long listing (full path) with files only
    #
    Get-ChildItem -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ":F"
} # }}}

function lld { # {{{
    #
    # long listing (name only) with directories only
    #
    Get-Childitem -Force $( nspc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    displayChildren ";D"
} # }}}

function lldd { # {{{
    #
    # long listing ( full path ) with directories only
    #
    Get-ChildItem -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    sort LastwriteTime |
    displayChildren ":D"
} # }}}

function lslrdL { # {{{
    #
    # recursively descend listing only directory names
    #
    Get-ChildItem -Recurse -Force $( nspc $( bs2s $( [string]$args ) ) ) |
    foreach {
        $entry = $_
        $itemName = ($entry.FullName).ToString()
        $itemName2Display = dspc $itemName
        if ( Test-Path -path $itemName -PathType container ) {
            write-output "$itemName2Display"
        }
    }
} # }}}

function lslrld { # {{{
    lslrdL @args
} # }}}

function lslrfL { # {{{
    #
    # recursively descend listing only file names
    #
    Get-ChildItem -Recurse -Force $( nspc $( bs2s $( [string]$args ) ) ) |
    foreach {
        $entry = $_
        $itemName = ($entry.FullName).ToString()
        $itemName2Display = dSpc $itemName
        if ( -not ( Test-Path -path $itemName -PathType container ) ) {
            write-output "$itemName2Display"
        }
    }
} # }}}

function lslrlf { # {{{
    lslrfL @args
} # }}}

function lslr { # {{{
    #
    # recursively descend listing all files and directories
    #
    Get-ChildItem -Recurse -Force $( nspc $( bs2s $( [string]$args ) ) ) |
    foreach {
        $entry = $_
        $itemName = ($entry.FullName).ToString()
        $itemName2display = dspc $itemName
        $whenever = "{0:yyyy.MM.dd.HH.mm.ss}" -f $entry.LastwriteTime
        $eLength = 0
        $eTag = "D"
        if ( -not ( Test-Path -path $itemName -PathType container ) ) {
            $eLength = $entry.Length
            $eTag = "F"
        }
        $eSize = "{0:D12}" -f $eLength
        write-output "$eTag $whenever $eSize $itemName2display"
    }
} # }}}

function __dSend { # {{{
    while ( "Array" -eq $args.gettype().BaseType.name ) {
        #
        # $args is a very special variable.
        # It may change when a pipeline is executed.
        # Posh does it all under the covers.
        # So I cannot count on it very far beyond
        # the top of the subroutine.
        #
        # Posh stuffs subroutine arguments in nested
        # arrays. I need to be able to call dSend
        # with either a real string or a real filesystem
        # object. But first I need to get it out of the
        # array.
        #
        $args = $args[0]
        $inpArg = $args
    }

    if ( $null -ne $(Get-Member -Name "FullName" -inputObject $inpArg ) ) {
        $pathstring = $inpArg.FullName
    }
    elseif ( $null -ne $(Get-Member -Name "PSPath" -inputObject $inpArg ) ) {
        $pathstring = $inpArg.PSPath -replace $getPSPathRE, '$1'
    }
    else {
        $pathstring = enSpace $( bs2s $inpArg )
    }

    gci -force $pathstring | foreach {
        $iobj = $_
        $pathstring = $iObj.PSPath -replace $getPSPathRE, '$1'
        $dateString = "{0:yyyy.MM.dd.HH.mm.ss}" -f $iObj.LastwriteTime
        if ( $iobj.mode -match '^d' ) {
            $sizeString = "{0:D12}" -f 0
            "D $dateString $sizestring " + $(deSpace $pathstring)
            # see section 5.8.4 (page 193)
            #
            # of...
            #
            # windows PowerShell in Action, Second Edition
            # author BRUCE PAYETTE
            # ISBN 9781935182139
            #
            # ...for a description of "splatting a variable"
            #
            __dSend @iObj
        }
        else {
            $sizeString = "{0:D12}" -f $iObj.length
            "F $dateString $sizestring " + $(deSpace $pathstring)
        }
    }
} # }}}

function dSend { #{{{
    #
    # recursively descend a directory tree
    # without using the -recurse commandline option
    #
    # sort entries by name
    #
    $inpArgs = $args
    $prefix = usrHost
    $uniq = rnd32bit
    $fnPrefix = "$cmdHistoryTmpD/$prefix.$uniq"
    $logfname = "$fnPrefix.a.cointoss"
    $errfname = "$fnPrefix.b.cointoss"
    $srtfname = "$fnPrefix.c.cointoss"
    #
    #-------------------------------------------
    #
    # see section 5.8.4 (page 193)
    #
    # of...
    #
    # windows PowerShell in Action, Second Edition
    # author BRUCE PAYETTE
    # ISBN 9781935182139
    #
    # ...for a description of "Splatting a variable"
    #
    if ( 0 -eq $inpArgs.count ) {
        #
        # push symbol that represents current filesystem directory
        # ( result of Get-Location ) into the $inpArgs array
        #
        $inpArgs += "."
    }
    __dSend @inpArgs > $logfname 2> $errfname
    #
    #--------------------------------------------------------vv
    $pattern = [regex] '(?six: \A (?x: \S+\s+ ){3} (.+) \z) '
    #--------------------------------------------------------^^
    #
    # sort resulting file by full path name
    # points to the part of the pattern
    # that the sort coallates against
    #
    Get-content $logfname |
    Sort-Object {
        if ( $_ -match $pattern ) {
            $matches[ 1 ]
        }
    } > $srtfname

    bs2s $srtfname
} # }}}

function treekly { #{{{
    #
    # recursively descend a directory tree
    # without using the -recurse commandline option
    #
    # Sort entries by name
    #
    $inpArgs = $args
    $prefix = usrHost
    $uniq = rnd32bit
    $fnPrefix = "$cmdHistoryTmpD/$prefix.$uniq"
    $logfname = "$fnPrefix.a.cointoss"
    $errfname = "$fnPrefix.b.cointoss"
    $srtfname = "$fnPrefix.c.cointoss"
    #
    #------------------------------------------
    #
    # see section 5.8.4 (page 193)
    #
    # of...
    #
    # windows Powershell in Action, Second Edition
    # author BRUCE PAYETTE
    # ISBN 9781935182139
    #
    # ...for a description of "Splatting a variable"
    #
    if ( 0 -eq $inpArgs.count ) {
        #
        # push symbol that represents current filesystem directory
        # ( result of Get-Location ) into the $inpArgs array
        #
        $inpArgs += "."
    }
    treeKlym.exe $inpArgs[ 0 ] $logfname $errfname
    #
    #--------------------------------------------------------vv
    $pattern = [regex] '(?six: \A (?x: \S+\s+ ){3} (.+) \z)'
    #--------------------------------------------------------^a
    #
    # sort resulting file by full path name
    # points to the part of the pattern
    # that the sort coallates against
    #
    C:/windows/SUA/common/sort.exe -o $srtfname -k 4 $logfname
    # Get-content $logfname |
    # Sort-Object {
    # if ( $_ -match $pattern ) {
    # $matches[ 1 ]
    # }
    # } > $srtfname
    #
    bs2s $srtfname
} # }}}

function lslr2xml { # {{{
    #
    # recursively descend listing all files and directories
    # by creating an intermediate xml file
    #
    $xmltemp = bs2s "$env:TEMP/$( usrHostTStampPid ).lslrxml.xml"

    Get-ChildItem -Recurse -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    export-clixml $xmltemp

    displayChildrenFromXml $xmltemp "DF"
    write-output $nullstr
    write-Host -Foregroundcolor green $xmltemp
    write-Output $nullstr
} # }}}

function llf2xml { # {{{
    $xmltemp = bs2s "$env:TEMP/$( usrHostTStamppid ).llfxml.xml"

    Get-ChildItem -Force $( nSpc $( bs2s $( [string]$args ) ) ) |
    Sort LastwriteTime |
    export-clixml $xmltemp

    displayChildrenFromxml $xmltemp "F"
} # }}}

function dts { # {{{
    get-date -uformat %s
} # }}}

function sqlgui { # {{{

    $errMsg = @()
    $i = @()
    $i += "$pfdL/Microsoft SQL Server/100/Tools/Binn/VSShell/Common7/IDE/Ssms.exe"
    $i += "$pfdL/Microsoft SQL server/90/Tools/Binn/VSShell/Common7/IDE/Sqlwb.exe"
    $i += "$pfxL/Microsoft SQL Server/90/Tools/binn/VSShell/Common7/IDE/Sqlwb.exe"

    $imageNotFound = $true
    :out foreach ( $image in $i ) {
        if ( Test-Path -path $image -PathType leaf ) {
            $imageNotFound = $false
            $pgm = shortname $image
            . $pgm
            break out;
        }
        else {
            $errMsg += "0UCH<sqlgui>:[ $image ] does not appear to BE a file."
        }
    }

    if ( $imageNotFound ) {
        write-Host $( $newline * 3 )
        foreach ( $gripe in $errMsg ) {
            write-Host -ForegroundColor Red $gripe
            Write-Host $newline
        }
        write-Host $( $newline * 2 )
    }

} # }}}

function sql { # {{{
    $sqlcmdfile = $args
    $errMsg = @()

    $i = @()
    $i += "$pfxL/Microsoft SQL server/100/Tools/Binn/SQLCMD.EXE"
    $i += "$pfxL/Microsoft SQL Server/90/Tools/Binn/SQLCMD.EXE"
    $i += "$pfdL/Microsoft SQL Server/90/Tools/Binn/SQLCMD.EXE"

    $imageNotFound = $true
    :out foreach ( $image in $i ) {
        if ( Test-Path -path $image -PathType leaf ) {
            $s_image = shortname $image
            if ( Test-Path -path $sqlcmdfile -PathType leaf ) {
                invoke-Expression "$s_image $sqlcmdfile"
                $imageNotFound = $false
            }
            else {
                $errMsg += "OUCH<sql>:[ $sqlcmdfile ] DOES NOT APPEAR TO BE A FILE."
            }
            break out;
        }
        else {
            $errMsg += "0UCH<sql>:[ $image ] DOES NOT APPEAR TO BE A FILE."
        }
    }

    if ( $imageNotFound ) {
        write-Host $( $newline * 3 )
        foreach ( $gripe in $errMsg ) {
            write-Host -ForegroundColor Red $gripe
            write-Host $newline
        }
        write-Host $( $newline * 2 )
    }

} # }}}

function create_sql_rs_command_file { # {{{
    $prefix = $GVtsprefix
    $commandfile = bs2s "$env:TEMP/$prefix.restore.sql"

    write-output $nullstr > $commandfile

    $args | foreach {
        $db_name = $_
        $description = "$prefix.$db_name.dat"
        $bkFileName = "k:/$uid/$description"
        $bkFileName = bs2s $bkFileName
        $bkFileName = sqlquote $bkFileName

        $command = "restore database $db_name from disk = " + $bkFileName

        write-output $command >> $commandfile
    }
    $commandfile
} # }}}

function create_sql_bk_command_file { # {{{

    $prefix = $GVtsprefix
    $commandfile = bs2s "$env:TEMP/$prefix.cqbk.sql"

    write-output $nullstr > $commandfile


    $args | foreach {
        $db_name = $_
        $description = "$prefix.$db_name.dat"
        $bkFileName = "k:/$uid/$description"
        $bkFileName = bs2s $bkFileName
        $bkFileName = sqlquote $bkFileName
        $description = sqlquote "$description FULL"

        $command = "backup database $db_name to disk = " +
        $bkFileName +
        " with description = " +
        $description +
        ", copy_only;"

        write-output $command >> $commandfile
    }

    $sqlfile = create_sql_rs_command_file @args
    cp $sqlfile $initialDirectory

    $commandfile
} # }}}

function xpire { # {{{
    Param (
    [Parameter(Position=0, Mandatory=$true)]
    [System.object]$maxDaysSinceModified,
    [Parameter(Position=1, Mandatory=$true)]
    [System.object]$nominationList
    )

    $whenever = [DateTime]::Now
    $what2fetch = $nominationList

    $elementObjects = Get-ChildItem -Force $what2fetch -ErrorAction silentlycontinue
    if ( $null -ne $elementObjects ) {
        foreach ( $fileObj in $elementobjects ) {
            if ( $null -ne $fileObj ) {
                $daysold = ( $whenever - $fileObj.LastwriteTime ).Days
                if ( $daysold -gt $maxDayssinceModified ) {
                    $candidate = $fileObj.fullname
                    write-output $candidate >> $expiredFiles
                }
            }
        }
    }
    else {
        $errormessage = "OUCH<xpire>:[ " +
        $dollar +
        "xpire::nominationList -> $what2fetch ] IS EMPTY."

        write-Output $nullstr
        Write-Host -ForegroundColor Red $errormessage
        write-Output $nullstr
    }

} # }}}

function gatherCmdHistories { # {{{
    #
    # This is part of the better solution to put each command into itz own file.
    # This allows multiple powershell windows with all commands preserved.
    # So..., Gather all 'single command' xml files from the temp directory
    # except those that come from the currently active process ( since
    # powershell already has them cached )
    #
    $whenever = [DateTime]::Now
    $cmd2Gather = bs2s "$cmdHistoryTmpD/$( usrHost ).*.pshcmd.xml"
    $skipRE = usrHostTStampPidRE
    Get-ChildItem -Force $cmd2Gather      |
    Sort LastWriteTime      |
    foreach {
        $fileObj = $_
        if ( $fileObj.name -notmatch $skipRE ) {
            import-CliXml $_.fullname | Add-History
        }
    }

    #
    # I have been integrating some of these potentialy stray files
    # into my history for many days if they have not got in yet then they
    # probably never will. This gets called every time I formally exit
    # powershell with "exit" so, if I do not clean up my stored commands
    # it will take longer and longer to exit as time passes. This
    # prepares the deletion in 'function nukearchiology'
    # pshcmd.xml
    xpire 120 "$vimBackupDir/*"
    xpire  16 "$cmd2Gather"
    xpire  16 "$cmdHistoryTmpD/$( usrHost ).*.command_history.xml"
    xpire  16 "$cmdHistoryLclD/$localhost.directory_stack.*.xml"
    xpire  16 "$cmdHistoryLclD/$localhost.command_history.*.xml"
    xpire  16 "$cmdHistoryNetD/$localhost.command_history.*.xml"
    xpire  16 "$transcriptdir/pwrshl.$localhost.*.log"
    xpire   3 "$cmdHistoryTmpD/$( usrHost ).*.vimtmp.*"
    xpire   3 "$cmdHistoryTmpD/$( usrHost ).*.pshcmd.xml"
    xpire   3 "$cmdHistoryTmpD/$uid.*.cointoss"
    xpire   3 "$cmdHistoryTmpD/$uid.*.daolatem"
    xpire   3 "$cmdHistoryTmpD/$uid.*.MAYBE-UTF-8.txt"
} # }}}

function retrievecmdHistory { # {{{
    $sh = "$args/$localhost.command_history.xml"
    $stored_command_history = bs2s $sh
    if ( Test-Path -path $stored_command_history ) {
        import-CliXml $stored_command_history | Add-History
    }
    else {
        write-Output "retrieveCmdHistory: $stored_command_history not found"
    }
} # }}}

function saveLastCommand { # {{{
    $w2s = "$cmdHistoryTmpD/" +
    "$( usrHostTStampPid ).pshcmd.xml"

    $where2save = bs2s $w2s
    #
    # This is part of the better solution to put each command into itz
    # own file. This allows multiple powershell windows with all commands
    # preserved. Now I know how to do that. PJK20110726
    #
    Get-History -Count 1 | Export-Clixml $where2save
} # }}}

function gathercmdHistory { # {{{
    gathercmdHistories
    $where2write = bs2s "$cmdHistoryTmpD/$( usrHostTStampPid ).command_history.xml"
    #
    # get unique command history lines and preserve the
    # most recently executed of the duplicates
    #
    Get-History -Count 32767                                 |
    sort-object -property StartExecutionTime -descending   |
    Group CommandLine                                      |
    Foreach { $_.Group[0] }                                |
    sort-object -property StartExecutionTime               |
    Export-Clixml $where2write

    $where2write
} # }}}

function saveCmdHistory { # {{{
    Param (
    [Parameter(Position=0, Mandatory=$true)]
    [System.object]$historyFromTempDir,
    [Parameter(Position=1, Mandatory=$true)]
    [System.object]$historyFinalDestination
    )
    $lclstamp = mststamp

    $errormessage = $nullstr
    :out do {
        if ( $historyFromTempDir -notmatch '(?six: \S )' ) {
            $errormessage += "OUCH:<saveCmdHistory>[ " +
            $dollar +
            "historyFromTempDir ] IS EMPTY." +
            $newline
        }
        elseif ( -not ( Test-Path -path $historyFromTempDir -PathType leaf ) ) {
            $errormessage += "OUCH:<saveCmdHistory>[ " +
            $historyFromTempDir +
            " ] DOES NOT APPEAR BE A FILE" +
            $newline
        }

        if ( $historyFinalDestination -notmatch '(?six: \S )' ) {
            $errormessage += "OUCH:<saveCmdHistory>[ " +
            $dollar +
            "historyFinalDestination ] IS EMPTY." +
            $newline
        }
        elseif ( -not ( Test-Path -path $historyFinalDestination -PathType container ) ) {
            $errormessage += "OUCH:<savecmdHistory>[ " +
            $historyFinalDestination +
            " ] DOES NOT APPEAR BE A DIRECTORY" +
            $newline
        }

        if ( $errormessage -ne $nullstr ) {
            #
            # UNCOMMENT NEXT LINE FOR FULL INFO
            #
            # $errormessage += Get-PSCallstack | Format-List | Out-string
            #
            Write-Host -ForegroundColor Red $errormessage
            break out
        }

        $prefix = "$historyFinalDestination/" +
        "$localHost.command_history"

        $where2save = bs2s "$prefix.xml"
        $where2keep = bs2s "$prefix.$lclstamp.xml"

        Copy-Item -path $historyFromTempDir -destination $where2save
        Copy-Item -path $historyFromTempDir -destination $where2keep

        $prefix = "$historyFinalDestination/" +
        "$localhost.directory_stack"

        $where2save = bs2s "$prefix.xml"
        $where2keep = bs2s "$prefix.$lclstamp.xml"

        $folderHash | Export-Clixml $where2keep
        Copy-Item -path $where2keep -destination $where2save

    } while ( $false )

} # }}}

function profileSnapshot { # {{{
    $outDir = $args
    $errormessage = $null
    #
    # provide a window to jump out of.
    # the 'do' statement is just an exit path
    #
    :out do {
        if ( 0 -eq $outDir.count ) {
            #
            # $args has nothing in it
            #
            $errormessage = "OUCH<profilesnapshot>: [ " +
            $dollar +
            "argstring ] IS EMPTY."

            Write-Output $nullstr
            write-Host -ForegroundColor Red $errormessage
            write-Output $nullstr
            break out
        }

        if ( -not ( Test-Path -path $outDir -PathType container ) ) {

            $errormessage = "OUCH<profilesnapshot>:[ $args ] " +
            "DOES NOT APPEAR BE A DIRECTORY"

            Write-Output $nullstr
            write-Host -ForegroundColor Red $errormessage
            write-Output $nullstr
            break out
        }

        $tag = $( mststamp )

        #
        # match everything after the last path separator in the string
        # to strip the directory prefix part of the file specification
        #
        $pattern =  "(?sx: \A .+? ([^" + $backslash + $backslash + $slash + "]+) \z )"

        #
        # include in this list the fully qualified path
        # for any important file that should be captured/kept
        # when powershell exits
        #
        write-Output  $profile ,
        $profilem              ,
        $cdTrail               ,
        $cdJournal             ,
        $vimprofile            ,
        $tulavnecot            |
        foreach {
            $out2save = $_
            $out2save = bs2s $out2save
            if ( Test-Path -path $out2save -PathType leaf ) {
                $outSuffix = $out2save -replace $pattern, '$1'
                $outFile = bs2s "$outDir/$tag.$outSuffix"
                Copy-Item $out2save $outFile
                if ( Test-Path -path $bzipexe -PathType leaf ) {
                    if ( $outFile -notmatch '(?six: [.] (?six: (zip)|(bz2)|(7z) ) \z )' ) {
                        #
                        # it is not already compressed so...
                        #
                        . $bzipexe $outFile
                        $bzFile = "$outFile.bz2"
                        #
                        # Thatz right. The $bzipexe I'm using
                        # preserves the original date of the file
                        # So, override that.
                        #
                        # Result of the touch is that I
                        # never expire the current copy of the file
                        # even if it is very old. That way there is
                        # always a backup copy made of the current
                        # version of the file.
                        #
                        touch $bzFile
                    }
                }
                if ( Test-Path -path $outFile -PathType leaf ) {
                    touch $outFile
                    xpire 32 "$outDir/*.$outSuffix"
                }
            }
        }
        xpire 32 "$outDir/*.bz2"

    } while ( $false )
    $errormessage
} # }}}

function initiateTranscript { # {{{
    if ( Test-Path -path $args -PathType container ) {
        $logfilename = bs2s "$args/pwrshl.$localhost.$( mststamp ).log"
        $metalog = bs2s "$args/meta.log"
        #
        # Transcript is a best-effort proposition. Debuggers do not
        # support transcripts so, fail gently for them via trap
        #
        $errmsg = $newline + $newline + "CANNOT START TRANSCRIPT" + $newline
        trap {
            write-Host -ForegroundColor Red $errmsg; continue
        } start-transcript -path $logfilename >> $metalog
    }
    else {
        write-Output( "initiateTranscript: $args not found" )
    }
} # }}}

function Prompt { # {{{
    saveLastCommand
    $id = 1

    $historyitem = Get-History -Count 1
    if( $historyitem )
    {
        $id = $historyitem.id + 1
    }
    $p00 = "`n[ $( mststamp ) $localhost $( currentDirDsply ) ]" #
    write-Host -ForegroundColor Magenta $p00
    write-Host -ForegroundColor Cyan -NoNewLine "( $id ) >  "
    setconsolewindowTitle
    "`b" #
} # }}}

function pathset { # {{{

} # }}}

function pathadd { # {{{
    $inpArg = bs2s $( nSpc $( qs $( [string]$args ) ) )
    $inpArg = $inpArg -replace '[#].*', $nullstr # trim pound sign and data after
    $inpArg = $inpArg -replace $leadingWS, $nullstr # trim leading white space
    $inpArg = $inpArg -replace $trailingWS, $nullstr # trim trailing white space
    :out do {
        if ( -not ( Test-Path -path $inpArg -PathType container ) ) {

            $msg =  "OUCH<pathadd>:[ $inpArg ] " +
            "DOES NOT APPEAR BE A DIRECTORY"

            write-Output $nullstr
            write-Host -ForegroundColor Red $msg
            write-Output $nullstr
            break out
        }
        $msg = "<pathadd>:[ $inpArg ] " +
        "LOOKS GOOD"

        write-Output $nullstr
        write-Host -ForegroundColor Green $msg
        Write-Output $nullstr

        $currentPathArray = $pathCache[ "PATH" ]
        for ( $ix = 0; $ix -lt $currentPathArray.length; $ix++ ) {
            if ( $currentPathArray[ $ix ] -eq $inpArg ) {
                $msg = "<pathadd>:[ $inpArg ] " +
                "ALREADY IN PATH. SKIPPING..."

                write-Output $nullstr
                write-Host -ForegroundColor Green $msg
                write-Output $nullstr
                break out
            }
            $currentPathArray += $inpArg
            sow PATH $currentPathArray
        }
    } until ( $true )
} # }}}

function pathrm { # {{{
    $inpArg = bs2s $( nSpc $( qs $( [string]$args ) ) )
    $inpArg = $inpArg -replace '[#].*', $nullstr # trim pound sign and data after
    $inpArg = $inpArg -replace $leadingWS,  $nullstr # trim leading white space
    $inpArg = $inpArg -replace $trailingWS,  $nullstr # trim trailing white space
    :out do {
        $entryNotFound = $true
        $currentPathArray = $pathcache[ "PATH" ]
        for ( $ix = 0; $ix -lt $currentPathArray.length; $ix++ ) {
            if ( $currentPathArray[ $ix ] -eq $inpArg ) {
                $currentPathArray[ $ix ] = "# " + $inpArg
                $entryNotFound = $false
            }
        }
        if ( $entryNotFound ) {
            $msg = "<pathrm>:[ $inpArg ] " +
            "NOT IN PATH. SKIPPING..."

            write-Output $nullstr
            write-Host -ForegroundColor Red $msg
            Write-Output $nullstr
            break out
        }
        sow PATH $currentPathArray
        $msg = "<pathrm>:[ $inpArg ] " +
        "REMOVED FROM PATH"

        write-Output $nullstr
        write-Host -ForegroundColor Green $msg
        write-Output $nullstr
    } until ( $true )
} # }}}

function pathpush { # {{{
    $inpArg = bs2s $( nSpc $( qs $( [string]$args ) ) )
    $inpArg = $inpArg -replace '[#].*', $nullstr # trim pound sign and data after
    $inpArg = $inpArg -replace $leadingWS, $nullstr # trim leading white space
    $inpArg = $inpArg -replace $trailingWS, $nullstr # trim trailing white space
    :out do {
        if ( -not ( Test-Path -path $inpArg -PathType container ) ) {

            $msg = "OUCH<pathadd>:[ $inpArg ] " +
            "DOES NOT APPEAR BE A DIRECTORY"

            write-Output $nullstr
            write-Host -ForegroundColor Red $msg
            Write-Output $nullstr
            break out
        }
        $msg =  "<pathadd>:[ $inpArg ] " +
        "LOOKS GOOD"

        write-Output $nullstr
        write-Host -ForegroundColor Green $msg
        write-Output $nullstr

        $currentPathArray = $pathcache[ "PATH" ]
        $inpArray = ,$inpArg
        $currentPathArray = $inpArray + $currentPathArray
        sow path $currentPathArray
    } until ( $true )
} # }}}

function Powershell_Exit_Processing { # {{{
    #
    # do local save first.
    # Net save could fail at end of day and
    # cause the loss of valuable history
    #
    $gatheredxmlFileName = $nullstr
    $gatheredxml = @( gatherCmdHistory )
    if ( $gatheredxml.length ) {
        $gatheredxmlFileName = $gatheredxml[ $gatheredxml.length - 1 ]
    }

    savecmdHistory $gatheredxmlFileName $cmdHistoryLclD
    $rc = profileSnapshot $psprofilBkLclD

    saveCmdHistory $gatheredxmlFileName $cmdHistoryNetD
    $rc = profileSnapshot $psprofilBkNetD


} # }}}

function pkp5 { # {{{
    $p51 =  ,"$sby/lib" +
    "$sby/site/lib"
    sow PERL5LIB $p51
} # }}}

function pkpath { # {{{
    $heredoc = @"
    PATH
    $din
    $bin
    $sqlite
    $adb
    $sysinternals
    $bin/JetBrains/PyCharm/bin
    $bin/WingIDE5.x/bin
    $bin/7Zip
    $bin/Vim/vim74
    $bin/PuTTY
    $bin/jdk1.8.0.40/bin
    $abwL/eclipse
    $abwL/sdk/platform-tools
    $j7d
    $ekd
    $pfdL/firefox
    $spc/bin
    $sby/bin
    $sby/site/bin
    $pyd
    $pyd/Lib
    $pyd/Tools/Scripts
    $pyd/Scripts
    $win/system32
    $win
    $win/System32/Wbem
    $win/system32/WindowsPowerShell/v1.0
    $pfdL/QuickTime/QTSystem
    $pfxL/Common Files/Microsoft Shared/Windows Live
    $pfdL/Common Files/Microsoft Shared/Windows Live
    $win/system32
    $win
    $win/System32/Wbem
    $win/System32/WindowsPowerShell/v1.0
    $pfdL/Windows Live/Shared
    $bin/WIDCOMMbluetooth
    $bin/WIDCOMMbluetooth/syswow64
    $pfdL/Microsoft SQL Server/100/Tools/Binn
    $pfxL/Microsoft SQL Server/100/Tools/Binn
    $pfxL/Microsoft SQL Server/100/DTS/Binn
    $pfdL/Windows Live/Writer
    $pfdL/Calibre2
    $mgw/bin
    $mgw/usr/bin
    $xbn
    $bin/SmartGit/bin
    $git
    $bin/qchat
"@
    ingest $heredoc
    pkp5
}   # }}}

function py2 { # {{{
  sow pyd "C:/py27"
  pkpath
} # }}}

function py3 { # {{{
  sow pyd "C:/Py35"
  pkpath
} # }}}


function nukesheep { # {{{
  $imgdir   = "$sys64"
  $imgList  = "$imgdir/tasklist.exe;$imgdir/taskkill.exe"
  $imgArray = $imgList -split ";"
  $i2Nuke   = "es.scr"
  try {
    foreach ( $img in $imgArray ) {
      $cmd = nSpc $( s2bs $img )
      $errmsg = "OUCH:<nukesheep>[ $cmd ] "
      $errmsg += "DOES NOT APPEAR TO BE A FILE."
      if ( -not (  Test-Path -path $cmd -PathType leaf ) ) {
        throw $errmsg
      }
    }

    $2invoke += $imgArray[0]
    $2invoke += " /fo csv /nh | "
    $2invoke += "search $( sqlquote $( dblquote $i2Nuke ) ) | "
    $2invoke += "foreach { "
    $2invoke += $imgArray[1]
    $2invoke += " /F /IM $i2Nuke}"


    try {
      Write-Host -ForegroundColor Green $2invoke
      Invoke-Expression $2invoke
    }
    catch {
      ShowErrorDetails
    }
  }
  catch {
    $errmsg = $_
    Write-Host -ForegroundColor Red $errmsg.FullyQualifiedErrorId
  }
} # }}}

function autoruns { # {{{
  $imgdir = "$env:systemdrive/Sysinternals"
  $imgexe = "autoruns.exe"
  $cmd  = "$imgdir/$imgexe"
  if ( Test-Path -path $cmd -PathType leaf ) {
    Push-Location $imgdir
    Write-Host -ForegroundColor Green $cmd
    . $cmd
    Pop-Location
  }
  else {
    $msg = "0UCH:<read>[ $cmd ] "
    $msg += "DOES NOT APPEAR TO BE A FILE."
    Write-Host -ForegroundColor Red $msg
  }
} # }}}

function procx { # {{{
  $imgdir = "$env:systemdrive/Sysinternals"
  $imgexe = "procexp.exe"
  $cmd  = "$imgdir/$imgexe"
  if ( Test-Path -path $cmd -PathType leaf ) {
    Push-Location $imgdir
    Write-Host -ForegroundColor Green $cmd
    . $cmd
    Pop-Location
  }
  else {
    $msg = "0UCH:<read>[ $cmd ] "
    $msg += "DOES NOT APPEAR TO BE A FILE."
    Write-Host -ForegroundColor Red $msg
  }
} # }}}

function blog { # {{{
  $imgdir = "$pfdL/Windows Live/Writer"
  $imgexe = "WindowsLiveWriter.exe"
  $cmd  = "$imgdir/$imgexe"
  if ( Test-Path -path $cmd -PathType leaf ) {
    Push-Location $imgdir
    Write-Host -ForegroundColor Green $cmd
    . $imgexe
    Pop-Location
  }
  else {
    $msg = "0UCH:<read>[ $cmd ] "
    $msg += "DOES NOT APPEAR TO BE A FILE."
    Write-Host -ForegroundColor Red $msg
  }
} # }}}

function rt1devenv { # {{{
} # }}}

function rt1devpath { # {{{
  vsenv
  rt1p5
  sow importRT0Path "//$sambahost/nomad/RT0"
  sow PATH $(sunder $rt1DevPath)
  ePlant GenerateDotDFiles 'YES'
  ePlant rt1ForceActive = 'YES'
  $RawUI = (get-host).UI.RawUI
  $RawUI.backgroundcolor = 'DarkCyan'
  ePlant consoleTitleMode 'rt1devpath'
  setConsolewindowTitle
  Clear-Host
} # }}}

function rt1path { # {{{
    vsenv
    rt1p5
    sow importRT0Path "//$sambahost/fs/cme/rt1/RT0_dev"
    sow PATH $(sunder $rt1Path)
    $ENV:rt1ForceActive = 'YES'
    $GLOBAL:rt1ForceActive = 'YES'
    $RawUI = (get-host).UI.RawUI
    $RawUI.backgroundcolor = 'DarkBlue'
    $GLOBAL:consoleTitleMode = 'rt1path'
    SetConsolewindowTitle
    Clear-Host
} # }}}

function xit { # {{{
  Powershell_Exit_Processing
  exit
} # }}}

function Test-ReparsePoint([string]$path) {
  $file = Get-Item $path -Force -ea 0
  return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function tocdiff { # {{{
  $destination  = "tocdiff."
  $destination +=  usrHostTStampPid
  $destination += ".diff"
  $cmd2run  = $nullstr
  $cmd2run += "c:/git/bin/diff -i"
  $cmd2run += " --ignore-matching-lines='(?ix:wsqisqpx.default)'"
  $cmd2run += " --ignore-matching-lines='(?ix:Windows.Prefetch)'"
  $cmd2run += " --ignore-matching-lines='(?ix:Windows.SoftwareDistribution)'"
  $cmd2run += " --ignore-matching-lines='(?ix:Users.ksk.AppData.Roaming)'"
  $cmd2run += " --ignore-matching-lines='(?ix:Windows.Temporary.Internet.Files)'"
  $cmd2run += " --ignore-matching-lines='(?ix::..Recycle.Bin)'"
  $cmd2run += " --ignore-matching-lines='(?ix::.ProgramData.Microsoft.Antimalware)'"
  $cmd2run += " --ignore-matching-lines='(?ix::.ProgramData.Microsoft.Microsoft.Antimalware)'"
  $cmd2run += " --ignore-matching-lines='(?ix:Microsoft.CryptnetUrlCache)'"
  $cmd2run += " --ignore-matching-lines='(?ix:Google.Chrome.User.Data.Default)'"
  $cmd2run += " --ignore-matching-lines='(?ix:Local.Microsoft.Windows.History)'"
  $cmd2run += " --ignore-matching-lines='(?ix:Microsoft.Windows.PowerShell.CommandAnalysis)'"
  $cmd2run += " C:/etc/tox/c.slash.20140415.092525b.srt.txt C:/etc/tox/C.slash.20140414.110445b.srt.txt > $destination"


  write-Host -ForegroundColor DarkYellow $cmd2run
  write-Host -ForegroundColor Green $destination
  Invoke-Expression $cmd2run

} # }}}
###############################################################################################################
#################################################                ##############################################
#################################################  MAIN PROGRAM  ##############################################
#################################################                ##############################################
###############################################################################################################
#
# KEEP NAME OF LOCALHOST IN A HANDY GLOBAL VARIABLE
#
if ( Test-Path -path "env:computername" -PathType leaf ) {
    $GLOBAL:localhost = $env:computername
}
else {
    $GLOBAL:localhost = hostname
}

mststampInit
initBigRegexGBLS

$GLOBAL:initialDirectory = "c:/etc"
if ( -not ( Test-path -path $GLOBAL:initialDirectory -PathType container ) ) {
    New-Item -itemtype directory -path $GLOBAL:initialDirectory
}

if ( "FultonJSheen" -ne $GLOBAL:localhost ) {
    $GLOBAL:sambahost = "FultonJSheen"
}
elseif ( "DeSales" -ne $GLOBAL:localhost ) {
    $GLOBAL:sambahost = "DeSales"
}
elseif ( "Azariah" -ne $GLOBAL:localhost ) {
    $GLOBAL:sambahost = "Azariah"
}

$GLOBAL:homeNet = "H:\NA5JM8WF\pk"
$GLOBAL:netLclDsk = "H:"
$GLOBAL:homeLclDsk = "C:"
$GLOBAL:uid = $env:USERNAME
$GLOBAL:sysInternals = "c:/Sysinternals"
$GLOBAL:ctoc = "C:/etc/tox/" + $(hostname) + ".c.slash.toc.ezn.txt"

sow homeLcl "$homeLclDsk/users/$uid"

ePlant fileServer = "//$sambahost"
guaranteeTmpDirExistence

# These definitions make git console work 
# but break other important things
# Define these at you own risk
#
# $GLOBAL:TERM = "msys"
# $ENV:TERM = $GLOBAL:TERM


$GLOBAL:vvvIsVerbose = $false
$GLOBAL:vimrc_base_name = "vimrc4me.vim"
$GLOBAL:vimrc_base_old = "pk_vimrc.vim"
$GLOBAL:netLcl = bs2s "$netLclDsk/00"

$GLOBAL:cmdHistoryNetD = bs2s "$homeNet/history"
if ( Test-path -path $GLOBAL:homeNet -PathType container ) {
  if ( -not ( Test-path -path $cmdHistoryNetD -PathType container ) ) {
      new-item -type directory -path $cmdHistoryNetD
  }
  if ( -not ( Test-path -path "$cmdHistoryNetD/temp" -PathType container ) ) {
      new-item -type directory -path $cmdHistoryNetD
  }
}

$GLOBAL:cmdHistoryLclD = bs2s "$homeLcl/history"
if ( -not ( Test-path -path $cmdHistoryLclD -PathType container ) ) {
  new-item -type directory -path $cmdHistoryLclD
}
if ( -not ( Test-path -path "$cmdHistoryLclD/temp" -PathType container ) ) {
  new-item -type directory -path "$cmdHistoryLclD/temp"
}

$GLOBAL:psprofilBkNetD = bs2s "$homeNet/keep"
if ( Test-path -path $GLOBAL:homeNet -PathType container ) {
  if ( -not ( Test-path -path $GLOBAL:psprofilBkNetD -PathType container ) ) {
  new-item -type directory -path $GLOBAL:psprofilBkNetD
  }
}

$GLOBAL:psprofilBkLclD = bs2s "$homeLcl/keep"
if ( -not ( Test-path -path $GLOBAL:psprofilBkLclD -PathType container ) ) {
  new-item -type directory -path $GLOBAL:psprofilBkLclD
}


$GLOBAL:vimProfileNetD = bs2s $homeNet
$GLOBAL:vimProfileLclD = bs2s $homeLcl

$GLOBAL:hDriveMountPt = bs2s "//$sambahost/NA5JM8WF/pk"

$GLOBAL:tulavnecot = bs2s "$hDriveMountPt/RCS/tulavnecot.7z"
$GLOBAL:GVtsprefix = usrHostTStampPid

switch -regex ( $localhost ) { # {{{
  '(?six: \A (FultonJSheen) | (Desales) | (Azariah) \z )' {
    if ( -not ( Test-Path -path "$homeLcl/scrolls" -PathType container ) ) {
      New-Item -itemtype directory -path "$homeLcl/scrolls"
    }
    $GLOBAL:transcriptdir = bs2s "$homeLcl/scrolls"
    if ( -not ( Test-Path -path "$cmdHistoryLclD/temp" -PathType container ) ) {
      New-Item -itemtype directory -path "$cmdHistoryLclD/temp"
    }
    $GLOBAL:cmdHistoryTmpD = bs2s "$cmdHistoryLclD/temp"
    if ( -not ( $nullstr -eq $vimProfileLclD ) ) {
        if ( -not ( Test-Path -path $vimProfileLclD -PathType container ) ) {
          New-Item -itemtype directory -path $vimProfileLclD
        }
        $GLOBAL:vimProfileDir = bs2s $vimProfileLclD
    }
    else {
        echo "vimProfileLclD is null"
    }
    if ( -not ( Test-Path -path "$homeLcl/vimbk" -PathType container ) ) {
      New-Item -itemtype directory -path "$homeLcl/vimbk"
    }
    sow vimBackupDir "$homeLcl/vimbk"
    sow vimbk "$vimBackupDirL"
  }
  default {
    $GLOBAL:transcriptdir = bs2s "$homeNet/scrolls"
    $GLOBAL:cmdHistoryTmpD = $env:temp
    $GLOBAL:vimProfileDir = bs2s $homeNet
    sow vimBackupDir "$homeNet/vimbk"
  }
} # }}}
if ( -not ( Test-Path -path $ENV:vimBackupDir -PathType container ) ) {
  New-Item -itemtype directory -path $ENV:vimBackupDir
}
Set-ItemProperty -Path HKCU:\Environment -Name vimBackupDir -Value $( s2bs $ENV:vimBackupDir )

$GLOBAL:cdTrail = "$transcriptdir/$localhost.cdTrail.txt"
$GLOBAL:cdJournal = "$transcriptdir/$localhost.cdJournal.txt"

touch $cdJournal

$GLOBAL:expiredFiles = bs2s "$cmdHistoryTmpD/$( usrHost ).probably.ok2nuke.x.txt"
$s32 = $($env:comspec -replace '.cmd[.]exe$', $nullstr)

sow docset  "C:/Documents and Settings"
sow win     "$env:SystemRoot"
sow sys64   "$winL/SysWOW64"
sow sys32   "$s32"
sow dbx     "$homeLclDsk/drpbx/Dropbox"
sow loh     "$homeLclDsk/drpbx/Dropbox/LOH"
sow pfd     "C:/Program Files (x86)"
sow pfx     "C:/Program Files"
sow win     "C:/Windows"
sow spc     "C:/strwbry/c"
sow sby     "C:/strwbry/perl"
sow mgw     "C:/MinGW"
sow mgw     "C:/mingw64"
sow sqlite  "C:/sqlite"
sow bin     "C:/bin"
sow din     "C:/users/ksk/bin"
sow pyd     "C:/Py35"
sow j7d     "C:/jdk7/w64/bin"
sow ekd     "C:/eklypz/w64"
sow dyd     "C:/Android/android-sdk"
sow abw     "C:/adt-bundle-windows-x86_64-20130219"
sow git     "C:/git/bin"
sow git     "C:/git/usr/bin"
sow xbn     "C:/system/xbin"
sow adb     'C:/adb'
sow PYTHONHOME 'C:/Py35'
$ENV:dbx = $dbxL


switch -regex ( $localhost ) { # {{{
  '(?six: \A (FultonJSheen) | (Desales) | (Azariah)  \z )' {
    #sow vimLcl ( ,"$homeLclDsk/nomad" )
    sow VIM "$homeLclDsk/bin/vim"
    sow VIMRUNTIME "$VIM/vim74"
  }

  default {
    #sow VIMLCL ( ,"$homeLcl" )
    sow VIM "$pfd/Vim"
    sow VIMRUNTIME "$VIM/vim74"
  }
} # }}}


$GLOBAL:vimprofile = bs2s "$vimProfileDir/$vimrc_base_name"
$GLOBAL:vimprofold = bs2s "$vimProfileDir/$vimrc_base_old"
$GLOBAL:gooeyvimexe = bs2s "$VIM/vim74/gvim.exe"
$GLOBAL:gooeyvim = bs2s "$gooeyvimexe -u $vimprofile"
$GLOBAL:crunchyvimexe = bs2s "$VIM/vim74/vim.exe"
$GLOBAL:crunchyvim = bs2s "$crunchyvimexe -u $vimprofile"
$GLOBAL:eclipseimage = shortnamequiet "$pfdL/Eclipse3.6.1/Eclipse.exe"
$GLOBAL:eclipsevmexe = shortnamequiet "$pfxL/java/jdkl.6.0_18/jre/bin/javaw.exe"
$GLOBAL:eclipsevm = $eclipsevmexe -replace '[.]exe$', $nullstr
$GLOBAL:eclipseDir = shortnamequiet "$pfdL/Eclipse3.6.1"
$GLOBAL:bzipexe = shortnamequiet "$git/bzip2.exe"

ePlant git_editor $gooeyvimexe

sow JAVA_HOME ( "$bin/jdk1.8.0.40/jre", "$env:systemdrive/jdk7/w64/jre7" )
sow JRE_H0ME  "$JAVA_HOME"
sow JRE8_64   "$bin/jdk1.8.0.40/jre"
sow JRE7_64   "$env:systemdrive/jdk7/w64/jre7"
sow JRE7_32   "$env:systemdrive/jdk7/w32/jre7"
sow ECLIPSE_HOME "$ekd"
sow SMARTGIT_JAVA_HOME "$JAVA_HOME"

initiateTranscript $transcriptdir

if ( $localhost -match "(?six: (FultonJSheen) | (deSales) | (Azariah)  \z )" ) {
  retrieveCmdHistory $cmdHistoryLclD
}
else {
  retrieveCmdHistory $cmdHistoryNetD
}

ssinit

Register-EngineEvent PowerShell.Exiting {
# Powershell_Exit_Processing
} -SupportEvent



pkpath
pypath
ePlant PYTHONDEBUG 1
ePlant PYTHONIOENCODING 'utf-8'
ePlant pathext "$env:pathext;.PL;.PY"
$dstack = @{}
setdir $env:userprofile
#cd $GLOBAL:initialDirectory
