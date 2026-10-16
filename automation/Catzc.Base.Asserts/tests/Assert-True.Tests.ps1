<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Asserts/tests/Assert-True.Tests.ps1
    folder: tests
    name: assert-true-tests
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

Describe 'Assert-True' -Tag 'L0', 'logic' {
    It 'passes when value is $true' {
        { Assert-True $true } | Should -Not -Throw
    }

    It 'throws when value is $false' {
        { Assert-True $false } | Should -Throw
    }

    It 'throws when value is not a boolean' {
        { Assert-True 1 } | Should -Throw
    }

    It 'throws when value is $null' {
        { Assert-True $null } | Should -Throw
    }

    It 'uses custom error text when provided' {
        { Assert-True $false -ErrorText 'custom message' } | Should -Throw -ExpectedMessage 'custom message'
    }
}
