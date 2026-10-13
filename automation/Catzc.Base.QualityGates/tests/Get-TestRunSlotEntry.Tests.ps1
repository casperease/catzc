Describe 'Get-TestRunSlotEntry' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:inPlace = [pscustomobject]@{ Mode = 'InPlace'; SourceRoot = 'C:\widget'; Root = 'C:\widget' }
        $script:snapshot = [pscustomobject]@{ Mode = 'Snapshot'; SourceRoot = 'C:\widget'; Root = 'C:\tmp\catzc-run-gadget' }
        $script:resolve = {
            param($Slot, [string] $EntryScript, [hashtable] $EntryParameter = @{})
            InModuleScope Catzc.Base.QualityGates -Parameters @{ S = $Slot; E = $EntryScript; P = $EntryParameter } {
                param($S, $E, $P)
                Get-TestRunSlotEntry -Slot $S -EntryScript $E -EntryParameter $P
            }
        }
    }

    It 'passes the entry through unchanged in place' {
        $entry = & $script:resolve $script:inPlace 'C:\build\Import-Catzc.ps1' @{ RepositoryRoot = 'C:\widget' }
        $entry.EntryScript | Should -Be 'C:\build\Import-Catzc.ps1'
        $entry.EntryParameter.RepositoryRoot | Should -Be 'C:\widget'
    }

    It 'loads the snapshot''s own importer, without janitors, for the source run' {
        $entry = & $script:resolve $script:snapshot ''
        $entry.EntryScript | Should -Be 'C:\tmp\catzc-run-gadget\importer.ps1'
        $entry.EntryParameter.SkipJanitors | Should -BeTrue
    }

    It 'keeps a run''s own entry script and maps only its repository paths into the snapshot' {
        $entry = & $script:resolve $script:snapshot 'C:\build\Import-Catzc.ps1' @{ RepositoryRoot = 'C:\widget'; Silent = $true }
        $entry.EntryScript | Should -Be 'C:\build\Import-Catzc.ps1'
        $entry.EntryParameter.RepositoryRoot | Should -Be 'C:\tmp\catzc-run-gadget'
        $entry.EntryParameter.Silent | Should -BeTrue
    }
}
