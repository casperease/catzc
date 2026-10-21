<#
---
catzc:
  immutable:
    with_body_sha: "147eb25fa4b2"
  edges:
    code: pwsh/Catzc.Base.Asserts/Assert-Command.ps1
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
