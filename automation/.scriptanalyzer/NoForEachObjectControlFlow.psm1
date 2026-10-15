<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/NoForEachObjectControlFlow.psm1
    kind: analyzer-rule
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid return, break, continue inside ForEach-Object.
.DESCRIPTION
    Inside a ForEach-Object scriptblock return acts like continue and break ends the script, unlike in a foreach loop.
    [comment:1](/docs/references/automation/scriptanalyzer/NoForEachObjectControlFlow.psm1.md#comment1)
#>

function Measure-NoForEachObjectControlFlow {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoForEachObjectControlFlow'

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:2](/docs/references/automation/scriptanalyzer/NoForEachObjectControlFlow.psm1.md#comment2)
    $isForEachObjectCommand = {
        param($node)
        if ($node -isnot [System.Management.Automation.Language.CommandAst]) {
            return $false
        }
        $name = $node.GetCommandName()
        return ($name -eq 'ForEach-Object' -or $name -eq '%')
    }
    $commands = $ScriptBlockAst.FindAll($isForEachObjectCommand, $true)

    foreach ($cmd in $commands) {
        # Positional scriptblocks count as well as -Process, -Begin and -End.
        # [comment:3](/docs/references/automation/scriptanalyzer/NoForEachObjectControlFlow.psm1.md#comment3)
        $scriptBlocks = @()
        foreach ($element in $cmd.CommandElements) {
            if ($element -is [System.Management.Automation.Language.ScriptBlockExpressionAst]) {
                $scriptBlocks += $element.ScriptBlock
            }
        }

        foreach ($block in $scriptBlocks) {
            # Only direct children count: inside a nested loop, switch or function the keyword is valid.
            # [comment:4](/docs/references/automation/scriptanalyzer/NoForEachObjectControlFlow.psm1.md#comment4)
            $isControlFlowStatement = {
                param($node)

                # Match return, break, continue statements
                $isTarget = (
                    $node -is [System.Management.Automation.Language.ReturnStatementAst] -or
                    $node -is [System.Management.Automation.Language.BreakStatementAst] -or
                    $node -is [System.Management.Automation.Language.ContinueStatementAst]
                )
                if (-not $isTarget) {
                    return $false
                }

                # An intervening loop, switch or function owns the keyword, so it does not target our scriptblock.
                # [comment:5](/docs/references/automation/scriptanalyzer/NoForEachObjectControlFlow.psm1.md#comment5)
                $parent = $node.Parent
                while ($null -ne $parent -and $parent -ne $block) {
                    # foreach/for/while/do loops — return/break/continue are valid here
                    if ($parent -is [System.Management.Automation.Language.ForEachStatementAst] -or
                        $parent -is [System.Management.Automation.Language.ForStatementAst] -or
                        $parent -is [System.Management.Automation.Language.WhileStatementAst] -or
                        $parent -is [System.Management.Automation.Language.DoWhileStatementAst] -or
                        $parent -is [System.Management.Automation.Language.DoUntilStatementAst]) {
                        return $false
                    }
                    # switch — break is valid here
                    if ($parent -is [System.Management.Automation.Language.SwitchStatementAst] -and
                        $node -is [System.Management.Automation.Language.BreakStatementAst]) {
                        return $false
                    }
                    # Nested function or scriptblock — keywords target that scope, not ours
                    if ($parent -is [System.Management.Automation.Language.FunctionDefinitionAst] -or
                        $parent -is [System.Management.Automation.Language.ScriptBlockExpressionAst]) {
                        return $false
                    }
                    $parent = $parent.Parent
                }

                return $true
            }
            $statements = $block.FindAll($isControlFlowStatement, $true)

            foreach ($stmt in $statements) {
                $keyword = if ($stmt -is [System.Management.Automation.Language.ReturnStatementAst]) {
                    'return'
                }
                elseif ($stmt -is [System.Management.Automation.Language.BreakStatementAst]) {
                    'break'
                }
                else {
                    'continue'
                }

                $message = switch ($keyword) {
                    'return' {
                        "Do not use 'return' inside ForEach-Object. It exits only the current scriptblock iteration (like 'continue' in a loop), not the enclosing function. Use a foreach statement instead. See ADR: prefer-foreach-over-foreach-object."
                    }
                    'break' {
                        "Do not use 'break' inside ForEach-Object. It does not break the pipeline — it breaks the nearest enclosing loop or terminates the script. Use a foreach statement instead. See ADR: prefer-foreach-over-foreach-object."
                    }
                    'continue' {
                        "Do not use 'continue' inside ForEach-Object. It does not skip to the next pipeline item — it acts on the nearest enclosing loop or terminates the script. Use a foreach statement instead. See ADR: prefer-foreach-over-foreach-object."
                    }
                }

                $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                        Message  = $message
                        Extent   = $stmt.Extent
                        RuleName = $ruleName
                        Severity = 'Error'
                    })
            }
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
