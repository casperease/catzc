<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Python/tests/Invoke-Pip.Tests.ps1
    folder: tests
    name: invoke-pip-tests
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

Describe 'Invoke-Pip' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun (routes through uv pip)' {
        Invoke-Pip 'install --system requests' -DryRun | Should -Be 'uv pip install --system requests'
    }
}
