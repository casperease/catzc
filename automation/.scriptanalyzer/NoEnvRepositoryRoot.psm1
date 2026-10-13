Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: module function files read the repository root through Get-RepositoryRoot.
.DESCRIPTION
    $env:RepositoryRoot is the importer's hand-off of the working-tree anchor; Get-RepositoryRoot is its one reader, so
    where the root comes from can change in one place. This rule flags every read of $env:RepositoryRoot in a module
    function file: a .ps1 file directly under automation/<Module>/ (public) or automation/<Module>/private/ (private).
    An assignment to it is not a read and is not flagged. Exempt by path, as for Measure-NoScriptRootAnchor:
    - tests/, assets/ and any other subfolder of a module;
    - dot-prefixed folders under automation/ (.internal, .scriptanalyzer, .vendor);
    - files outside automation/;
    - Get-RepositoryRoot.ps1 itself, the accessor.
    A function whose job is the variable itself carries a SuppressMessageAttribute with its justification.

    See ADR: [ADR-AUTO-NOPWD#6](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd6).
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

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
    # ([ADR-AUTO-PSFORMAT#6](/docs/adr/automation/powershell/powershell-formatting.md#rule-adr-auto-psformat6)).
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
