Import-Module ./TestModule

$script = {
    $testValue = "Override-First"
    $testValue 
}

function New-MockedModule($functionName, [scriptblock]$script) {
    $setFunction = {
        param($functionaName, [scriptblock]$scriptBlock)
        Set-Item -Path function:$functionaName -Value $scriptBlock.GetNewClosure()

        Export-ModuleMember $functionaName
    }

    New-Module -Name MockModule -ScriptBlock $setFunction -Args $functionName, $script
}

$module = New-MockedModule "Test-First" $script
Import-Module $module

Test-First

Remove-Module $module
Remove-Module TestModule

Get-Module