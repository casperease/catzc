<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Test-Command.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Asserts
    relatives:
      source: automation/Catzc.Base.Asserts/Test-Command.ps1
---
#>

Describe 'Test-Command' -Tag 'L0', 'logic' {
    It 'returns $true for an existing command' {
        Test-Command 'pwsh' | Should -BeTrue
    }

    It 'returns $false for a missing command' {
        Test-Command 'not-a-real-command-xyz' | Should -BeFalse
    }
}
