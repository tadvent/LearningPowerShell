function fibarray([int]$lim){
    [int]$a = 1
    [int]$b = 1
    while($b -le $lim){
        $b
        $a, $b = $b, ($a+$b)
    }
}

(fibarray 4000000|where{($_ -band 1) -eq 0}|measure -sum).sum
#fibarray 4000000|where{($_ -band 1) -eq 0}|foreach{$s=0}{$s+=$_}{$s}    # also ok