Describe 'Get-TestRunNothingToRunMessage' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-POSTBUILDTAG' {
    It 'names the level range when no test file is in scope' {
        InModuleScope Catzc.Base.QualityGates {
            Get-TestRunNothingToRunMessage -TestFileCount 0 -MinLevel 1 -MaxLevel 3
        } | Should -Be 'No test in scope at L1-L3 — nothing to run.'
    }

    It 'says the modules are protected when files were in scope' {
        InModuleScope Catzc.Base.QualityGates {
            Get-TestRunNothingToRunMessage -TestFileCount 4 -MinLevel 0 -MaxLevel 2
        } | Should -Be 'Every module in scope is protected — nothing to run.'
    }
}
