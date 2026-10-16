<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/tests/Invoke-Poetry.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Python
    relatives:
      source: automation/Catzc.Tooling.Python/Invoke-Poetry.ps1
---
#>

Describe 'Invoke-Poetry' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Poetry 'install' -DryRun | Should -Be 'poetry install'
    }
}
