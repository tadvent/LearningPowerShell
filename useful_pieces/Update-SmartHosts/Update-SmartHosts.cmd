@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split '\s+';$f|Out-String|iex"
EXIT /B
############################################################

$dochange = $false

$ds = $null
$hosts_file_path = 'C:\Windows\System32\drivers\etc\hosts'
$smart_hosts_url = 'http://smarthosts.googlecode.com/svn/trunk/hosts'

$olddate = [datetime]'2000/1/1'
$newdate = $null
$newstr  = $null


$fc = [io.file]::ReadAllText($hosts_file_path)

if($ds -eq $null -or $ds.gettype().name -ne 'string' -or $ds.length -le 100){
    $wc = New-Object Net.WebClient
    $ds = $wc.DownloadString('http://smarthosts.googlecode.com/svn/trunk/hosts')
}

$pattern = '#UPDATE:(?<date>.+)(?ms).*#SmartHosts START.*#SmartHosts END'

if($ds -match $pattern){
    $newdate = [datetime]$matches.date
    $newstr  = $matches[0]
}

if($fc -match $pattern){
    $olddate = [datetime]$matches.date
    if($newdate -gt $olddate){
        $fc = $fc -replace $pattern, $newstr
    }
} else {
    $fc += "`r`n############################################`r`n" + $ds
}

$fc = $fc -replace '(\n|\r\n)', "`r`n"

if($dochange){
    Rename-Item $hosts_file_path "$hosts_file_path.old"
    $fc|Out-File "$hosts_file_path" -Encoding ASCII
    notepad.exe $hosts_file_path
} else {
    $fc
    "`nThe hosts file has not been changed..."
    "当前未使用 SmartHosts，因此不修改 hosts 文件"
    "要使用 SmartHosts，将 `$dochange 设为 `$true."
}

############################################################
cmd /c "pause"

