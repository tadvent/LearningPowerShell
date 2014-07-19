function max-fact([long]$n){
    [long]$fact = 2
    while($fact -lt $n){
        if(($n % $fact) -eq 0){
            $n = [long][math]::floor($n/$fact)
        } else {
            ++$fact
        }
    }
    $fact
}

max-fact 600851475143