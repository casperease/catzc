<#
---
catzc:
  immutable:
    with_body_sha: e676b81803ed
  edges:
    docs: "[NoUnsafeFirstIndex.psm1.md](docs/references/pwsh/scriptanalyzer/NoUnsafeFirstIndex.psm1.md)"
    cites:
      - ADR-PWSH-ERROR-STRICTCLEAN
      - ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoUnsafeFirstIndex {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

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
                    Message  = "'$($index.Extent.Text)' indexes the first element of a result that may be empty — under strict mode that throws before any `$null check runs. Use '<result> | Select-Object -First 1' (ADR-PWSH-ERROR-STRICTCLEAN)."
                    Extent   = $index.Extent
                    RuleName = 'Measure-NoUnsafeFirstIndex'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
