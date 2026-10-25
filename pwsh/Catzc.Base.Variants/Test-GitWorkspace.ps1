<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Test-GitWorkspace.ps1.md"
  warning: "Generated Header"
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
