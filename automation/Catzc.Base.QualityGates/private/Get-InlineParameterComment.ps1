<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-InlineParameterComment.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-HELP#3
---
#>

<#
.SYNOPSIS
    Lists the comment lines written directly above each parameter of a function, with the text range they occupy.
.DESCRIPTION
    A trailing comment after code is not one: only a comment alone on its line, in an unbroken run that ends on the...
    [ADR-REPO-HELP#3](/docs/adr/repository/function-help.md#rule-adr-repo-help3)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-InlineParameterComment.ps1.md#comment1)
.PARAMETER Text
    The file text, with LF line endings.
.PARAMETER ParamBlock
    The parsed param block of the function.
.PARAMETER Token
    The tokens of the same parse.
.OUTPUTS
    [pscustomobject[]] @{ Name; Text; Start; End } per parameter that has such a run: the comment text joined on single spaces, and the
    offsets of the lines to remove, newline included.
#>
function Get-InlineParameterComment {
    [CmdletBinding()]
    [OutputType([pscustomobject[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Text,

        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ParamBlockAst] $ParamBlock,

        [Parameter(Mandatory)]
        [System.Management.Automation.Language.Token[]] $Token
    )

    $comments = @($Token | Where-Object {
            $_.Kind -eq [System.Management.Automation.Language.TokenKind]::Comment -and
            -not $_.Text.StartsWith('<#', [System.StringComparison]::Ordinal) -and
            $_.Extent.StartOffset -gt $ParamBlock.Extent.StartOffset -and
            $_.Extent.EndOffset -lt $ParamBlock.Extent.EndOffset
        })

    foreach ($parameter in $ParamBlock.Parameters) {
        $chain = [System.Collections.Generic.List[object]]::new()
        $wanted = $parameter.Extent.StartLineNumber - 1
        $above = @($comments | Where-Object { $_.Extent.EndOffset -le $parameter.Extent.StartOffset } | Sort-Object { $_.Extent.StartOffset } -Descending)
        foreach ($comment in $above) {
            $lineStart = $Text.LastIndexOf("`n", [Math]::Max(0, $comment.Extent.StartOffset - 1), [System.StringComparison]::Ordinal) + 1
            $alone = [string]::IsNullOrWhiteSpace($Text.Substring($lineStart, $comment.Extent.StartOffset - $lineStart))
            if ($alone -and $comment.Extent.EndLineNumber -eq $wanted) {
                $chain.Insert(0, $comment)
                $wanted = $comment.Extent.StartLineNumber - 1
            }
            else {
                break
            }
        }
        if ($chain.Count -eq 0) {
            continue
        }

        $first = $chain[0].Extent.StartOffset
        $start = $Text.LastIndexOf("`n", [Math]::Max(0, $first - 1), [System.StringComparison]::Ordinal) + 1
        $lastEnd = $chain[$chain.Count - 1].Extent.EndOffset
        $newline = $Text.IndexOf("`n", $lastEnd, [System.StringComparison]::Ordinal)
        [pscustomobject]@{
            Name  = $parameter.Name.VariablePath.UserPath
            Text  = (@($chain | ForEach-Object { $_.Text.TrimStart('#').Trim() }) -join ' ').Trim()
            Start = $start
            End   = $newline + 1
        }
    }
}
