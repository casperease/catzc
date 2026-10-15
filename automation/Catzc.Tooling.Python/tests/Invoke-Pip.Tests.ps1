<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/tests/Invoke-Pip.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Tooling.Python/Invoke-Pip.ps1
---
#>

Describe 'Invoke-Pip' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun (routes through uv pip)' {
        Invoke-Pip 'install --system requests' -DryRun | Should -Be 'uv pip install --system requests'
    }
}
