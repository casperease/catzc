<#
---
catzc:
  immutable:
    with_body_sha: fbebd685f518
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Test-GitWorkspace.Tests.ps1
    docs: "[Test-GitWorkspace.ps1.md](docs/references/pwsh/catzc-base-variants/Test-GitWorkspace.ps1.md)"
---
#>

function Test-GitWorkspace {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'MainDirect')]
        [switch] $MainDirect,

        [Parameter(Mandatory, ParameterSetName = 'MainViaPr')]
        [switch] $MainViaPr
    )

    $mode = Get-GitWorkspace
    ($MainDirect -and $mode -eq 'main-direct') -or ($MainViaPr -and $mode -eq 'main-via-pr')
}
