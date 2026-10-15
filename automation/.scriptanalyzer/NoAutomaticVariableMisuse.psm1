<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/NoAutomaticVariableMisuse.psm1
    kind: analyzer-rule
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid use of $?.
.DESCRIPTION
    $? is overwritten by every statement, making it impossible to check reliably.
    [comment:1](/docs/references/automation/scriptanalyzer/NoAutomaticVariableMisuse.psm1.md#comment1)
#>

function Measure-NoAutomaticVariableMisuse {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoAutomaticVariableMisuse'

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:2](/docs/references/automation/scriptanalyzer/NoAutomaticVariableMisuse.psm1.md#comment2)
    $isQuestionMarkVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst] -and
        $node.VariablePath.UserPath -eq '?'
    }
    $variables = $ScriptBlockAst.FindAll($isQuestionMarkVariable, $true)

    foreach ($var in $variables) {
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = 'Do not use $?. It is overwritten by every statement and cannot be checked reliably. Use -ErrorAction Stop and try/catch for cmdlets, or Assert-LastExitCodeWasZero for native commands. See ADR: automatic-variable-pitfalls.'
                Extent   = $var.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
