<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-False.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder-module
    bundle: minimal
---
#>

Describe 'Assert-False' -Tag 'L0', 'logic' {
    It 'passes when value is $false' {
        { Assert-False $false } | Should -Not -Throw
    }

    It 'throws when value is $true' {
        { Assert-False $true } | Should -Throw
    }

    It 'throws when value is not a boolean' {
        { Assert-False 0 } | Should -Throw
    }

    It 'throws when value is $null' {
        { Assert-False $null } | Should -Throw
    }

    It 'uses custom error text when provided' {
        { Assert-False $true -ErrorText 'custom message' } | Should -Throw -ExpectedMessage 'custom message'
    }
}
