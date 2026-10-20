<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Test-AdoNaming.ps1
    name: test-ado-naming
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
