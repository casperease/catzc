<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Files/Get-InputStamp.ps1
    name: get-input-stamp
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Files/tests/Get-InputStamp.Tests.ps1
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
