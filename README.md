PMock
=====

A PowerShell mocking framework

Usage
-----

To use this module you need to install the module from [PSGet](http://psget.net/) using the command:
	Install-Module PMock

Once you have module installed this example overrides a function name by creating a mock module:

	$functionName = 'Test-First'
    $module = New-MockModule $functionName { "Override-First" }
    Import-Module $module
    $first = Test-First
    $wasCalled = Assert-Mock $functionName
    $wasCalled.should.be($true)
    Remove-Module $module

Please check out more examples in the /specs folder.