function Set-Function($module, $functionName, $script) {
    Add-Member -inputobject $module -membertype ScriptMethod -name $functionName -value $script -passthru -force | out-null
}

function Set-AssertableFunction($module, $functionName, $script) {
    $newScriptBlock = { 
        New-Event -SourceIdentifier $functionName -EventArguments $args | out-null
        Invoke-Command $script -ArgumentList $args
    }.GetNewClosure()

    Set-Function $module $functionName $newScriptBlock
}

function Assert-FunctionWasCalled() {
    param (
        $module,
        $functionName,
        [parameter(ValueFromRemainingArguments=$true)] $arguments = @()
    )

    $events = Get-Event -SourceIdentifier $functionName -ea SilentlyContinue
    Remove-Event -SourceIdentifier $functionName -ea SilentlyContinue | out-null

    if ($events) {
        $sourceArgs = @()

        if ($events.SourceArgs) {
            $sourceArgs = $events.SourceArgs
        }

        $compare = Compare-Object $arguments $sourceArgs

        if ($compare -eq $null) {
            return $true
        }
    }

    return $false
}