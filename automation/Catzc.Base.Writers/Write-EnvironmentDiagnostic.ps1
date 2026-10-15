<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/Write-EnvironmentDiagnostic.ps1
    kind: function
    module: Catzc.Base.Writers
    visibility: public
---
#>

<#
.SYNOPSIS
    Displays all environment variables sorted by name.
.EXAMPLE
    Write-EnvironmentDiagnostic
#>
function Write-EnvironmentDiagnostic {
    [CmdletBinding()]
    param()

    Get-ChildItem env: |
        Select-Object Name, Value |
        Sort-Object Name |
        Format-Table -Property @{ Expression = 'Name'; Width = 40 }, Value
}
