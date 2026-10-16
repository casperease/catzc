<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/tests/Test-Command.Tests.ps1
    folder: tests
    name: test-command-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
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
