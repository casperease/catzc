<#
---
catzc:
  immutable:
    with_body_sha: "7aec61252ca2"
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Assert-AdoNaming.Tests.ps1
    docs: "[Assert-AdoNaming.ps1.md](docs/references/pwsh/catzc-base-variants/Assert-AdoNaming.ps1.md)"
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
