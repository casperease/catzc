<#
---
catzc:
  immutable:
    with_body_sha: e5c3204b96a3
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Test-AdoNaming.Tests.ps1
    docs: "[Test-AdoNaming.ps1.md](docs/references/pwsh/catzc-base-variants/Test-AdoNaming.ps1.md)"
---
#>

function Test-AdoNaming {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [switch] $Standard,

        [Parameter(Mandatory, ParameterSetName = 'Classic')]
        [switch] $Classic
    )

    $order = Get-AdoNaming
    ($Standard -and $order -eq 'standard') -or ($Classic -and $order -eq 'classic')
}
