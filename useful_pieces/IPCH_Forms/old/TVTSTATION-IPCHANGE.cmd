@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split 's+';$f|Out-String|iex"
EXIT /B
###########################################################
"IP 地址更改程序"
""
"可进行的操作："
"[1] 将 Local Area Connection 设置为 DHCP 自动获取"
"[2] 将 Local Area Connection 设置为静态 IP: 10.0.0.3"

for(;;){
    $select = read-host "请输入选项序号"
    if($select -eq "1" -or $select -eq "2") {break}
    "输入错误 :( 请再试一次。。。"
}
switch ($select){
    "1" {
        netsh interface ipv4 set address `
            name="Local Area Connection" `
            source=dhcp
        netsh interface ipv4 set dnsserver `
            name="Local Area Connection" `
            source=dhcp
        break
    }
    "2" {
        netsh interface ipv4 set address `
            name="Local Area Connection" `
            source=static `
            address=10.0.0.3 `
            mask=255.255.255.0 `
            gateway=10.0.0.1
        netsh interface ipv4 add dnsserver `
            name="Local Area Connection" `
            address=10.0.0.1 `
            validate=no
        netsh interface ipv4 add dnsserver `
            name="Local Area Connection" `
            address=8.8.4.4 `
            validate=no
        break
    }
    default {
        "选项错误！！！"
        exit 1
    }
}

"操作完成 :~)"
###########################################################
cmd /c "pause"

