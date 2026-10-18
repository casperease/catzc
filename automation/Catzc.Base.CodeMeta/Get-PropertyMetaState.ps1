<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.CodeMeta/Get-PropertyMetaState.ps1
    name: get-property-meta-state
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    cites:
      - ADR-REPO-FILEMETA#8
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
