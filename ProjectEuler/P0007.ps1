$primes = 2,3,5,7
$t = 11
while($primes.count -lt 10001){
    $lim = [int][math]::floor([math]::sqrt($t)+0.1)
    foreach($i in $primes){
        if($i -gt $lim){
            $primes += $t
            break
        }
        if($t % $i -eq 0){break}
    }
    $t += 2
}

$primes[-1]
