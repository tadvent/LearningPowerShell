@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split 's+';$f|Out-String|iex"
EXIT /B
###########################################################
"IP ��ַ���ĳ���"
""
"�ɽ��еĲ�����"
"[1] �� Local Area Connection ����Ϊ DHCP �Զ���ȡ"
"[2] �� Local Area Connection ����Ϊ��̬ IP: 10.0.0.3"

for(;;){
    $select = read-host "������ѡ�����"
    if($select -eq "1" -or $select -eq "2") {break}
    "������� :( ������һ�Ρ�����"
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
        "ѡ����󣡣���"
        exit 1
    }
}

"������� :~)"
###########################################################
cmd /c "pause"

