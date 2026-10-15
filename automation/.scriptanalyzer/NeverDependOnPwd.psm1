<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/NeverDependOnPwd.psm1
    kind: analyzer-rule
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: never depend on $PWD.
.DESCRIPTION
    Push-Location and Pop-Location pass: they restore the caller's directory, a bare Set-Location does not.
    [comment:1](/docs/references/automation/scriptanalyzer/NeverDependOnPwd.psm1.md#comment1)
#>

function Measure-NeverDependOnPwd {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NeverDependOnPwd'

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:2](/docs/references/automation/scriptanalyzer/NeverDependOnPwd.psm1.md#comment2)
    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    $variables = $ScriptBlockAst.FindAll($isVariable, $true)

    foreach ($var in $variables) {
        if ($var.VariablePath.UserPath -eq 'PWD') {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = 'Avoid $PWD — use $PSScriptRoot, $env:RepositoryRoot, or Join-Path from a known anchor.'
                    Extent   = $var.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:3](/docs/references/automation/scriptanalyzer/NeverDependOnPwd.psm1.md#comment3)
    $isCommand = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst]
    }
    $commands = $ScriptBlockAst.FindAll($isCommand, $true)

    foreach ($cmd in $commands) {
        $name = $cmd.GetCommandName()
        if ($name -in 'Set-Location', 'cd', 'sl', 'chdir') {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Avoid bare '$name' — use Push-Location / Pop-Location in a try/finally block instead."
                    Extent   = $cmd.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
