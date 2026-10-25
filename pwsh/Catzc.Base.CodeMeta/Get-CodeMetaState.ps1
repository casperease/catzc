<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-code-meta/Get-CodeMetaState.ps1.md"
  warning: "Generated Header"
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
        # The text below the head, the body a generated file's writer hashes too.
        Body          = $head.HasHead ? $head.Rest : $Text
    }
}
