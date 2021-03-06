
$db = @()
$lim = 0

function init{
    param([long] $l)
    $global:db = ,0 * $l
    $db[1] = 1
    $global:lim = $l
}

function collatz{
    param([long] $n)

    if(!$db[$n]){
        [long]$cn = $n
        [long]$cnt = 0
        do{
            ++$cnt
            if(($cn -band 1) -eq 0){
                $cn /= 2
            } else {
                $cn = $cn * 3 + 1
            }
        }until($cn -lt $lim)
        $db[$n] = (collatz $cn) + $cnt
    }
    $db[$n]
}

function solve{
    param([long] $n)
    init $n
    $maxi = $maxlen = 0
    foreach($i in 1..($n-1)){
        $len = collatz $i
        if($len -gt $maxlen){
            $maxi = $i
            $maxlen = $len
        }
    }
    write-host $maxi $maxlen
}

write-host "Time:" (measure-command {solve 1000000}).totalseconds "secs"    # 430 secs