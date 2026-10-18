<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.CodeMeta/Get-CodeMetaState.ps1
    name: get-code-meta-state
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
    test: automation/Catzc.Base.CodeMeta/tests/Get-CodeMetaState.Tests.ps1
    cites:
      - ADR-REPO-CODEMETA#1
---
#>

function Get-CodeMetaState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.HeadForm] $Form
    )

    $head = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($Text, $Form)
    $lists = [ordered]@{}
    foreach ($key in $head.EdgeKeys) {
        $items = [string[]] @($head.EdgeList($key))
        if ($items.Count -gt 0) {
            $lists[$key] = $items
        }
    }
    [pscustomobject]@{
        HasHead       = $head.HasHead
        Sections      = [string[]] @($head.Sections)
        ImmutableKeys = [string[]] @($head.ImmutableKeys)
        EdgeKeys      = [string[]] @($head.EdgeKeys)
        EdgeLists     = $lists
        ConfigLines   = [string[]] @($head.ConfigLines)
        Before        = $head.Before
        Rest          = $head.Rest
        NewLine       = $head.NewLine
    }
}
