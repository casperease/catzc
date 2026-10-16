<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/tests/Invoke-Poetry.Tests.ps1
    folder: tests
    name: invoke-poetry-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Invoke-Poetry' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Poetry 'install' -DryRun | Should -Be 'poetry install'
    }
}
