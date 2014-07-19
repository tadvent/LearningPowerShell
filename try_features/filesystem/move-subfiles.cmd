@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split '\s+';$f|Out-String|iex"
EXIT /B
############################################################

mkdir nf; dir -r|?{($_.name -ne 'move-subfiles.cmd') -and (test-path $_.fullname -pathtype leaf)}|%{move $_.fullname -des .\nf}
############################################################

