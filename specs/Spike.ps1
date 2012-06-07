Import-Module ./TestModule

$script = {
    $testValue = "Override-First"
    $testValue 
}

function Set-AssertableFunction($functionName, [scriptblock]$script) {
    $setFunction = {
        param($functionaName, [scriptblock]$scriptBlock)
        Set-Item -Path function:$functionaName -Value $scriptBlock.GetNewClosure()

        Export-ModuleMember $functionaName
    }

    New-Module -Name MockModule -ScriptBlock $setFunction -Args $functionName, $script | out-null
}

Set-AssertableFunction "Test-First" $script

Test-First

Remove-Module TestModule