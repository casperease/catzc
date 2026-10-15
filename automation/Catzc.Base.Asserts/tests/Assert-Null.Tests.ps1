<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-Null.Tests.ps1
    kind: test
---
#>

Describe 'Assert-Null' -Tag 'L0', 'logic' {
    It 'passes when value is $null' {
        { Assert-Null $null } | Should -Not -Throw
    }

    It 'throws when value is a string' {
        { Assert-Null 'hello' } | Should -Throw
    }

    It 'throws when value is a number' {
        { Assert-Null 0 } | Should -Throw
    }

    It 'uses custom error text when provided' {
        { Assert-Null 'x' -ErrorText 'custom message' } | Should -Throw -ExpectedMessage 'custom message'
    }
}
