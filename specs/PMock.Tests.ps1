Describe "Mock" {
    $module = Import-Module ./TestModule -AsCustomObject

    It "should override methods" {
        Import-Module ../src/PMock

        New-Spy $module 'TestFirst' { "Override-First" }
        New-Spy $module 'TestSecond' { "Override-Second" }

        $first = $module.TestFirst()
        $second = $module.TestSecond()

        $first.should.be("Override-First")
        $second.should.be("Override-Second")

        Remove-Module PMock
    }

    It "should have called TestFirst function" {
        Import-Module ../src/PMock

        New-Spy $module 'TestFirst' { "Override-First" }

        $first = $module.TestFirst()
        $wasCalled = Confirm-WasCalled $module 'TestFirst'

        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    It "should have called TestFirst function twice" {
        Import-Module ../src/PMock

        New-Spy $module 'TestFirst' { "Override-First" }

        $first = $module.TestFirst()
        $first = $module.TestFirst()
        $wasCalled = Confirm-WasCalled $module 'TestFirst'

        $wasCalled.should.be($true)

        Remove-Module PMock
    }

    It "should not have called TestFirst function" {
        Import-Module ../src/PMock

        New-Spy $module 'TestFirst' { "Override-First" }

        $wasCalled = Confirm-WasCalled $module 'TestFirst'

        $wasCalled.should.be($false)

        Remove-Module PMock
    }
}