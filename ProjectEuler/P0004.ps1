function max-pal(){
    $r = 0
    foreach($i in 999..100){
        foreach($j in 999..100){
            if($i * $j -le $r){break}
            $s = [string]($i * $j)
            $rs = $s[-1..-$s.length] -join ''
            if($s -eq $rs){$r = $i * $j}
        }
    }
    $r
}

max-pal