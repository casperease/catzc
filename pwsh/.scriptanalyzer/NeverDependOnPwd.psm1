<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/.scriptanalyzer/NeverDependOnPwd.psm1
    folder: pwsh/.scriptanalyzer
    name: never-depend-on-pwd
    filetype: psm1
    role: analyzer-rule
    language: powershell
    track: pwsh
    tracktype: modules
  edges:
    docs: "[NeverDependOnPwd.psm1.md](docs/references/pwsh/scriptanalyzer/NeverDependOnPwd.psm1.md)"
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

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
