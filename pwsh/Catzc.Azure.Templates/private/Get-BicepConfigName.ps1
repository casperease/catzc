<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
    folder: private
    name: get-bicep-config-name
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-BicepConfigName.ps1.md](docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md)"
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
