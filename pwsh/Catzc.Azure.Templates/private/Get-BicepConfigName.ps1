<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md"
  warning: "Generated Header"
---
#>

function Get-BicepConfigName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Environment,

        [Parameter(Position = 1)]
        [string] $Slot
    )

    if ([string]::IsNullOrEmpty($Slot)) {
        $Environment
    }
    else {
        "$Environment-$Slot"
    }
}
