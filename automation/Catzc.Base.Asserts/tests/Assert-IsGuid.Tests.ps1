<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-IsGuid.Tests.ps1
    folder: tests
    name: assert-is-guid-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
---
#>

Describe 'Assert-IsGuid' -Tag 'L0', 'logic' {
    It 'passes for a valid GUID' {
        { Assert-IsGuid '550e8400-e29b-41d4-a716-446655440000' } | Should -Not -Throw
    }

    It 'passes for a GUID with braces' {
        { Assert-IsGuid '{550e8400-e29b-41d4-a716-446655440000}' } | Should -Not -Throw
    }

    It 'throws for an invalid GUID' {
        { Assert-IsGuid 'not-a-guid' } | Should -Throw
    }
}
