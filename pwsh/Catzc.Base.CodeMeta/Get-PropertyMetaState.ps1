<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.CodeMeta/Get-PropertyMetaState.ps1
    name: get-property-meta-state
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Get-PropertyMetaState.ps1.md](docs/references/pwsh/catzc-base-codemeta/Get-PropertyMetaState.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-JSONCARRIER
---
#>

function Get-PropertyMetaState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $Property,

        [string[]] $Strip = @()
    )

    $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($Text, $Property, $Strip)
    [pscustomobject]@{
        IsObject      = $head.IsObject
        HasHead       = $head.HasHead
        Foreign       = $head.Foreign
        Sections      = [string[]] @($head.Sections)
        ImmutableKeys = [string[]] @($head.ImmutableKeys)
        EdgeKeys      = [string[]] @($head.EdgeKeys)
        ConfigLines   = [string[]] @($head.ConfigLines)
    }
}
