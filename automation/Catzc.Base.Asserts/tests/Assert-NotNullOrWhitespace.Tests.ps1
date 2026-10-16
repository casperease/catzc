<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-NotNullOrWhitespace.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder-module
    bundle: minimal
---
#>

Describe 'Assert-NotNullOrWhitespace' -Tag 'L0', 'logic' {
    It 'passes when value is a non-empty string' {
        { Assert-NotNullOrWhitespace 'hello' } | Should -Not -Throw
    }

    It 'throws when value is $null' {
        { Assert-NotNullOrWhitespace $null } | Should -Throw
    }

    It 'throws when value is empty string' {
        { Assert-NotNullOrWhitespace '' } | Should -Throw
    }

    It 'throws when value is whitespace' {
        { Assert-NotNullOrWhitespace '   ' } | Should -Throw
    }

    It 'uses custom error text when provided' {
        { Assert-NotNullOrWhitespace '' -ErrorText 'custom message' } | Should -Throw -ExpectedMessage 'custom message'
    }
}
