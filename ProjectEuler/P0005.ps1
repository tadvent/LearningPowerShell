function gcd([int]$a, [int]$b){
    if($a -lt $b){$a,$b = $b,$a}
    while($b -ne 0){
        $a, $b = $b, ($a%$b)
    }
    $a
}

function lcm([int]$a, [int]$b){
    [int]($a * $b / (gcd $a $b))
}

$r = 1
foreach($i in 1..20){$r = lcm $r $i}
$r