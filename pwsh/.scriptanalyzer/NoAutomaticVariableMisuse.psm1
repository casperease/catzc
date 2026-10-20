<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/.scriptanalyzer/NoAutomaticVariableMisuse.psm1
    folder: pwsh/.scriptanalyzer
    name: no-automatic-variable-misuse
    filetype: psm1
    role: analyzer-rule
    language: powershell
    track: pwsh
    tracktype: modules
  edges:
    docs: "[NoAutomaticVariableMisuse.psm1.md](docs/references/pwsh/scriptanalyzer/NoAutomaticVariableMisuse.psm1.md)"
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

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
