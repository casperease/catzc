<#
---
catzc:
  immutable:
    with_body_sha: c59c3b8929fa
  edges:
    docs: "[Get-BicepConfigName.ps1.md](../../../docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
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
