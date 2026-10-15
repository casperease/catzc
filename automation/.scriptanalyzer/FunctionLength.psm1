<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/FunctionLength.psm1
    kind: analyzer-rule
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: function body must not exceed 300 lines.
.DESCRIPTION
    Help placed before the function is outside the braces, so it never counts toward the limit.
    [comment:1](/docs/references/automation/scriptanalyzer/FunctionLength.psm1.md#comment1)
#>

function Measure-FunctionLength {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $maxLines = 300
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-FunctionLength'

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:2](/docs/references/automation/scriptanalyzer/FunctionLength.psm1.md#comment2)
    $isFunctionDefinition = {
        param($node)
        $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
    }
    # Every function defined at the top level of a script block (the file's or another function's body), at any depth.
    $functions = $ScriptBlockAst.FindAll($isFunctionDefinition, $true) |
        Where-Object { $_.Parent.Parent -is [System.Management.Automation.Language.ScriptBlockAst] }

    foreach ($fn in $functions) {
        $bodyLines = $fn.Body.Extent.EndLineNumber - $fn.Body.Extent.StartLineNumber + 1

        if ($bodyLines -gt $maxLines) {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Function '$($fn.Name)' body is $bodyLines lines (max $maxLines). Consider breaking it up."
                    Extent   = $fn.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
