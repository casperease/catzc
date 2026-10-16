<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/tests/Invoke-Poetry.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Invoke-Poetry' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Poetry 'install' -DryRun | Should -Be 'poetry install'
    }
}
