@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split 's+';$f|Out-String|iex"
EXIT /B
###########################################################
"IP ��ַ���ĳ���"
""
"�ɽ��еĲ�����"
"[1] �� ������������ ����Ϊ DHCP �Զ���ȡ"
"[2] �� ������������ ����Ϊ��̬ IP: 192.168.0.158"

for(;;){
    $select = read-host "������ѡ�����"
    if($select -eq "1" -or $select -eq "2") {break}
    "������� :( ������һ�Ρ�����"
}
switch ($select){
    "1" {
        netsh interface ipv4 set address `
            name="������������" `
            source=dhcp
        netsh interface ipv4 set dnsserver `
            name="������������" `
            source=dhcp
        break
    }
    "2" {
        netsh interface ipv4 set address `
            name="������������" `
            source=static `
            address=192.168.0.158 `
            mask=255.255.255.0 `
            gateway=192.168.0.111
        netsh interface ipv4 add dnsserver `
            name="������������" `
            address=8.8.4.4 `
            validate=no
        netsh interface ipv4 add dnsserver `
            name="������������" `
            address=210.43.0.18 `
            validate=no
        netsh interface ipv4 add dnsserver `
            name="������������" `
            address=210.43.0.8 `
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
#cmd /c "pause"

