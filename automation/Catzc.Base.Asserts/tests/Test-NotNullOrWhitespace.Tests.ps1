<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Test-NotNullOrWhitespace.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder-module
    bundle: minimal
---
#>

Describe 'Test-NotNullOrWhitespace' -Tag 'L0', 'logic' {
    It 'returns $true for non-empty string' {
        Test-NotNullOrWhitespace 'hello' | Should -BeTrue
    }

    It 'returns $false for $null' {
        Test-NotNullOrWhitespace $null | Should -BeFalse
    }

    It 'returns $false for empty string' {
        Test-NotNullOrWhitespace '' | Should -BeFalse
    }

    It 'returns $false for whitespace' {
        Test-NotNullOrWhitespace '   ' | Should -BeFalse
    }
}
