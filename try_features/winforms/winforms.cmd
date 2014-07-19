@ECHO OFF
powershell.exe -Command "$a,$b,$c,$f=(cat '%~f0');$params='%~f0 %*' -split '\s+';$f|Out-String|iex"
EXIT /B
############################################################

function Get-OkCancel{
    [cmdletbinding()]
    param($question = 
        "This is a question, OK or Cancel?")

    function New-Point($x, $y){
        New-Object Drawing.Point $x, $y
    }
    
    Add-Type -AssemblyName System.Drawing, System*forms
    
    $form = new-object windows.forms.form
    $form.text = "Pick OK or Cancel"
    $form.size = new-point 400 200
    
    $label = new-object windows.forms.label
    $label.text = $question
    $label.location = new-point 50 50
    $label.size = new-point 350 50
    $label.anchor = "top"
    
    $ok = new-object windows.forms.button
    $ok.text = "OK"
    $ok.location = new-point 50 120
    $ok.anchor = "bottom, left"
    $ok.add_click({
        $form.DialogResult = "OK"
        $form.close()
    })
    
    $cancel = new-object windows.forms.button
    $cancel.text = "Cancel"
    $cancel.location = new-point 275 120
    $cancel.anchor = "bottom, right"
    $cancel.add_click({
        $form.dialogResult = "Cancel"
        $form.close()
    })
    
    
    $form.controls.addrange(($label, $ok, $cancel))
    $form.add_shown({$form.activate()})
    $form.showdialog()
}

Get-OkCancel

$params

############################################################
#cmd /c "pause"

