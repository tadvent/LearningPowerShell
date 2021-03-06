<#
$map = ,(,0) * 21
foreach($i in 0..20){$map[$i] = (,[long]0 * 21)}
foreach($i in 0..20){$map[$i][0] = $map[0][$i] = 1}

function route($x, $y){
    if($x -lt 0 -or $x -gt 20 -or $y -lt 0 -or $y -gt 20){0; return}
    if($map[$x][$y]){$map[$x][$y]; return}
    $map[$x][$y] = (route $x ($y - 1)) + (route ($x - 1) $y)
    $map[$x][$y]
}

route 20 20
#>

################################################################
# use two-dimention array

$map = new-object 'long[,]' 21,21
foreach($i in 0..20){$map[$i,0] = $map[0,$i] = 1}

function route($x, $y){
    if($x -lt 0 -or $x -gt 20 -or $y -lt 0 -or $y -gt 20){0; return}
    if($map[$x,$y]){$map[$x,$y]; return}
    $map[$x,$y] = (route $x ($y - 1)) + (route ($x - 1) $y)
    $map[$x,$y]
}

route 20 20