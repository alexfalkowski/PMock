describe "Mock" {
    $module = Import-Module ./TestModule -AsCustomObject

    it "should override methods" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }
        New-Mock $module 'TestSecond' { "Override-Second" }

        $first = $module.TestFirst()
        $second = $module.TestSecond()

        $first.should.be("Override-First")
        $second.should.be("Override-Second")

        Remove-Module PMock
    }

    it "should Confirm-Mock when calling TestFirst function once" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }

        $first = $module.TestFirst()
        $wasCalled = Confirm-Mock $module 'TestFirst'

        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should Confirm-Mock when calling TestFirst function twice" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }

        $first = $module.TestFirst()
        $first = $module.TestFirst()
        $wasCalled = Confirm-Mock $module 'TestFirst'

        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should only register one event when calling Confirm-Mock twice" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }

        $first = $module.TestFirst()
        $wasCalled = Confirm-Mock $module 'TestFirst'
        $wasCalled = Confirm-Mock $module 'TestFirst'

        $wasCalled.should.be($false)

        Remove-Module PMock
    }

    it "should not Confirm-Mock when the TestFirst function was not called" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }

        $wasCalled = Confirm-Mock $module 'TestFirst'

        $wasCalled.should.be($false)

        Remove-Module PMock
    }

    it "should Confirm-Mock when TestFirst function is called with specific arguments" {
        Import-Module ../src/PMock

        New-Mock $module 'TestWithArgs' { "Override-First $($args[0])" }

        $value = $module.TestWithArgs($true)
        $wasCalled = Confirm-Mock $module 'TestWithArgs'

        $value.should.be("Override-First True")
        $wasCalled.should.be($false)

        Remove-Module PMock
    }
}