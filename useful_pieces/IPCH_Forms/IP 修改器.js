cmd = "powershell.exe -Command \"$f=(cat \'_\');$f|select -skip 4|Out-String|iex\"";
var obj = WScript.CreateObject("WScript.Shell");
obj.run("cmd /c start /b " + cmd.replace(/_/g, WScript.ScriptFullName),0);
/*
#######################################################
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$btnRefresh_OnClick = {
    $objNetwork = New-Object System.Management.ManagementClass "Win32_NetworkAdapter"
    $adapters = $objNetwork.GetInstances()|?{$_.NetConnectionID}
    $cmbConnectionID.Items.Clear()
    $adapters|?{$_.NetEnabled}|%{$cmbConnectionID.Items.Add($_.NetConnectionID)}
    
    if($cmbConnectionID.Items.Count -gt 0){
        $cmbConnectionID.SelectedIndex = 0
    }
}

function EnableControls(){
    $pink = [System.Drawing.Color]::Pink
    
    # TODO: 检查 IPAddress, NetMask, Gateway 是否冲突
    
    # 检查 IPAddress 和 DNS1 的 DHCP 设置是否冲突
    if($tbxDNS1.Text -eq "DHCP"){
        if($tbxIPAddress.Text -ne "DHCP"){
            $tbxDNS1.BackColor = $pink
        } else {
            $tbxDNS1.BackColor = [System.Drawing.SystemColors]::Window
        }
    }

    # 根据 IPAddress 设置 NetMask 和 Gateway 是否 Enabled
    if($tbxIPAddress.Text.Length -eq 0 -or $tbxIPAddress.Text -eq "DHCP" -or
        $tbxIPAddress.BackColor -eq $pink){
        $tbxNetMask.Enabled = $false
        $tbxGateway.Enabled = $false
    } else {
        $tbxNetMask.Enabled = $true
        $tbxGateway.Enabled = $true
    }
    # 根据 DNS1 设置 DNS2 是否 Enabled
    if($tbxDNS1.Text.Length -eq 0 -or $tbxDNS1.Text -eq "DHCP" -or
        $tbxDNS1.BackColor -eq $pink){
        $tbxDNS2.Enabled = $false
    } else {
        $tbxDNS2.Enabled = $true
    }
    
    # 根据 CfgName, IPAddress, NetMask, Gateway, DNS1 和 DNS2 设置应用和保存按钮是否 Enabled
    if(($tbxIPAddress.Text.Length -gt 0 -or $tbxDNS1.Text.Length -gt 0) -and
        $cmbIPCfgName.BackColor -ne $pink -and
        $tbxIPAddress.BackColor -ne $pink -and
        $tbxNetMask.BackColor -ne $pink -and
        $tbxGateway.BackColor -ne $pink -and
        $tbxDNS1.BackColor -ne $pink -and
        $tbxDNS2.BackColor -ne $pink){
        $btnApply.Enabled = $true
        if($cmbIPCfgName.SelectedIndex -ne 0){
            $btnSave.Enabled = $true
        } else {
            $btnSave.Enabled = $false
        }
    } else {
        $btnApply.Enabled = $false
        $btnSave.Enabled = $false
    }
    
    # 根据 CfgName 设置 IPAddress 和 DNS1 是否 ReadOnly 以及删除按钮 Enabled
    if($cmbIPCfgName.SelectedIndex -ne 0){
        $tbxIPAddress.ReadOnly = $false
        $tbxDNS1.ReadOnly = $false
        $btnDelete.Enabled = $true
    } else {
        $tbxIPAddress.ReadOnly = $true
        $tbxDNS1.ReadOnly = $true
        $btnDelete.Enabled = $false
    }
}

$AddressValidating = {
    function CheckAddress($address){
        $pattern = '^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$'
        if($address -match $pattern){
            foreach($i in $matches[1..($matches.count-1)]){
                if(([int]$i) -gt 255){return $false}
            }
            return $true
        }
        return $false
    }
    
    if($this.Text.Length -eq 0 -or (CheckAddress $this.Text)){
        $this.BackColor = [System.Drawing.SystemColors]::Window
    } else {
        $this.BackColor = [System.Drawing.Color]::Pink
        #$_.Cancel = $true
    }
    EnableControls
}
$DHCPAddressValidating = {
    if($this.Text -eq "DHCP"){
        $this.BackColor = [System.Drawing.SystemColors]::Window
        EnableControls
    } else {
        & $AddressValidating
    }
}

########################################################################
$SavedFileName = ".\save.xml"
$SavedData = ,@{"Name" = "自动获取"; "tbxIPAddress" = "DHCP"; "tbxDNS1" = "DHCP"}

$LastSelectedIndex = 0
$cmbIPCfgName_OnKeyUp = {
    $pink = [System.Drawing.Color]::Pink
    $window = [System.Drawing.SystemColors]::Window
    if($this.Text -match '^\s*$'){    # 空白名称
        $this.BackColor = $pink
    } else {
        $idx = $this.Items.IndexOf($this.Text)
        if($idx -lt 0){
            $this.BackColor = $window
        } elseif($LastSelectedIndex -eq ($this.Items.Count - 1)){
            $this.BackColor = $pink
        } elseif($idx -ne $LastSelectedIndex){
            $this.BackColor = $pink
        } else {
            $this.BackColor = $window
        }
    }
    
    EnableControls
}

$cmbIPCfgName_OnChanged = {
    $edits = $tbxIPAddress, $tbxNetMask, $tbxGateway, $tbxDNS1, $tbxDNS2
    if($this.SelectedIndex -eq ($this.Items.count - 1)){    # 新建
        $this.BackColor = [System.Drawing.Color]::Pink
        $edits|%{$_.Text = ""}
    } else {
        $this.BackColor = [System.Drawing.SystemColors]::Window
        $edits|%{$_.Text = $SavedData[$this.SelectedIndex].($_.Name)}
    }
    $LastSelectedIndex = $this.SelectedIndex
    EnableControls
}

$btnSave_OnClick = {
    $edits = $tbxIPAddress, $tbxNetMask, $tbxGateway, $tbxDNS1, $tbxDNS2
    function SaveDataToIndex(){
        foreach($e in $edits){
            if($e.Enabled -eq $false -or $e.Text.Length -eq 0){continue}
            $SavedData[$LastSelectedIndex].($e.Name) = $e.Text
        }
    }

    if($LastSelectedIndex -eq ($cmbIPCfgName.Items.count - 1)){ # 新建
        $SavedData += @{"Name" = $cmbIPCfgName.Text}
        SaveDataToIndex
        
        $cmbIPCfgName.Items[$LastSelectedIndex] = $cmbIPCfgName.Text
        $cmbIPCfgName.Items.Add("<新建方案>...")
        #$cmbIPCfgName.SelectedIndex = $LastSelectedIndex

    } elseif($LastSelectedIndex -gt 0) { # 修改
        $SavedData[$LastSelectedIndex].Name = $cmbIPCfgName.Text
        SaveDataToIndex
        $cmbIPCfgName.Items[$LastSelectedIndex] = $cmbIPCfgName.Text
    } else { # DHCP，不保存
        # Only Can Apply BUtton lead here
        # nothing
    }

    $SavedData|Export-Clixml $SavedFileName
}

########################################################################
$btnApply_OnClick = {
    & $btnSave_OnClick
    
    $setname = " name=`"$($cmbConnectionID.Text)`""
    if($tbxIPAddress.Text.Length -gt 0){
        $cmd = "netsh interface ipv4 set address" + $setname
        if($tbxIPAddress.Text -eq "DHCP"){
            $cmd += " source=dhcp"
        } else {
            $cmd += " source=static address=$($tbxIPAddress.Text)"
            if($tbxNetMask.Enabled -eq $true -and $tbxNetMask.Text.Length -gt 0){
                $cmd += " mask=$($tbxNetMask.Text)"
            }
            if($tbxGateway.Enabled -eq $true -and $tbxGateway.Text.Length -gt 0){
                $cmd += " gateway=$($tbxGateway.Text)"
            }
        }
        iex $cmd
    }
    if($tbxDNS1.Text.Length -gt 0){
        $cmd = "netsh interface ipv4 set dnsserver" + $setname
        if($tbxDNS1.Text -eq "DHCP"){
            iex ($cmd + " source=dhcp")
        } else {
            iex ($cmd + " source=static address=none")
            $cmd = "netsh interface ipv4 add dnsserver" + $setname
            iex ($cmd + " address=$($tbxDNS1.Text) validate=no")
            if($tbxDNS2.Enabled -eq $true -and $tbxDNS2.Text.Length -gt 0){
                iex ($cmd + " address=$($tbxDNS2.Text) validate=no")
            }
        }
    }
}

$btnDelete_OnClick= {
    if($LastSelectedIndex -eq ($cmbIPCfgName.Items.count - 1)){ # 新建
        # nothing
    } elseif($LastSelectedIndex -gt 0) { # 自定义项目
        $SavedData = 0..($SavedData.Count - 1)|?{$_ -ne $LastSelectedIndex}|%{$SavedData[$_]}
        $cmbIPCfgName.Items.RemoveAt($LastSelectedIndex)
    } else { # DHCP，不保存
        throw "Never Here!"
    }
    $cmbIPCfgName.SelectedIndex = 0
    $LastSelectedIndex = 0
}

$init = {
    function LoadSavedData(){
        if(Test-Path $SavedFileName){
            $script:SavedData = @(Import-Clixml $SavedFileName)
        }
        $SavedData|%{$cmbIPCfgName.Items.Add($_.Name)}
        $cmbIPCfgName.Items.Add("<新建方案>...")
        $cmbIPCfgName.SelectedIndex = 0
    }
    
    & $btnRefresh_OnClick
    LoadSavedData
    EnableControls
}



#Generated Form Function
function GenerateForm {
########################################################################
# Code Generated By: SAPIEN Technologies PrimalForms (Community Edition) v1.0.10.0
# Generated On: 8/14/2013 11:20 AM
# Generated By: tadvent
########################################################################

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$MainForm = New-Object System.Windows.Forms.Form
$btnSave = New-Object System.Windows.Forms.Button
$tbxDNS2 = New-Object System.Windows.Forms.TextBox
$lblIPCfg = New-Object System.Windows.Forms.Label
$cmbIPCfgName = New-Object System.Windows.Forms.ComboBox
$btnDelete = New-Object System.Windows.Forms.Button
$btnApply = New-Object System.Windows.Forms.Button
$btnRefresh = New-Object System.Windows.Forms.Button
$tbxDNS1 = New-Object System.Windows.Forms.TextBox
$tbxGateway = New-Object System.Windows.Forms.TextBox
$lblDNS = New-Object System.Windows.Forms.Label
$lblGateway = New-Object System.Windows.Forms.Label
$tbxNetMask = New-Object System.Windows.Forms.TextBox
$lblNetMask = New-Object System.Windows.Forms.Label
$lblIPAddress = New-Object System.Windows.Forms.Label
$tbxIPAddress = New-Object System.Windows.Forms.TextBox
$cmbConnectionID = New-Object System.Windows.Forms.ComboBox
$lblConnection = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$MainForm.WindowState = $InitialFormWindowState
    & $init
}

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 333
$System_Drawing_Size.Width = 252
$MainForm.ClientSize = $System_Drawing_Size
$MainForm.DataBindings.DefaultDataSourceUpdateMode = 0
$MainForm.FormBorderStyle = 1
$MainForm.Name = "MainForm"
$MainForm.Text = "IP 修改器"


$btnSave.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 95
$System_Drawing_Point.Y = 293
$btnSave.Location = $System_Drawing_Point
$btnSave.Name = "btnSave"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 60
$btnSave.Size = $System_Drawing_Size
$btnSave.TabIndex = 10
$btnSave.Text = "保存"
$btnSave.UseVisualStyleBackColor = $True
$btnSave.add_Click($btnSave_OnClick)

$MainForm.Controls.Add($btnSave)

$tbxDNS2.DataBindings.DefaultDataSourceUpdateMode = 0
$tbxDNS2.Enabled = $False
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 92
$System_Drawing_Point.Y = 253
$tbxDNS2.Location = $System_Drawing_Point
$tbxDNS2.MaxLength = 15
$tbxDNS2.Name = "tbxDNS2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 129
$tbxDNS2.Size = $System_Drawing_Size
$tbxDNS2.TabIndex = 8
$tbxDNS2.add_KeyUp($AddressValidating)

$MainForm.Controls.Add($tbxDNS2)

$lblIPCfg.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 85
$lblIPCfg.Location = $System_Drawing_Point
$lblIPCfg.Name = "lblIPCfg"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$lblIPCfg.Size = $System_Drawing_Size
$lblIPCfg.TabIndex = 14
$lblIPCfg.Text = "配置方案"
$lblIPCfg.TextAlign = 16

$MainForm.Controls.Add($lblIPCfg)

$cmbIPCfgName.DataBindings.DefaultDataSourceUpdateMode = 0
$cmbIPCfgName.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 111
$cmbIPCfgName.Location = $System_Drawing_Point
$cmbIPCfgName.Name = "cmbIPCfgName"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 192
$cmbIPCfgName.Size = $System_Drawing_Size
$cmbIPCfgName.TabIndex = 3
$cmbIPCfgName.add_SelectedIndexChanged($cmbIPCfgName_OnChanged)
$cmbIPCfgName.add_KeyUp($cmbIPCfgName_OnKeyUp)

$MainForm.Controls.Add($cmbIPCfgName)


$btnDelete.DataBindings.DefaultDataSourceUpdateMode = 0
$btnDelete.Enabled = $False

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 161
$System_Drawing_Point.Y = 293
$btnDelete.Location = $System_Drawing_Point
$btnDelete.Name = "btnDelete"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 60
$btnDelete.Size = $System_Drawing_Size
$btnDelete.TabIndex = 11
$btnDelete.Text = "删除"
$btnDelete.UseVisualStyleBackColor = $True
$btnDelete.add_Click($btnDelete_OnClick)

$MainForm.Controls.Add($btnDelete)


$btnApply.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 293
$btnApply.Location = $System_Drawing_Point
$btnApply.Name = "btnApply"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 60
$btnApply.Size = $System_Drawing_Size
$btnApply.TabIndex = 9
$btnApply.Text = "应用"
$btnApply.UseVisualStyleBackColor = $True
$btnApply.add_Click($btnApply_OnClick)

$MainForm.Controls.Add($btnApply)


$btnRefresh.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 146
$System_Drawing_Point.Y = 24
$btnRefresh.Location = $System_Drawing_Point
$btnRefresh.Name = "btnRefresh"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$btnRefresh.Size = $System_Drawing_Size
$btnRefresh.TabIndex = 1
$btnRefresh.Text = "刷新"
$btnRefresh.UseVisualStyleBackColor = $True
$btnRefresh.add_Click($btnRefresh_OnClick)

$MainForm.Controls.Add($btnRefresh)

$tbxDNS1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 92
$System_Drawing_Point.Y = 226
$tbxDNS1.Location = $System_Drawing_Point
$tbxDNS1.MaxLength = 15
$tbxDNS1.Name = "tbxDNS1"
$tbxDNS1.ReadOnly = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 129
$tbxDNS1.Size = $System_Drawing_Size
$tbxDNS1.TabIndex = 7
$tbxDNS1.add_KeyUp($DHCPAddressValidating)

$MainForm.Controls.Add($tbxDNS1)

$tbxGateway.DataBindings.DefaultDataSourceUpdateMode = 0
$tbxGateway.Enabled = $False
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 92
$System_Drawing_Point.Y = 199
$tbxGateway.Location = $System_Drawing_Point
$tbxGateway.MaxLength = 15
$tbxGateway.Name = "tbxGateway"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 129
$tbxGateway.Size = $System_Drawing_Size
$tbxGateway.TabIndex = 6
$tbxGateway.add_KeyUp($AddressValidating)

$MainForm.Controls.Add($tbxGateway)

$lblDNS.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 224
$lblDNS.Location = $System_Drawing_Point
$lblDNS.Name = "lblDNS"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 57
$lblDNS.Size = $System_Drawing_Size
$lblDNS.TabIndex = 7
$lblDNS.Text = "DNS"
$lblDNS.TextAlign = 16

$MainForm.Controls.Add($lblDNS)

$lblGateway.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 197
$lblGateway.Location = $System_Drawing_Point
$lblGateway.Name = "lblGateway"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 57
$lblGateway.Size = $System_Drawing_Size
$lblGateway.TabIndex = 6
$lblGateway.Text = "网关"
$lblGateway.TextAlign = 16

$MainForm.Controls.Add($lblGateway)

$tbxNetMask.DataBindings.DefaultDataSourceUpdateMode = 0
$tbxNetMask.Enabled = $False
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 92
$System_Drawing_Point.Y = 172
$tbxNetMask.Location = $System_Drawing_Point
$tbxNetMask.MaxLength = 15
$tbxNetMask.Name = "tbxNetMask"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 129
$tbxNetMask.Size = $System_Drawing_Size
$tbxNetMask.TabIndex = 5
$tbxNetMask.add_KeyUp($AddressValidating)

$MainForm.Controls.Add($tbxNetMask)

$lblNetMask.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 170
$lblNetMask.Location = $System_Drawing_Point
$lblNetMask.Name = "lblNetMask"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 57
$lblNetMask.Size = $System_Drawing_Size
$lblNetMask.TabIndex = 4
$lblNetMask.Text = "子网掩码"
$lblNetMask.TextAlign = 16

$MainForm.Controls.Add($lblNetMask)

$lblIPAddress.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 143
$lblIPAddress.Location = $System_Drawing_Point
$lblIPAddress.Name = "lblIPAddress"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 57
$lblIPAddress.Size = $System_Drawing_Size
$lblIPAddress.TabIndex = 3
$lblIPAddress.Text = "IP 地址"
$lblIPAddress.TextAlign = 16

$MainForm.Controls.Add($lblIPAddress)

$tbxIPAddress.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 92
$System_Drawing_Point.Y = 147
$tbxIPAddress.Location = $System_Drawing_Point
$tbxIPAddress.MaxLength = 15
$tbxIPAddress.Name = "tbxIPAddress"
$tbxIPAddress.ReadOnly = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 129
$tbxIPAddress.Size = $System_Drawing_Size
$tbxIPAddress.TabIndex = 4
$tbxIPAddress.add_KeyUp($DHCPAddressValidating)

$MainForm.Controls.Add($tbxIPAddress)

$cmbConnectionID.DataBindings.DefaultDataSourceUpdateMode = 0
$cmbConnectionID.DropDownStyle = 2
$cmbConnectionID.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 55
$cmbConnectionID.Location = $System_Drawing_Point
$cmbConnectionID.Name = "cmbConnectionID"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 192
$cmbConnectionID.Size = $System_Drawing_Size
$cmbConnectionID.TabIndex = 2

$MainForm.Controls.Add($cmbConnectionID)

$lblConnection.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 24
$lblConnection.Location = $System_Drawing_Point
$lblConnection.Name = "lblConnection"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 28
$System_Drawing_Size.Width = 100
$lblConnection.Size = $System_Drawing_Size
$lblConnection.TabIndex = 0
$lblConnection.Text = "网络连接"
$lblConnection.TextAlign = 16

$MainForm.Controls.Add($lblConnection)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $MainForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$MainForm.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$MainForm.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
#######################################################
#*/
