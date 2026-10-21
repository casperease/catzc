<#
---
catzc:
  immutable:
    with_body_sha: b8cc4ca14c4e
  edges:
    code: pwsh/Catzc.Tooling.Python/Invoke-Pip.ps1
---
#>

Describe 'Invoke-Pip' -Tag 'L0', 'logic' {
    It 'builds correct command via -DryRun (routes through uv pip)' {
        Invoke-Pip 'install --system requests' -DryRun | Should -Be 'uv pip install --system requests'
    }
}
