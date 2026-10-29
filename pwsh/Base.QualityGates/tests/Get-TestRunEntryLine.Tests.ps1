Describe 'Get-TestRunEntryLine' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { 'C:\widget' }
    }

    It 'dot-sources the repository importer without its janitors when no entry script is given' {
        InModuleScope Catzc.Base.QualityGates { Get-TestRunEntryLine } | Should -Be ". 'C:\widget/importer.ps1' -SkipJanitors"
    }

    It 'dot-sources the entry script with its parameters in name order, a true switch bare and a false one left out' {
        $line = InModuleScope Catzc.Base.QualityGates {
            Get-TestRunEntryLine -EntryScript "C:\gadget's\Import-Catzc.ps1" -EntryParameter @{ Zone = "o'clock"; Quiet = $true; Loud = $false }
        }
        $line | Should -Be ". 'C:\gadget''s\Import-Catzc.ps1' -Quiet -Zone 'o''clock'"
    }
}
