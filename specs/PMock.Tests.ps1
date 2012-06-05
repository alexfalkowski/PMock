describe "Mock" {
    $module = Import-Module ./TestModule -AsCustomObject

    it "should override first function" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        Set-Function $module $functionName { "Override-First" }
        $first = $module.'Test-First'()
        $first.should.be("Override-First")

        Remove-Module PMock
    }

    it "should override second function" {
        Import-Module ../src/PMock

        $functionName = 'Test-Second'
        Set-Function $module $functionName { "Override-Second" }
        $second = $module.'Test-Second'()
        $second.should.be("Override-Second")

        Remove-Module PMock
    }

    it "should Assert-FunctionWasCalled when calling Test-First function once" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        Set-AssertableFunction $module $functionName { "Override-First" }
        $first = $module.'Test-First'()
        $wasCalled = Assert-FunctionWasCalled $module $functionName
        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should Assert-FunctionWasCalled when calling Test-First function twice" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        Set-AssertableFunction $module $functionName { "Override-First" }
        $first = $module.'Test-First'()
        $first = $module.'Test-First'()
        $wasCalled = Assert-FunctionWasCalled $module $functionName
        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should only register one event when calling Assert-FunctionWasCalled twice" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        Set-AssertableFunction $module $functionName { "Override-First" }
        $first = $module.'Test-First'()
        $wasCalled = Assert-FunctionWasCalled $module $functionName
        $wasCalled = Assert-FunctionWasCalled $module $functionName
        $wasCalled.should.be($false)

        Remove-Module PMock
    }

    it "should not Assert-FunctionWasCalled when the Test-First function was not called" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        Set-AssertableFunction $module $functionName { "Override-First" }
        $wasCalled = Assert-FunctionWasCalled $module $functionName
        $wasCalled.should.be($false)

        Remove-Module PMock
    }

    it "should Assert-FunctionWasCalled when Test-WithSingleArgs function is called with specific arguments" {
        Import-Module ../src/PMock

        $functionName = 'Test-WithSingleArgs'
        Set-AssertableFunction $module $functionName { "Override-First $($args[0])" }
        $value = $module.'Test-WithSingleArgs'($true)
        $wasCalled = Assert-FunctionWasCalled $module $functionName $true
        $value.should.be("Override-First True")
        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should not Assert-FunctionWasCalled when Test-WithSingleArgs function is called with wrong arguments" {
        Import-Module ../src/PMock

        $functionName = 'Test-WithSingleArgs'
        Set-AssertableFunction $module $functionName { "Override-First" }
        $value = $module.'Test-WithSingleArgs'($true)
        $wasCalled = Assert-FunctionWasCalled $module $functionName $false
        $wasCalled.should.be($false)

        Remove-Module PMock
    }

    it "should Assert-FunctionWasCalled when Test-WithMultipleArgs function is called with specific arguments" {
        Import-Module ../src/PMock

        $functionName = 'Test-WithMultipleArgs'
        Set-AssertableFunction $module $functionName { "Override-First $($args[0])" }
        $value = $module.'Test-WithMultipleArgs'($true, $true)
        $wasCalled = Assert-FunctionWasCalled $module $functionName $true $true
        $value.should.be("Override-First True")
        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should not Assert-FunctionWasCalled when Test-WithMultipleArgs function is called with wrong arguments" {
        Import-Module ../src/PMock

        $functionName = 'Test-WithMultipleArgs'
        Set-AssertableFunction $module $functionName { "Override-First" }
        $value = $module.'Test-WithMultipleArgs'($true)
        $wasCalled = Assert-FunctionWasCalled $module $functionName $false $true
        $wasCalled.should.be($false)

        Remove-Module PMock
    }
}