function New-ManagedModule($functionName, $script, $scriptBlock) {
    $module = New-Module -Name MockModule -ScriptBlock $scriptBlock -Args $functionName, $script

    $module.OnRemove = { 
        Remove-Event -SourceIdentifier "*"
    }

    return $module
}

function New-StubModule($functionName, $script) {
    $setFunction = {
        param($functionaName, [scriptblock]$scriptBlock)
        Set-Item -Path function:$functionaName -Value $scriptBlock.GetNewClosure()

        Export-ModuleMember $functionaName
    }

    return New-ManagedModule $functionName $script $setFunction.GetNewClosure()
}

function New-MockModule($functionName, $script) {
    $setFunction = {
        param($functionName, [scriptblock]$scriptBlock)

        $eventClosure = {
            New-Event -SourceIdentifier $functionName -EventArguments $args | out-null
            Invoke-Command $scriptBlock.GetNewClosure() -ArgumentList $args
        
        }.GetNewClosure()

        Set-Item -Path function:$functionName -Value $eventClosure -force
        Export-ModuleMember $functionName
    }

    return New-ManagedModule $functionName $script $setFunction.GetNewClosure()
}

function Assert-Mock() {
    param (
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