<#
---
catzc:
  immutable:
    with_body_sha: "875baba350eb"
  edges:
    cites:
      - ADR-PWSH-FORMAT-MULTILINECONDITIONALHASHTABLE
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoOneLineHashtableIfElse {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

    $isOneLineHashtable = {
        param($node)
        $node -is [System.Management.Automation.Language.HashtableAst] -and
        $node.Extent.StartLineNumber -eq $node.Extent.EndLineNumber
    }
    $isIfElse = {
        param($node)
        $node -is [System.Management.Automation.Language.IfStatementAst] -and
        $null -ne $node.ElseClause
    }

    $flagged = [System.Collections.Generic.List[System.Management.Automation.Language.Ast]]::new()
    foreach ($hashtable in $ScriptBlockAst.FindAll($isOneLineHashtable, $true)) {
        if ($null -eq $hashtable.Find($isIfElse, $true)) {
            continue
        }
        # An outer one-line hashtable already covers the one inside it: report the outermost only.
        $covered = $false
        foreach ($outer in $flagged) {
            if ($outer.Extent.StartOffset -le $hashtable.Extent.StartOffset -and $outer.Extent.EndOffset -ge $hashtable.Extent.EndOffset) {
                $covered = $true
            }
        }
        if (-not $covered) {
            $flagged.Add($hashtable)
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "'$($hashtable.Extent.Text)' holds an if/else inside a hashtable written on one line — Invoke-Formatter throws on it and stops Format-Code for the whole tree. Bind the value to a local first (ADR-PWSH-FORMAT-MULTILINECONDITIONALHASHTABLE)."
                    Extent   = $hashtable.Extent
                    RuleName = 'Measure-NoOneLineHashtableIfElse'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
