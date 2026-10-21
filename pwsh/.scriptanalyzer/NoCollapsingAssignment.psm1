<#
---
catzc:
  immutable:
    with_body_sha: c79ef2a4445c
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoCollapsingAssignment {
    <#
    .SYNOPSIS
        Flags a variable assigned an if, switch or try statement and later counted, where an empty or single result collapses.

    .DESCRIPTION
        A statement assigned to a variable yields its output, unwrapped: an empty branch gives $null and a one-item branch the item
        itself, so a later $variable.Count throws under strict mode on $null or reads the wrong thing on the item
        ([ADR-PWSH-ERROR-STRICTCLEAN](/docs/adr/automation/pwsh/error-handling.md#rule-adr-pwsh-error-strictclean)). The
        rule flags the assignment when the same script
        block reads .Count on that variable, the variable is not array-typed, and it is not assigned an @() anywhere else. The fix is
        `[object[]] $notes = @()` before the statement, with each branch assigning `@(...)`, or `$notes = @(if (...) { ... })`.
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

    $isCollapsingAssignment = {
        param($node)
        $node -is [System.Management.Automation.Language.AssignmentStatementAst] -and
        $node.Operator -eq [System.Management.Automation.Language.TokenKind]::Equals -and
        $node.Left -is [System.Management.Automation.Language.VariableExpressionAst] -and
        ($node.Right -is [System.Management.Automation.Language.IfStatementAst] -or
        $node.Right -is [System.Management.Automation.Language.SwitchStatementAst] -or
        $node.Right -is [System.Management.Automation.Language.TryStatementAst])
    }

    foreach ($assignment in $ScriptBlockAst.FindAll($isCollapsingAssignment, $true)) {
        $name = $assignment.Left.VariablePath.UserPath
        $isCounted = {
            param($node)
            $node -is [System.Management.Automation.Language.MemberExpressionAst] -and
            $node.Expression -is [System.Management.Automation.Language.VariableExpressionAst] -and
            $node.Expression.VariablePath.UserPath -eq $name -and
            $node.Member -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
            $node.Member.Value -eq 'Count'
        }
        $isRewrapped = {
            param($node)
            $node -is [System.Management.Automation.Language.AssignmentStatementAst] -and
            $node.Left -is [System.Management.Automation.Language.VariableExpressionAst] -and
            $node.Left.VariablePath.UserPath -eq $name -and
            $node.Right -is [System.Management.Automation.Language.CommandExpressionAst] -and
            $node.Right.Expression -is [System.Management.Automation.Language.ArrayExpressionAst]
        }
        $isArrayTyped = {
            param($node)
            $node -is [System.Management.Automation.Language.ConvertExpressionAst] -and
            $node.Child -is [System.Management.Automation.Language.VariableExpressionAst] -and
            $node.Child.VariablePath.UserPath -eq $name -and
            $node.Type.TypeName.IsArray
        }
        if ($ScriptBlockAst.Find($isCounted, $true) -and -not $ScriptBlockAst.Find($isArrayTyped, $true) -and
            -not $ScriptBlockAst.Find($isRewrapped, $true)) {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "'`$$name' is assigned an $($assignment.Right.GetType().Name -replace 'StatementAst$', '') statement and later counted; an empty or single result collapses to `$null or the item, and .Count throws under strict mode. Declare '[object[]] `$$name = @()' first and assign '@(...)' in each branch (ADR-PWSH-ERROR-STRICTCLEAN)."
                    Extent   = $assignment.Extent
                    RuleName = 'Measure-NoCollapsingAssignment'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
