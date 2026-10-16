<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.CodeMeta/Get-CodeMetaState.ps1
    name: get-code-meta-state
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.CodeMeta/tests/Get-CodeMetaState.Tests.ps1
    cites:
      - ADR-REPO-CODEMETA#1
  config:
    synopsis: Reads what a code text says about its own meta head, without changing it.
    description: |-
      Pure: it takes the text and the head's comment syntax, reads no file and no config.
    parameters:
      Text: The whole code file as text.
      Form: 'The head''s comment syntax: a Catzc.Base.CodeMeta.HeadForm.'
    outputs: |-
      [pscustomobject] @{ HasHead; Sections; ImmutableKeys; EdgeKeys; EdgeLists; ConfigLines; Before; Rest; NewLine } — Sections are the keys
      directly under `catzc`, ImmutableKeys the keys under `immutable`, EdgeKeys the edge names under `edges`, EdgeLists each list edge with
      its items, and ConfigLines the authored lines under `config`, as written.
    examples:
      - Get-CodeMetaState -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')) | Select-Object -ExpandProperty ImmutableKeys
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
