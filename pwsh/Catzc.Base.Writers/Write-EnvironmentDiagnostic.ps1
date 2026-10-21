<#
---
catzc:
  immutable:
    with_body_sha: "293f7db84cc4"
  edges:
    test: pwsh/Catzc.Base.Writers/tests/Write-EnvironmentDiagnostic.Tests.ps1
    docs: "[Write-EnvironmentDiagnostic.ps1.md](docs/references/pwsh/catzc-base-writers/Write-EnvironmentDiagnostic.ps1.md)"
---
#>

function Write-EnvironmentDiagnostic {
    [CmdletBinding()]
    param()

    Get-ChildItem env: |
        Select-Object Name, Value |
        Sort-Object Name |
        Format-Table -Property @{ Expression = 'Name'; Width = 40 }, Value
}
