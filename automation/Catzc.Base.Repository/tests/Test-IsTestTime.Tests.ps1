Describe 'Test-IsTestTime' -Tag 'L0', 'logic' {

    It 'is true inside a real Pester run (Pester is on the call stack)' {
        Test-IsTestTime | Should -BeTrue
    }

    It 'is false when Pester is not on the call stack' {
        Mock Get-PSCallStack { @([pscustomobject]@{ ScriptName = 'C:/proj/automation/Catzc.Base.Repository/Get-Foo.ps1' }) } -ModuleName Catzc.Base.Repository
        InModuleScope Catzc.Base.Repository { Test-IsTestTime } | Should -BeFalse
    }

    It 'ignores frames with no script name' {
        Mock Get-PSCallStack { @([pscustomobject]@{ ScriptName = $null }, [pscustomobject]@{ ScriptName = 'x/Bar.ps1' }) } -ModuleName Catzc.Base.Repository
        InModuleScope Catzc.Base.Repository { Test-IsTestTime } | Should -BeFalse
    }
}
