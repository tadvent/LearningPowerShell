@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split '\s+';$f|Out-String|iex"
EXIT /B
############################################################

# this is comment
# param($name = "bub")
param($name)
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

read-host "yes or no? `nanother line`nyet another line"

############################################################
cmd /c "pause"

