<#
.SYNOPSIS
    Reads what a code text says about its own meta head, without changing it
    ([ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1)).
.DESCRIPTION
    Pure: it takes the text and the head's comment syntax, reads no file and no config.
.PARAMETER Text
    The whole code file as text.
.PARAMETER Form
    The head's comment syntax: a Catzc.Base.CodeMeta.HeadForm.
.OUTPUTS
    [pscustomobject] @{ HasHead; Keys; Facts; Before; Rest; NewLine } — Facts is an ordered dictionary of key to value.
.EXAMPLE
    Get-CodeMetaState -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForLine('#')) | Select-Object -ExpandProperty Keys
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
    $facts = [ordered]@{}
    foreach ($fact in $head.Facts) {
        $facts[$fact.Key] = $fact.Value
    }
    [pscustomobject]@{
        HasHead = $head.HasHead
        Keys    = [string[]] @($facts.Keys)
        Facts   = $facts
        Before  = $head.Before
        Rest    = $head.Rest
        NewLine = $head.NewLine
    }
}
