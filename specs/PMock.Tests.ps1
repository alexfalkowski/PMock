describe "Mock" {
    Import-Module ../src/PMock

    it "should override first function" {
        $module = New-StubModule 'Test-First' { "Override-First" }
        Import-Module $module
        $first = Test-First
        $first.should.be("Override-First")
        Remove-Module $module
    }

    it "should override second function" {
        $module = New-StubModule 'Test-Second' { "Override-Second" }
        Import-Module $module
        $first = Test-Second
        $first.should.be("Override-Second")
        Remove-Module $module
    }

    it "should Assert-Mock when calling Test-First function once" {
        $functionName = 'Test-First'
        $module = New-MockModule $functionName { "Override-First" }
        Import-Module $module
        $first = Test-First
        $wasCalled = Assert-Mock $functionName
        $wasCalled.should.be($true)
        Remove-Module $module
    }

    it "should Assert-Mock when calling Test-First function twice" {
        $functionName = 'Test-First'
        $module = New-MockModule $functionName { "Override-First" }
        Import-Module $module
        $first = Test-First
        $first = Test-First
        $wasCalled = Assert-Mock $functionName
        $wasCalled.should.be($true)
        Remove-Module $module
    }

    it "should only register one event when calling Assert-Mock twice" {
        $functionName = 'Test-First'
        $module = New-MockModule $functionName { "Override-First" }
        Import-Module $module
        $first = Test-First
        $wasCalled = Assert-Mock $functionName
        $wasCalled = Assert-Mock $functionName
        $wasCalled.should.be($false)
        Remove-Module $module
    }

    it "should not Assert-Mock when the Test-First function was not called" {
        $functionName = 'Test-First'
        $module = New-MockModule $functionName { "Override-First" }
        Import-Module $module
        $wasCalled = Assert-Mock $functionName
        $wasCalled.should.be($false)
        Remove-Module $module
    }

    it "should Assert-Mock when Test-WithSingleArgs function is called with specific arguments" {
        $functionName = 'Test-WithSingleArgs'
        $module = New-MockModule $functionName { "Override-First $($args[0])" }
        Import-Module $module
        $value = Test-WithSingleArgs $true
        $wasCalled = Assert-Mock $functionName $true
        $value.should.be("Override-First True")
        $wasCalled.should.be($true)
        Remove-Module $module
    }

    it "should not Assert-Mock when Test-WithSingleArgs function is called with wrong arguments" {
        $functionName = 'Test-WithSingleArgs'
        $module = New-MockModule $functionName { "Override-First $($args[0])" }
        Import-Module $module
        $value = Test-WithSingleArgs $true
        $wasCalled = Assert-Mock $functionName $false
        $value.should.be("Override-First True")
        $wasCalled.should.be($false)
        Remove-Module $module
    }

    it "should Assert-Mock when Test-WithMultipleArgs function is called with specific arguments" {
        $functionName = 'Test-WithSingleArgs'
        $module = New-MockModule $functionName { "Override-First $($args[0])" }
        Import-Module $module
        $value = Test-WithSingleArgs $true $true
        $wasCalled = Assert-Mock $functionName $true $true
        $value.should.be("Override-First True")
        $wasCalled.should.be($true)
        Remove-Module $module
    }

    it "should not Assert-Mock when Test-WithMultipleArgs function is called with wrong arguments" {
        $functionName = 'Test-WithSingleArgs'
        $module = New-MockModule $functionName { "Override-First $($args[0])" }
        Import-Module $module
        $value = Test-WithSingleArgs $true $true
        $wasCalled = Assert-Mock $functionName $false $true
        $value.should.be("Override-First True")
        $wasCalled.should.be($false)
        Remove-Module $module
    }

    Remove-Module PMock
}