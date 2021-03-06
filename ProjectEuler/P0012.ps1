function fact-num{
    param([long] $n)
    $d = 2
    $prime_num = @(while($n -gt 1){
        if($n % $d -eq 0){
            $cnt = 1
            do{
                $n /= $d
                ++$cnt
            }while($n % $d -eq 0)
            $cnt
        }
        ++$d
    })
    iex (($prime_num + 1) -join "*")
}

fact-num 4

function solve{
    $s = 0
    $n = 1
    for(;; ++$n){
        $s += $n
        if((fact-num $s) -gt 500){
            write-host $s
            break
        }
    }
}

write-host "Time(s): " (measure-command {solve}).totalseconds    # 202 secs
