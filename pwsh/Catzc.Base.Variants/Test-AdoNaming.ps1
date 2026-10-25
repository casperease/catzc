<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Test-AdoNaming.ps1.md"
  header: "generated"
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
