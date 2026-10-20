<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
    folder: private
    name: get-bicep-parameters-file-name
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
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepParametersFileName.Tests.ps1
    docs: "[Get-BicepParametersFileName.ps1.md](docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD
---
#>

function Get-BicepParametersFileName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Environment,

        [Parameter(Position = 1)]
        [string] $Slot,

        [Parameter(Position = 2)]
        [AllowEmptyString()]
        [string] $Customer
    )

    $config = Get-BicepConfigName $Environment $Slot
    if ([string]::IsNullOrEmpty($Customer)) {
        "parameters.$config.json"
    }
    else {
        "parameters.$Customer.$config.json"
    }
}
