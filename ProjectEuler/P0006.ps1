$S = (1..100|measure -sum).sum
$ss = (1..100|foreach{$_*$_}|measure -sum).sum
$s * $s - $ss