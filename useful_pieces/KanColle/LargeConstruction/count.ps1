cd D:\docs\PowerShell\useful\KanColle\LargeConstruction

$data = @{}

$p = [regex]'(\d+)\s*/(\d+)\s*/(\d+)\s*/(\d+)\s*開発資材\s*[：:]\s*(\d+)\s*.*秘書[：:]\s*(\w+)\s*結果[：:](\w+)\s*'

# $s1 = '4000/6000/6000/2000　開発資材：20　空きドック：1　司令：96　秘書：加賀改　結果：矢矧 -- 2014-02-12 (水) 09:48:30'
# $s2 = '4000/6000/6000/2000　開発資材：20　空きドック：1　司令：96　秘書：加賀　結果：矢矧 -- 2014-02-12 (水) 09:48:30'

function Get-Recipe($m){
    $r = "$($m[1,2,3,4,5])"
    if($m[6] -like "*Z1*" -or $m[6] -like "*Z3*"){
        $r += " (Z1/Z3)"
    }
    return $r
}

function Get-Result($s){
    if($s -like "*b*s*m*" -or $s -like "*ビ*"){
        return "Bismarck"
    }
    if($s -like "*あき*" -or $s -like "*aki*" -or $s -like "アキ*"){
        return "あきつ丸"
    }
    if($s -like "まる*" -or $s -like "*ゆ*" -or $s -like "*maru*"){
        return "まるゆ"
    }
    $s = $s -replace '竜', '龍'
    $s = $s -replace '準', '隼'
    return $s
}


function addline($line){
    $m = $p.match($line).groups|%{$_.value}
    if($m){
        $recipe = Get-Recipe $m
        $result = Get-Result $m[7]
        if($data.keys -contains $recipe){
            $data[$recipe][0] += 1
            $rstdict = $data[$recipe][1]
            if($rstdict.keys -contains $result){
                $rstdict[$result] += "$($m[6])"
            } else {
                $rstdict[$result] = @("$($m[6])")
            }
        } else {
            $data[$recipe] = @(1, @{"$result" = @("$($m[6])")})
        }
    }
}

# addline $s1
# addline $s2

function readfile($fn){
    $content = Get-Content $fn
    foreach($l in $content){
        addline $l
    }
}

function readlogs($from, $to){
    for($i = $from; $i -le $to; ++$i){
        readfile "D:\docs\PowerShell\useful\KanColle\LargeConstruction\$i.txt"
    }
    
    $todeletekeys = $data.GetEnumerator()|?{$_.value[0] -le 3}|%{$_.key}
    foreach($k in $todeletekeys){
        $data.Remove($k)
    }
    #$data | Export-Clixml "data.xml"
}

function out-recipe($rec = ""){
    function recipe-results($num, $rstht){
        $sortedrsts = $rstht.GetEnumerator()|Sort-Object {$_.value.length} -Descending
        foreach($rst in $sortedrsts){
            if($num -gt 1000 -and $rst.value.length -le 3){break}
            "    {0,-8}{1,6}    {2,9:P2}" -f ($rst.key + ":"), $rst.value.length, ($rst.value.length / $num)
            #"        $($rst.value)"
        }
    }
    
    if($rec -ne ""){
        if($data.keys -contains $rec){
            $num = $data[$rec][0]
            "{0}: {1}" -f $rec, $num
            recipe-results -num $num -rstht $data[$rec][1]
        } else {
            "{0}: 0" -f $rec
        }
    } else {
        $sorted = $data.GetEnumerator()|Sort-Object {$_.value[0]} -Descending
        foreach($p in $sorted){
            $num = $p.value[0]
            # if($num -lt 5){continue}
            "{0}: {1}" -f $p.key, $num
            recipe-results -num $num -rstht $p.value[1]
        }
    }
}


readlogs 40 93
#$data = Import-Clixml "data.xml"

out-recipe "4000 6000 6000 2000 20"
out-recipe "4000 6000 6000 3000 20"
#out-recipe "4000 6000 6000 2000 20 (Z1/Z3)"
#out-recipe "4000 6000 6000 3000 20 (Z1/Z3)"
out-recipe "4000 6000 6000 2000 1 (Z1/Z3)"
out-recipe "4000 6000 6000 3000 1 (Z1/Z3)"
#out-recipe "3500 3500 6000 6000 20"
#out-recipe "4000 2000 5000 5200 20"
#out-recipe "4000 2000 5000 6000 20"
#out-recipe "4000 2000 5000 7000 20"
#out-recipe "3500 3500 6000 6000 1"
#out-recipe "4000 2000 5000 5200 1"
#out-recipe "4000 2000 5000 7000 1"
out-recipe "4000 5000 6000 2500 20 (Z1/Z3)"
out-recipe "4000 6000 7000 2000 1 (Z1/Z3)"
