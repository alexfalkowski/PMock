Describe "Mock" {
    It "should override methods" {
        Import-Module ../src/TestModule
        $first = Test-First
        $second = Test-Second

        $first.should.be("Override-First")
        $second.should.be("Override-Second")
        Remove-Module TestModule
    }
}
