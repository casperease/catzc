<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Get-CodeMetaState.ps1
    kind: automation-function
    module: Catzc.Base.CodeMeta
    visibility: public
    relatives:
      test: automation/Catzc.Base.CodeMeta/tests/Get-CodeMetaState.Tests.ps1
    adrs:
      - ADR-REPO-CODEMETA#1
  config:
    synopsis: Reads what a code text says about its own meta head, without changing it.
    description: |-
      Pure: it takes the text and the head's comment syntax, reads no file and no config.
    parameters:
      Text: The whole code file as text.
      Form: 'The head''s comment syntax: a Catzc.Base.CodeMeta.HeadForm.'
    outputs: |-
      [pscustomobject] @{ HasHead; Sections; DerivedKeys; DerivedLists; ConfigLines; Before; Rest; NewLine } — Sections are the keys directly
      under `catzc`, DerivedKeys the keys under `derived`, DerivedLists each derived list key with its items, and ConfigLines the authored
      lines under `config`, as written.
    examples:
      - Get-CodeMetaState -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')) | Select-Object -ExpandProperty DerivedKeys
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
    foreach ($key in $head.DerivedKeys) {
        $items = [string[]] @($head.DerivedList($key))
        if ($items.Count -gt 0) {
            $lists[$key] = $items
        }
    }
    [pscustomobject]@{
        HasHead      = $head.HasHead
        Sections     = [string[]] @($head.Sections)
        DerivedKeys  = [string[]] @($head.DerivedKeys)
        DerivedLists = $lists
        ConfigLines  = [string[]] @($head.ConfigLines)
        Before       = $head.Before
        Rest         = $head.Rest
        NewLine      = $head.NewLine
    }
}
