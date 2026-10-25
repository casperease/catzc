<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ManagedGuids.ps1.md"
  warning: "Generated Header"
---
#>

function Get-ManagedGuids {
    [CmdletBinding()]
    param()

    (Get-Config -Config guids).guids
}
