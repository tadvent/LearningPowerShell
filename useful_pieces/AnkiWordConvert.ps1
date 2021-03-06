
$pattern = [regex]'(?sx)    # 单行，注释模式
    (?:\s+)?                # 开头可能有多余白空格
    (?<word>[^\n]+?)        # 匹配非换行符，非贪婪
    (?=(?: \n | \|\| | $))  # 前向匹配 回车 或 双竖线 或 结束符
    (?:\n | $ |             # 回车或结束符结束该词条，或者
        (?:\|\|\w+\s+       # 双竖线开启词条解释部分
            (?<exp>.+?)     # 解释部分，非贪婪
            (?=\|\|\n)      # 前向匹配双竖线回车结束解释
            \|\|\n          # 匹配双竖线回车
        )
    )'

$filename = read-host "输入文件名："
#$filename = 'DataBase.txt'
$fc = Get-Content $filename

for(;;){
    $fc|select -First 10
    $enc = Read-Host "输入编码："
    if($enc -eq ''){break}
    $fc = Get-Content -Encoding $enc $filename
}

$fc = $fc -join "`n"

$ms = $pattern.Matches($fc)

$ms|select @{Name="word";E={$_.groups["word"].value}},@{Name="exp";E={$_.groups["exp"].value}} -first 5|fl

$tag = ''
if($filename -match '(.+)\.\w+?'){
    $tag = $matches[1]
} else {
    $tag = $filename
}
$fnwithoutext = $tag

"Tag: $tag"
$newtag = Read-Host "new tag? "
if($newtag -ne ''){
    $tag = $newtag
}

function HTMLconv($s){
    $s = $s.Replace('&', '&amp;')
    $s = $s.Replace('<', '&lt;')
    $s = $s.Replace('>', '&gt;')
    $s = $s.Replace(' ', '&nbsp;')
    $s = $s.Replace("`n", '<br>')
    return $s
}

$out = foreach($m in $ms){
    $word = $m.groups["word"].value
    $exp = $m.groups["exp"].value
    if($word -eq '||Text||' -or
            $word -eq '||解释||' -or
            $word -match '^\s+$' -or
            $exp -match '^\s+$'){
        continue
    }
    $word = HTMLconv $word
    $exp = HTMLconv $exp
    "$word`t$exp`t$tag"
}

$out|Out-File "$($fnwithoutext)_conv.txt" -Encoding "utf8"
