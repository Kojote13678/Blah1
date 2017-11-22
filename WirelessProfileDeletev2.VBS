MyPS1 = Left(wscript.scriptfullname, (len(wscript.scriptfullname)-4)) & ".PS1"
MyScriptPath = Left(wscript.scriptfullname, InStrRev(wscript.scriptfullname, "\"))

CreateObject("Shell.Application").ShellExecute "PowerShell" _
                , "-executionpolicy Bypass " _
                        & "-file " & chr(34) & MyPS1 & chr(34) _
                , MyScriptPath _
                , "runas" _
                , 1
