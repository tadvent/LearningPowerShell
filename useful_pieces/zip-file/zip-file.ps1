﻿# 将 $src 所指文件(夹) 压缩为 $zip 文件

function new-zip($zipfile){
    if($zipfile -notlike "*.zip"){
        $zipfile += ".zip"
    }
    "PK"+[char]5+[char]6+"$([char]0)"*18| out-file $zipfile -Encoding ASCII
}

function zip-files($src, $zip){
    new-zip $zip

    $s = New-Object -ComObject shell.application
    $zipfolder = $s.NameSpace($zip)
    $filenum = $zipfolder.Items().Count
    
    foreach($f in $src){
        "Compressing " + $f + " ..."
        $zipfolder.CopyHere($f)
        while($zipfolder.Items().Count -eq $filenum){
            Start-Sleep -Milliseconds 5
        }
        $filenum = $zipfolder.Items().Count
    }
    
    "Done"

    [System.Runtime.interopservices.marshal]::ReleaseComObject($s)
}


# $src = dir 'D:\docs\VBScript\tests'|%{$_.fullname}
# $zip = (resolve-path '..\new.zip').path
$src = dir '.'|%{$_.fullname}
$zip = join-path "$(pwd)" "new.zip"
zip-files $src $zip
