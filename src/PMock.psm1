function New-StubModule($functionName, $script) {
    $setFunction = {
        param($functionaName, [scriptblock]$scriptBlock)
        Set-Item -Path function:$functionaName -Value $scriptBlock.GetNewClosure()

        Export-ModuleMember $functionaName
    }

    New-Module -Name MockModule -ScriptBlock $setFunction.GetNewClosure() -Args $functionName, $script
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

    New-Module -Name MockModule -ScriptBlock $setFunction.GetNewClosure() -Args $functionName, $script
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