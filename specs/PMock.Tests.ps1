describe "Mock" {
    $module = Import-Module ./TestModule -AsCustomObject

    it "should override first function" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        New-Mock $module $functionName { "Override-First" }
        $first = $module.'Test-First'()
        $first.should.be("Override-First")

        Remove-Module PMock
    }

    it "should override second function" {
        Import-Module ../src/PMock

        $functionName = 'Test-Second'
        New-Mock $module $functionName { "Override-Second" }
        $second = $module.'Test-Second'()
        $second.should.be("Override-Second")

        Remove-Module PMock
    }

    it "should Confirm-Mock when calling TestFirst function once" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        New-Mock $module $functionName { "Override-First" }
        $first = $module.'Test-First'()
        $wasCalled = Confirm-Mock $module $functionName
        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should Confirm-Mock when calling TestFirst function twice" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        New-Mock $module $functionName { "Override-First" }
        $first = $module.'Test-First'()
        $first = $module.'Test-First'()
        $wasCalled = Confirm-Mock $module $functionName
        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should only register one event when calling Confirm-Mock twice" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        New-Mock $module $functionName { "Override-First" }
        $first = $module.'Test-First'()
        $wasCalled = Confirm-Mock $module $functionName
        $wasCalled = Confirm-Mock $module $functionName
        $wasCalled.should.be($false)

        Remove-Module PMock
    }

    it "should not Confirm-Mock when the TestFirst function was not called" {
        Import-Module ../src/PMock

        $functionName = 'Test-First'
        New-Mock $module $functionName { "Override-First" }
        $wasCalled = Confirm-Mock $module $functionName
        $wasCalled.should.be($false)

        Remove-Module PMock
    }

    it "should Confirm-Mock when TestFirst function is called with specific arguments" {
        Import-Module ../src/PMock

        $functionName = 'Test-WithArgs'
        New-Mock $module $functionName { "Override-First $($args[0])" }
        $value = $module.'Test-WithArgs'($true)
        $wasCalled = Confirm-Mock $module $functionName
        $value.should.be("Override-First True")
        $wasCalled.should.be($true)

        Remove-Module PMock
    }
}