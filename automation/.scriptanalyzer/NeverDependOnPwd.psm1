<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: never depend on $PWD.
.DESCRIPTION
    Flags:
    - References to $PWD (use $PSScriptRoot or $env:RepositoryRoot instead)
    - Bare Set-Location / cd calls (use Push-Location / Pop-Location instead)
    See docs/adr/automation/never-depend-on-pwd.md#rule-adr-nopwd1 and
    docs/adr/automation/powershell/working-directory-mechanics.md#rule-adr-pspwd2
#>

function Measure-NeverDependOnPwd {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # Only run on the root script block — skip nested invocations for function bodies
    if ($ScriptBlockAst.Parent -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NeverDependOnPwd'

    # Flag $PWD references
    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew (ADR-PSFORMAT:6).
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

    # Flag Set-Location / cd calls (Push-Location / Pop-Location are fine)
    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew (ADR-PSFORMAT:6).
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
