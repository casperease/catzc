<#
---
catzc:
  immutable:
    with_body_sha: e5eb92e99495
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
