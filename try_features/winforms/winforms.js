cmd = "powershell.exe -Command \"$f=(cat \'_\');$f|select -skip 4|Out-String|iex\"";
var obj = WScript.CreateObject("WScript.Shell");
obj.run("cmd /c start /b " + cmd.replace(/_/g, WScript.ScriptFullName),0);
/*
#######################################################

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
    $ok.text = "好的"
    $ok.location = new-point 50 120
    $ok.anchor = "bottom, left"
    $ok.add_click({
        $form.DialogResult = "OK"
        $form.close()
    })
    
    $cancel = new-object windows.forms.button
    $cancel.text = "取消"
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

Get-OkCancel "A loooooooooooooooooooooooooooooooooooooooooooooooooog Line"

#######################################################
#*/