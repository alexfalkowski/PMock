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

    it "should have called TestFirst function" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }

        $first = $module.TestFirst()
        $wasCalled = Confirm-Mock $module 'TestFirst'

        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should have called TestFirst function twice" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }

        $first = $module.TestFirst()
        $first = $module.TestFirst()
        $wasCalled = Confirm-Mock $module 'TestFirst'

        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    it "should not have called TestFirst function" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }

        $wasCalled = Confirm-Mock $module 'TestFirst'

        $wasCalled.should.be($false)

        Remove-Module PMock
    }

    it "should have been called with specific arguments" {
        Import-Module ../src/PMock

        New-Mock $module 'TestFirst' { "Override-First" }

        $value = $module.TestWithArgs($true)
        $wasCalled = Confirm-Mock $module 'TestWithArgs'

        $wasCalled.should.be($false)

        Remove-Module PMock
    }
}