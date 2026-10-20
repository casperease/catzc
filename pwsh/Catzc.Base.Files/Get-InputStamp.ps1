<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/Get-InputStamp.ps1
    name: get-input-stamp
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-InputStamp.Tests.ps1
    docs: "[Get-InputStamp.ps1.md](docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md)"
    cites:
      - ADR-PRIN-ONELIVE
---
#>

function Get-InputStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [string] $Filter = '*',

        [string[]] $Exclude = @(),

        [string] $Root = (Get-RepositoryRoot),

        [string] $Salt = ''
    )

    [Catzc.Base.Files.InputStamp]::Compute($Path, $Filter, $Exclude, $Root, $Salt)
}
