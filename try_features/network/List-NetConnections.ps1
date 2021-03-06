#<#
# 方法一
$objNetwork = New-Object System.Management.ManagementClass "Win32_NetworkAdapter"
$adapters = $objNetwork.GetInstances()|?{$_.NetConnectionID}
$connections = $adapters|?{$_.NetEnabled}
$connections|ft NetConnectionID, MACAddress -auto
<##>


<# 方法二 Another solution
$NetAdapterConfig = New-Object System.Management.ManagementClass "Win32_NetworkAdapterConfiguration"
$adapterCs = $NetAdapterConfig.getinstances()
$adapterCs|?{$_.IPEnabled}|ft macaddress, ipaddress -auto
<##>

# 第一和第二种方法，可以将 NetConnectionID, MACAddress, IPAddress 结合在一起

##########################################################
# 方法三
# or use "netsh interface show interface" command, process strings
