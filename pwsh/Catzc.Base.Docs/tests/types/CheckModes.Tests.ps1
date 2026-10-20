<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
    folder: tests/types
    name: check-modes-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[CheckModes.Tests.ps1.md](docs/references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-PRIN-ONELIVE-ONEVERSION
---
#>

Describe 'CheckModes' -Tag 'L0', 'logic', 'ADR-PRIN-ONELIVE-ONEVERSION' {
    It 'returns the default, gate, with no error when the mode is omitted' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
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
