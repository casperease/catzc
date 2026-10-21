<#
---
catzc:
  immutable:
    with_body_sha: c0063dc236fa
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/ConvertTo-BicepParam.Tests.ps1
    cites:
      - ADR-AZ-DATAMOD-ONEPATHTOPARAMETERS
---
#>

function ConvertTo-BicepParam {
    <#
    .SYNOPSIS
        Renders a slot's prepared configuration descriptor as Bicep's own parameters format, a .bicepparam text.

    .DESCRIPTION
        The build's one path to the deploy
        ([ADR-AZ-DATAMOD-ONEPATHTOPARAMETERS](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-onepathtoparameters)): every slot becomes a .bicepparam that bicep build-params
        compiles to the ARM parameters JSON. This renders a yml slot's ParametersFile.parameters after its addresses resolve and its
        PrePost hook runs: a value becomes a Bicep literal and a Key Vault reference becomes az.getSecret(...), in the layout bicep format
        leaves unchanged. The parameters pass through the same JSON the ARM parameters file is written as, so a typed config record an
        address resolves to, or a hook's wrapped value, reaches the writer as exactly the data that JSON holds.

    .PARAMETER Descriptor
        The prepared configuration descriptor, holding ParametersFile.parameters.

    .PARAMETER Using
        The using path: the template's main.bicep, relative to the folder the .bicepparam is written to.

    .OUTPUTS
        [string] The .bicepparam text.

    .EXAMPLE
        ConvertTo-BicepParam -Descriptor $prepared -Using '../../infrastructure/templates/widget/main.bicep'
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Descriptor,

        [Parameter(Mandatory)]
        [string] $Using
    )

    $parametersFile = $Descriptor['ParametersFile']
    Assert-True ($parametersFile -is [System.Collections.IDictionary] -and $parametersFile.Contains('parameters')) `
        -ErrorText 'ConvertTo-BicepParam: the descriptor holds no ParametersFile.parameters to render.'
    $plain = $parametersFile.parameters | ConvertTo-Json -Depth 20 | ConvertFrom-Json -AsHashtable -DateKind String
    [Catzc.Azure.Templates.BicepParamWriter]::Write($Using, $plain)
}
