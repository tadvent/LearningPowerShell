@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split '\s+';$f|Out-String|iex"
EXIT /B
############################################################
$7z = (Get-Command -Name "7z.exe").definition
dir -r|?{-not $_.PSIsContainer -and $_.name -like "*.zip"} `
    |%{& $7z d $_.fullname 81256_new.jpg -r}

############################################################
cmd /c "pause"

