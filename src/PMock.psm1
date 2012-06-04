function New-Mock($module, $functionName, $script) {
    $newScriptBlock = { 
        New-Event -SourceIdentifier $functionName | out-null
         
        &$script 
    }.GetNewClosure()
    Add-Member -inputobject $module -membertype ScriptMethod -name $functionName -value $newScriptBlock -passthru -force | out-null
}

function Confirm-Mock($module, $functionName) {
    $events = Get-Event -SourceIdentifier $functionName -ea SilentlyContinue

    Remove-Event -SourceIdentifier $functionName -ea SilentlyContinue | out-null

    $events -and ($events.Length -gt 0)
}