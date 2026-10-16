<#
---
catzc:
  immutable:
    path: automation/.scriptanalyzer/NoWriteErrorOrWarning.psm1
    folder: automation/.scriptanalyzer
    name: no-write-error-or-warning
    filetype: psm1
    kind: analyzer-rule
    language: powershell
    track: automation
    tracktype: modules
  edges:
    page: docs/references/automation/scriptanalyzer/NoWriteErrorOrWarning.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoWriteErrorOrWarning {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoWriteErrorOrWarning'

    $isCommand = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst]
    }
    $commands = $ScriptBlockAst.FindAll($isCommand, $true)

    foreach ($cmd in $commands) {
        $name = $cmd.GetCommandName()
        if ($name -eq 'Write-Error') {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Do not use Write-Error. Use 'throw' or an Assert-* function instead."
                    Extent   = $cmd.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
        elseif ($name -eq 'Write-Warning') {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Do not use Write-Warning. Use 'throw' if something is wrong, or Write-Message if it is informational."
                    Extent   = $cmd.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
