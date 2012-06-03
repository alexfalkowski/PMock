function New-Spy($module, $functionName, [ScriptBlock]$script) {
    Add-Member -inputobject $module -membertype ScriptMethod -name $functionName -value $script -passthru -force | out-null
}