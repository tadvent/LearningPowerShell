@ECHO OFF
powershell.exe -sta -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split '\s+';$f|Out-String|iex"
EXIT /B
############################################################

# Edit to change the pad size and pad file's name.
$PAD_SIZE = 97MB
$PAD_FILE = '__padding__'

function Create-Dummy ($filepath, $size) {
    $stream = [IO.File]::Create($filepath)
    $stream.SetLength($size)
    $stream.Close()
}

function Pad-Folder ($folder, $padfile, $size){
    $fsize = (dir -LiteralPath $folder -Recurse `
        | Measure-Object -Property 'Length' -Sum).Sum
    if($fsize -lt $size){
        $dpath = Join-Path $folder $padfile
        if(Test-Path -LiteralPath $dpath -PathType leaf){
            $fsize -= (Get-Item -LiteralPath $dpath).Length
        }
        try{
            Create-Dummy $dpath ($size - $fsize)
            Write-Host "[OK]" -ForegroundColor Green -NoNewline
            Write-Host " Create dummy file: $dpath : $($size - $fsize) bytes."
        }
        catch{
            Write-Host -ForegroundColor Red "[ERROR] Cannot create dummy file: $dpath"
        }
    } else {
        Write-Host "[Skip]" -ForegroundColor Yellow -NoNewline
        Write-Host " Size of $folder is larger than PAD_SIZE"
    }
}


$OnDragDrop= 
{
    $this.Text = "Padding ..."
    $fs = [string[]]$_.Data.GetData([System.Windows.Forms.DataFormats]::FileDrop)
    foreach($fpath in $fs){
        #Write-Host "Path to pad: $fpath"
        if(Test-Path -LiteralPath $fpath -PathType container){
            $this.Text = "Padding $fpath ..."
            Pad-Folder $fpath $PAD_FILE $PAD_SIZE
        } else {
            Write-Host "[Skip]" -ForegroundColor Yellow -NoNewline
            Write-Host " Skip file: $fpath"
        }
    }
    $this.Text = "Please drag folders here."
}

$OnDragLeave= 
{
    $this.Text = "Please drag folders here."
}

$OnDragEnter= 
{
    $this.Text = "Dragging ..."
    $_.Effect = [System.Windows.Forms.DragDropEffects]::Copy
}

#Generated Form Function
function GenerateForm {

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$MainForm = New-Object System.Windows.Forms.Form
$MainLabel = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
    $MainForm.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 112
$System_Drawing_Size.Width = 284
$MainForm.ClientSize = $System_Drawing_Size
$MainForm.DataBindings.DefaultDataSourceUpdateMode = 0
$MainForm.FormBorderStyle = 1
$MainForm.Name = "MainForm"
$MainForm.StartPosition = 1
$MainForm.Text = "Folder Fill"

$MainLabel.AllowDrop = $True
$MainLabel.DataBindings.DefaultDataSourceUpdateMode = 0
$MainLabel.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 9
$MainLabel.Location = $System_Drawing_Point
$MainLabel.Name = "MainLabel"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 94
$System_Drawing_Size.Width = 260
$MainLabel.Size = $System_Drawing_Size
$MainLabel.TabIndex = 0
$MainLabel.Text = "Please drag folders here."
$MainLabel.TextAlign = 32
$MainLabel.add_DragDrop($OnDragDrop)
$MainLabel.add_DragLeave($OnDragLeave)
$MainLabel.add_DragEnter($OnDragEnter)

$MainForm.Controls.Add($MainLabel)

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

############################################################
