<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Test-FileHeadVariant.ps1
    name: test-file-head-variant
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
    test: pwsh/Catzc.Base.Variants/tests/Test-FileHeadVariant.Tests.ps1
    docs: "[Test-FileHeadVariant.ps1.md](docs/references/pwsh/catzc-base-variants/Test-FileHeadVariant.ps1.md)"
---
#>

function Test-FileHeadVariant {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Minimal')]
        [switch] $Minimal,

        [Parameter(Mandatory, ParameterSetName = 'None')]
        [switch] $None
    )

    $mode = Get-FileHeadVariant
    ($Minimal -and $mode -eq 'minimal') -or ($None -and $mode -eq 'none')
}
