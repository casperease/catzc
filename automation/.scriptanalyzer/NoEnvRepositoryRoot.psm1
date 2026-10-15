Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: module function files read the repository root through Get-RepositoryRoot.
.DESCRIPTION
    One accessor reads the root, so where the root comes from can change in one place; a write is not flagged.
    [ADR-AUTO-NOPWD#6](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd6)
    [comment:1](/docs/references/automation/scriptanalyzer/NoEnvRepositoryRoot.psm1.md#comment1)
#>

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

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)
    # [comment:2](/docs/references/automation/scriptanalyzer/NoEnvRepositoryRoot.psm1.md#comment2)
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
