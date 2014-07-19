@echo off
:: Batch file to run a powershell command
:: Script skips the first 6 lines as they are DOS batch code. After that you have pure Powershell.
:: Read the lines it into an array, join on a CRLF and execute that string as a single Ps command!
powershell.exe -command "$crlf="""`n"""; $c = (gc %~0  |select-object -skip 6);  $c -join $crlf |invoke-expression"
exit /b 0 
############################################################

# this is comment
param($name = "bub")
"Hello $name, how are you?"

function Release-TheKracken
{
    Write-Host "The kracken is now wreaking havoc on your enemies..."
}

function hello {
param($name = "bub")
"Hello $name, how are you"
}

hello "abc"

Release-TheKracken

############################################################
cmd /c "pause"

