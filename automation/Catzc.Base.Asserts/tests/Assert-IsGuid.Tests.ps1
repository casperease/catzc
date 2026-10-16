<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-IsGuid.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder-module
    bundle: minimal
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
