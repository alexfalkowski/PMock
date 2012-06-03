Describe "Mock" {
    Import-Module ../src/PMock
    $module = Import-Module ../src/TestModule -AsCustomObject

    It "should override methods" {
        New-Spy $module 'TestFirst' { "Override-First" }
        New-Spy $module 'TestSecond' { "Override-Second" }

        $first = $module.TestFirst()
        $second = $module.TestSecond()

        $first.should.be("Override-First")
        $second.should.be("Override-Second")
    }

    Remove-Module PMock
}
