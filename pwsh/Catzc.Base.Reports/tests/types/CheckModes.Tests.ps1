<#
---
catzc:
  immutable:
    with_body_sha: "2e198e2b7628"
  edges:
    docs: "[CheckModes.Tests.ps1.md](docs/references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Reports/types/CheckModes.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - PDR-ONELIVE-ONEVERSION
---
#>

Describe 'CheckModes' -Tag 'L0', 'logic', 'PDR-ONELIVE-ONEVERSION' {
    It 'returns the default, gate, with no error when the mode is omitted' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        foreach ($raw in @($null, [ordered]@{}, [ordered]@{ mode = $null })) {
            $parseError = 'unset'
            [Catzc.Base.Reports.CheckModes]::Parse($raw, [ref]$parseError) | Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
            $parseError | Should -BeNullOrEmpty
        }
    }

    It 'matches a mode by name, in any case' -ForEach @(
        @{ Value = 'report'; Expected = 'Report' }
        @{ Value = 'GATE'; Expected = 'Gate' }
    ) {
        $parseError = 'unset'
        [Catzc.Base.Reports.CheckModes]::Parse([ordered]@{ mode = $Value }, [ref]$parseError) | Should -Be ([Catzc.Base.Reports.CheckMode]$Expected)
        $parseError | Should -BeNullOrEmpty
    }

    It 'refuses a value that names no mode, a number included, with the one error text' -ForEach @(
        @{ Value = 'widget' }
        @{ Value = '1' }
    ) {
        $parseError = $null
        [Catzc.Base.Reports.CheckModes]::Parse([ordered]@{ mode = $Value }, [ref]$parseError) | Should -Be ([Catzc.Base.Reports.CheckMode]::Gate)
        $parseError | Should -Be "mode '$Value' is not one of: gate, report"
    }
}
