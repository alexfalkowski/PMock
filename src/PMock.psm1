function Set-Function($module, $functionName, $script) {
    Add-Member -inputobject $module -membertype ScriptMethod -name $functionName -value $script -passthru -force | out-null
}

function Set-AssertableFunction($module, $functionName, $script) {
    $newScriptBlock = { 
        New-Event -SourceIdentifier $functionName | out-null
        & $script $args 
    }.GetNewClosure()

    Set-Function $module $functionName $newScriptBlock
}

function Assert-FunctionWasCalled($module, $functionName, $arguments = @()) {
    $events = Get-Event -SourceIdentifier $functionName -ea SilentlyContinue
    Remove-Event -SourceIdentifier $functionName -ea SilentlyContinue | out-null

    if ($events) {
        return $true
    }

    return $false
}