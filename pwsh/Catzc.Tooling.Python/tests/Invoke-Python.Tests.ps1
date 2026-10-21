<#
---
catzc:
  immutable:
    with_body_sha: "5f28fd671234"
  edges:
    code: pwsh/Catzc.Tooling.Python/Invoke-Python.ps1
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
