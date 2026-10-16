<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Python/tests/Invoke-Python.Tests.ps1
    folder: tests
    name: invoke-python-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Invoke-Python' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun' {
        Invoke-Python '-c "print(42)"' -DryRun | Should -Be 'python -c "print(42)"'
    }

    It 'builds correct multi-arg command via -DryRun' {
        Invoke-Python '-m pip list' -DryRun | Should -Be 'python -m pip list'
    }
}
