<#
---
catzc:
  immutable:
    with_body_sha: ab6bf8d9dbcb
  edges:
    code: pwsh/Catzc.Tooling.Python/Invoke-Poetry.ps1
---
#>

Describe 'Invoke-Poetry' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Poetry 'install' -DryRun | Should -Be 'poetry install'
    }
}
