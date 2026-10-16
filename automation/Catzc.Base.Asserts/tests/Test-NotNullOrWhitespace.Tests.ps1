<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Test-NotNullOrWhitespace.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    relatives:
      source: automation/Catzc.Base.Asserts/Test-NotNullOrWhitespace.ps1
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
