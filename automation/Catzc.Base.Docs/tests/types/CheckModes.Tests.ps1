<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md
      source: automation/Catzc.Base.Docs/types/CheckModes.cs
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TEST#3
      - ADR-PRIN-ONELIVE#1
---
#>

Describe 'CheckModes' -Tag 'L0', 'logic', 'ADR-PRIN-ONELIVE#1' {
    It 'returns the default, gate, with no error when the mode is omitted' -Tag 'ADR-AUTO-DEFAULT#6' {
        foreach ($raw in @($null, [ordered]@{}, [ordered]@{ mode = $null })) {
            $parseError = 'unset'
            [Catzc.Base.Docs.CheckModes]::Parse($raw, [ref]$parseError) | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
            $parseError | Should -BeNullOrEmpty
        }
    }

    It 'matches a mode by name, in any case' -ForEach @(
        @{ Value = 'report'; Expected = 'Report' }
        @{ Value = 'GATE'; Expected = 'Gate' }
    ) {
        $parseError = 'unset'
        [Catzc.Base.Docs.CheckModes]::Parse([ordered]@{ mode = $Value }, [ref]$parseError) | Should -Be ([Catzc.Base.Docs.CheckMode]$Expected)
        $parseError | Should -BeNullOrEmpty
    }

    It 'refuses a value that names no mode, a number included, with the one error text' -ForEach @(
        @{ Value = 'widget' }
        @{ Value = '1' }
    ) {
        $parseError = $null
        [Catzc.Base.Docs.CheckModes]::Parse([ordered]@{ mode = $Value }, [ref]$parseError) | Should -Be ([Catzc.Base.Docs.CheckMode]::Gate)
        $parseError | Should -Be "mode '$Value' is not one of: gate, report"
    }
}
