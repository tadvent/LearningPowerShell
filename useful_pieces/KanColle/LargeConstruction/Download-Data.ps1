$url = 'http://wikiwiki.jp/kancolle/?cmd=read&page=%A5%B3%A5%E1%A5%F3%A5%C8%2F%C2%E7%B7%BF%B4%CF%B7%FA%C2%A4%2F%A5%EC%A5%B7%A5%D4%A5%ED%A5%B0'
$wc = New-Object -ComObject "InternetExplorer.Application"
"IE start!"

function downloadpage($num){
    "Open page {0}..." -f $num
    $wc.Navigate($url + "$num")
    "Wait for page loading..."
    Start-Sleep 30
    "Save file {0}.txt" -f $num
    $wc.Document.documentElement.outerText|Out-File ("$num" + ".txt")
}


function down-pages($from, $to){
    downloadpage $from
    for($n = $from + 1; $n -le $to; ++$n){
        Start-Sleep 30
        downloadpage $n
    }
}

down-pages 90 91


$wc.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($wc)
"IE Quit!"
