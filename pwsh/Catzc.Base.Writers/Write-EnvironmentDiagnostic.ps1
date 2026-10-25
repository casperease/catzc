<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-writers/Write-EnvironmentDiagnostic.ps1.md"
  warning: "Generated Header"
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
