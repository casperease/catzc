<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Assert-AdoNaming.ps1.md"
  header: "generated"
---
#>

function Assert-AdoNaming {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [switch] $Standard,

        [Parameter(Mandatory, ParameterSetName = 'Classic')]
        [switch] $Classic
    )

    $order = Get-AdoNaming
    $isMatch = ($Standard -and $order -eq 'standard') -or ($Classic -and $order -eq 'classic')
    $want = if ($Standard) {
        'standard'
    }
    else {
        'classic'
    }
    Assert-True $isMatch -ErrorText "Expected ado_naming '$want' but the repo is '$order' — set ado_naming in variants.yml."
}
