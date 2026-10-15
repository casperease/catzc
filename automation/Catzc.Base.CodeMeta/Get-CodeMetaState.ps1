<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Get-CodeMetaState.ps1
    kind: function
    module: Catzc.Base.CodeMeta
    visibility: public
    adrs:
      - ADR-REPO-CODEMETA#1
---
#>

<#
.SYNOPSIS
    Reads what a code text says about its own meta head, without changing it.
.DESCRIPTION
    Pure: it takes the text and the head's comment syntax, reads no file and no config.
    [ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1)
    [comment:1](/docs/references/automation/catzc-base-codemeta/Get-CodeMetaState.ps1.md#comment1)
.PARAMETER Text
    The whole code file as text.
.PARAMETER Form
    The head's comment syntax: a Catzc.Base.CodeMeta.HeadForm.
.OUTPUTS
    [pscustomobject] @{ HasHead; Sections; DerivedKeys; ConfigLines; Before; Rest; NewLine } — Sections are the keys directly under `catzc`,
    DerivedKeys the keys under `derived`, and ConfigLines the authored lines under `config`, as written.
.EXAMPLE
    Get-CodeMetaState -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')) | Select-Object -ExpandProperty DerivedKeys
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
    [pscustomobject]@{
        HasHead     = $head.HasHead
        Sections    = [string[]] @($head.Sections)
        DerivedKeys = [string[]] @($head.DerivedKeys)
        ConfigLines = [string[]] @($head.ConfigLines)
        Before      = $head.Before
        Rest        = $head.Rest
        NewLine     = $head.NewLine
    }
}
