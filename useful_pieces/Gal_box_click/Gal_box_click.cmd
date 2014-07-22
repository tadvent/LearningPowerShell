@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split '\s+';$f|Out-String|iex"
EXIT /B
############################################################

$url = 'http://bbs.9gal.com/kf_smbox.php'
$visible = $true
$boxnumwall = 90

$next_time = [int](read-host "? minutes before next click ?")
$next_time *= 60
"Wait $next_time secs..."
Start-Sleep $next_time

function click-box(){
    $wc = New-Object -ComObject InternetExplorer.Application
    "Object Created!"
    if($visible){
        $wc.Visible = 1
    }


    for(;;){
        try {
            "Trying open box page..."
            $wc.Navigate($url)
            Start-Sleep 10
            "Search for AD link:"
            $ads = @($wc.Document.links|?{$_.href -like '*diy_ad_move.php*'}|%{$_.href})
            if($ads.count -eq 0){
                Write-Host "Error Occured... Retry 10 secs later..." -ForegroundColor Red
                Start-Sleep 10
                continue
            }
            "AD links got!:"
            $ads
            "Trying Click it/them..."

            foreach($adlink in $ads){
                "Click {0}" -f $adlink
                $wc.Navigate($adlink)
                Start-Sleep 10
            }
            "ADs Clicked!"
            break
        }
        catch {
            Write-Host "Error Occured... Retry 10 secs later..." -ForegroundColor Red
            Start-Sleep 10
            continue
        }
    }

    for(;;){
        try {
            $wc.Navigate($url)
            "Box page Refreshed!"
            Start-Sleep 10
            $boxes = $wc.Document.links|?{$_.href -like "*box=*"}
            "Number of boxes: {0}" -f $boxes.Length
            if($boxes.Length -le 0){
                "Box number Error - -, Retry..."
                Start-Sleep 10
                continue
            } elseif($boxes.Length -gt $boxnumwall) {
                "Too many boxes, retry..."
                Start-Sleep 10
                continue
            }
            (Get-Random -InputObject $boxes).Click()
            "Box Clicked!"
            break
        }
        catch {
            Write-Host "Error Occured... Retry 10 secs later..." -ForegroundColor Red
            Start-Sleep 10
            continue
        }
    }


    if(-not $visible){
        $wc.Quit()
    }
}


$click_time = 50
while($click_time -gt 0){
    ""
    Get-Date
    click-box
    
    $click_time -= 1
    if($click_time -eq 0){ break }
    
    "Begin to Sleep 5 hours..."
    Start-Sleep (3600 * 5)
    "Wake up!"
}




############################################################

