# Assert-LoadedTypesCurrent with the one measurement (Get-LoadedTypeDrift, in Catzc.Internal.Types) mocked at the
# module boundary ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)). Neutral fixture
# names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Assert-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {
    BeforeEach {
        Mock Import-InternalModule -ModuleName Catzc.Base.TypesSystem { }
        Mock Get-LoadedTypeDrift -ModuleName Catzc.Base.TypesSystem { $script:state }
    }

    It 'is silent when the loaded types are current' {
        $script:state = [pscustomobject]@{ Current = $true; Drift = [string[]] @(); Summary = $null }
        { Assert-LoadedTypesCurrent -ModulesRoot 'C:\widget\automation' } | Should -Not -Throw
    }

    It 'throws naming the drift, both hashes, and the remedy when they are stale' {
        $script:state = [pscustomobject]@{
            Current = $false
            Drift   = [string[]] @('changed Catzc.Widget/Gadget', 'added Catzc.Widget/Sprocket')
            Summary = 'C# types changed since they were loaded (aaaa1111 -> bbbb2222).'
        }
        { Assert-LoadedTypesCurrent -ModulesRoot 'C:\widget\automation' } |
            Should -Throw '*aaaa1111 -> bbbb2222*Drifted: changed Catzc.Widget/Gadget; added Catzc.Widget/Sprocket.*open a new PowerShell*'
    }
}
