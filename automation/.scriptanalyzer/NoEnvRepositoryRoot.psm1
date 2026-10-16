<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/NoEnvRepositoryRoot.psm1
    kind: analyzer-rule
    language: powershell
    filetype: psm1
    track: automation
    relatives:
      page: docs/references/automation/scriptanalyzer/NoEnvRepositoryRoot.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoEnvRepositoryRoot {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $file = $ScriptBlockAst.Extent.File
    if (-not $file) {
        return @()
    }
    $normalizedPath = $file.Replace('\', '/')
    $functionFilePattern = '/automation/[^/.][^/]*/(private/)?[^/]+\.ps1$'
    if ($normalizedPath -notmatch $functionFilePattern -or $normalizedPath -match '/Get-RepositoryRoot\.ps1$') {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoEnvRepositoryRoot'

    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    foreach ($variable in $ScriptBlockAst.FindAll($isVariable, $true)) {
        $path = $variable.VariablePath
        if (-not $path.IsDriveQualified -or $path.DriveName -ne 'env' -or $path.UserPath -ne 'env:RepositoryRoot') {
            continue
        }
        # The left-hand side of an assignment writes the variable; only reads are the accessor's job.
        $parent = $variable.Parent
        if ($parent -is [System.Management.Automation.Language.AssignmentStatementAst] -and $parent.Left -eq $variable) {
            continue
        }
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = 'Read the repository root with Get-RepositoryRoot (ADR-AUTO-NOPWD#6), not $env:RepositoryRoot directly.'
                Extent   = $variable.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
