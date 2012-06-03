function New-Spy($module, $functionName, $script) {
    $newScriptBlock = { 
        $privateData = $MyInvocation.MyCommand.Module.PrivateData;
        
        if (!($privateData.ContainsKey($functionName))) {
            $privateData.Add($functionName, $true);
        }
         
        &$script 
    }.GetNewClosure()
    Add-Member -inputobject $module -membertype ScriptMethod -name $functionName -value $newScriptBlock -passthru -force | out-null
}

function Confirm-WasCalled($module, $functionName) {
    $MyInvocation.MyCommand.Module.PrivateData.ContainsKey($functionName)
}