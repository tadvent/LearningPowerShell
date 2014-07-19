@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split 's+';$f|Out-String|iex"
EXIT /B
###########################################################
"IP 地址更改程序"
""
"可进行的操作："
"[1] 将 无线网络连接 设置为 DHCP 自动获取"
"[2] 将 无线网络连接 设置为静态 IP: 192.168.0.158"

for(;;){
    $select = read-host "请输入选项序号"
    if($select -eq "1" -or $select -eq "2") {break}
    "输入错误 :( 请再试一次。。。"
}
switch ($select){
    "1" {
        netsh interface ipv4 set address `
            name="无线网络连接" `
            source=dhcp
        netsh interface ipv4 set dnsserver `
            name="无线网络连接" `
            source=dhcp
        break
    }
    "2" {
        netsh interface ipv4 set address `
            name="无线网络连接" `
            source=static `
            address=192.168.0.158 `
            mask=255.255.255.0 `
            gateway=192.168.0.111
        netsh interface ipv4 add dnsserver `
            name="无线网络连接" `
            address=8.8.4.4 `
            validate=no
        netsh interface ipv4 add dnsserver `
            name="无线网络连接" `
            address=210.43.0.18 `
            validate=no
        netsh interface ipv4 add dnsserver `
            name="无线网络连接" `
            address=210.43.0.8 `
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
#cmd /c "pause"

