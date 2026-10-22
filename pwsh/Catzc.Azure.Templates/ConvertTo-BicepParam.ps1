<#
---
catzc:
  immutable:
    with_body_sha: "6ef344c5d0aa"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/ConvertTo-BicepParam.Tests.ps1
    docs: "[ConvertTo-BicepParam.ps1.md](../../docs/references/pwsh/catzc-azure-templates/ConvertTo-BicepParam.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD-ONEPATHTOPARAMETERS
---
#>

function ConvertTo-BicepParam {
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
