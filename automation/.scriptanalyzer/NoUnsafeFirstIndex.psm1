Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid taking the first element of a collected result by index.
.DESCRIPTION
    `@(<pipeline or call>)[0]` and `(<a | b>)[0]` read the first element of a result that may be empty. Under strict
    mode an index past the end throws ("Index was outside the bounds of the array"), so an empty result never
    reaches the `$null` check or assert written right after it — the caller gets an engine error instead of the
    intended message. `<result> | Select-Object -First 1` is `$null` on an empty result and the same element
    otherwise. See [ADR-PWSH-ERROR#8](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error8).

    Flagged: index `[0]` whose target is an array subexpression `@(…)`, or a parenthesised pipeline of two or
    more elements. Not flagged: an index on a variable or member (`$list[0]`, `$Matches[0]`), whose length the
    surrounding code owns, and `(… -split …)[0]`, which always yields at least one element.
#>

function Measure-NoUnsafeFirstIndex {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
    # ([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
    $isFirstIndex = {
        param($node)
        $node -is [System.Management.Automation.Language.IndexExpressionAst] -and
        $node.Index -is [System.Management.Automation.Language.ConstantExpressionAst] -and
        "$($node.Index.Value)" -eq '0'
    }

    # -split always yields at least one element, so its first element always exists.
    $isSplit = {
        param($node)
        $node -is [System.Management.Automation.Language.BinaryExpressionAst] -and
        $node.Operator -in @(
            [System.Management.Automation.Language.TokenKind]::Isplit
            [System.Management.Automation.Language.TokenKind]::Csplit
        )
    }

    foreach ($index in $ScriptBlockAst.FindAll($isFirstIndex, $true)) {
        $target = $index.Target
        $collected = $target -is [System.Management.Automation.Language.ArrayExpressionAst] -or
        ($target -is [System.Management.Automation.Language.ParenExpressionAst] -and
        $target.Pipeline -is [System.Management.Automation.Language.PipelineAst] -and
        $target.Pipeline.PipelineElements.Count -gt 1)
        $splitOnly = $target -is [System.Management.Automation.Language.ArrayExpressionAst] -and
        @($target.SubExpression.Statements).Count -eq 1 -and
        $null -ne $target.SubExpression.Find($isSplit, $false)
        if ($collected -and -not $splitOnly) {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "'$($index.Extent.Text)' indexes the first element of a result that may be empty — under strict mode that throws before any `$null check runs. Use '<result> | Select-Object -First 1' (ADR-PWSH-ERROR#8)."
                    Extent   = $index.Extent
                    RuleName = 'Measure-NoUnsafeFirstIndex'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
