<#
function arrfilter($list){
    $d = $list[0]
    foreach($i in $list){
        if($i % $d -ne 0){$i}
    }
}

function primes($upper = 10){
    $list = 2..($upper-1)
    $lim = [int][math]::ceiling([math]::sqrt($upper))
    while($list[0] -le $lim){
        $list[0]
        $list = @(arrfilter $list)
    }
    foreach($p in $list){$p}
}

function solve{
    primes 2000000|%{[long]$s=0}{$s+=$_}{write-host $s}
}

write-host "Time(s): " (measure-command {solve}).totalseconds    # 183 secs
#>

###########################################################
# another solution
$max = 2000000

function solve{
    $l = ,1 * $max
    $cur_p = 2
    $total = 0

    while($cur_p -lt $max){
        $total += $cur_p
        for($i = $cur_p; $i -lt $max; $i += $cur_p){$l[$i] = 0}
        while($cur_p -lt $max -and $l[$cur_p] -eq 0){++$cur_p}
    }
    write-host $total
}

write-host "Time(s): " (measure-command {solve}).totalseconds    # 57.5 secs