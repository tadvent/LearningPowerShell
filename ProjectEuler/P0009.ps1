:out foreach($a in 1..333){
    foreach($b in ($a+1)..500){
        $c = 1000 - $a - $b
        if($b -gt $c){break}
        if($a*$a + $b*$b -eq $c*$c){
            "$a $b $c"
            $a*$b*$c
            break out
        }
    }
}
