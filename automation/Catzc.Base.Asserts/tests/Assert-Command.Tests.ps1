<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/tests/Assert-Command.Tests.ps1
    folder: tests
    name: assert-command-tests
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

Describe 'Assert-Command' -Tag 'L0', 'logic' {
    It 'passes for an installed command' {
        { Assert-Command 'pwsh' } | Should -Not -Throw
    }

    Context 'missing command' -Tag 'L2' {
        It 'throws for a missing command' {
            { Assert-Command 'not-a-real-command-xyz' } | Should -Throw
        }
    }
}
