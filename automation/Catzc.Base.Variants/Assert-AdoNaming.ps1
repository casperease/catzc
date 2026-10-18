<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/Assert-AdoNaming.ps1
    name: assert-ado-naming
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Variants/tests/Assert-AdoNaming.Tests.ps1
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
