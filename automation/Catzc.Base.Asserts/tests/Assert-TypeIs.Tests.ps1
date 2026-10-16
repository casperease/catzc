<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Asserts/tests/Assert-TypeIs.Tests.ps1
    folder: tests
    name: assert-type-is-tests
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

Describe 'Assert-TypeIs' -Tag 'L0', 'logic' {
    It 'passes when type matches' {
        { Assert-TypeIs 'hello' 'System.String' } | Should -Not -Throw
    }

    It 'passes for int type' {
        { Assert-TypeIs 42 'System.Int32' } | Should -Not -Throw
    }

    It 'throws when type does not match' {
        { Assert-TypeIs 'hello' 'System.Int32' } | Should -Throw
    }

    It 'includes actual type in error message' {
        { Assert-TypeIs 'hello' 'System.Int32' } | Should -Throw -ExpectedMessage '*System.String*'
    }
}
