<#
---
catzc:
  immutable:
    with_body_sha: "0084db6f975e"
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Test-FileHeadVariant.Tests.ps1
    docs: "[Test-FileHeadVariant.ps1.md](../../docs/references/pwsh/catzc-base-variants/Test-FileHeadVariant.ps1.md)"
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
