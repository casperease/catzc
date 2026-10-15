<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/FunctionLength.psm1
    kind: analyzer-rule
    relatives:
      page: docs/references/automation/scriptanalyzer/FunctionLength.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

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
