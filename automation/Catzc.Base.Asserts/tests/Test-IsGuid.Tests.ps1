<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Asserts/tests/Test-IsGuid.Tests.ps1
    folder: tests
    name: test-is-guid-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
---
#>

Describe 'Test-IsGuid' -Tag 'L0', 'logic' {
    It 'returns $true for a valid GUID' {
        Test-IsGuid '550e8400-e29b-41d4-a716-446655440000' | Should -BeTrue
    }

    It 'returns $true for a GUID with braces' {
        Test-IsGuid '{550e8400-e29b-41d4-a716-446655440000}' | Should -BeTrue
    }

    It 'returns $false for an invalid string' {
        Test-IsGuid 'not-a-guid' | Should -BeFalse
    }

    It 'rejects an empty string' {
        { Test-IsGuid '' } | Should -Throw
    }
}
