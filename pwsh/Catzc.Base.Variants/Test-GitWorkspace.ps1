<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Test-GitWorkspace.ps1
    name: test-git-workspace
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
