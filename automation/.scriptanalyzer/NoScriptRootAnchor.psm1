Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid $PSScriptRoot anchors in module function files.
.DESCRIPTION
    A module's code runs in two modes: source mode, loading each function file from automation/<Module>/, and
    build mode, loading the module's functions merged into one file inside a built package. $PSScriptRoot names
    the folder of the file that is running, so in source mode a lookup like Join-Path $PSScriptRoot 'assets/x'
    happens to find the module folder, while in build mode it points somewhere else and the lookup breaks.
    Module-internal content (configs/, assets/, another module's files) is located only through
    Get-CatzcModuleRoot -ChildPath '<literal>' (or Get-CatzcModulesRoot for the dot-prefixed infrastructure).

    This rule flags every $PSScriptRoot reference in a module function file: a .ps1 file directly under
    automation/<Module>/ (public) or automation/<Module>/private/ (private). Everything else is exempt by path:
    - tests/, assets/ and any other subfolder of a module (only the module root and private/ are function files);
    - dot-prefixed folders under automation/ (.internal, .scriptanalyzer, .vendor) — the infrastructure that
      anchors the modules root itself;
    - files outside automation/ (repository-root scripts, infrastructure/).
    A script analysed without a file path (Invoke-ScriptAnalyzer -ScriptDefinition) has no location and is not
    flagged.

    See ADR: [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1).
#>

function Measure-NoScriptRootAnchor {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # Only module function files are in scope: automation/<Module>/<File>.ps1 or automation/<Module>/private/<File>.ps1,
    # where <Module> is not dot-prefixed (.internal, .scriptanalyzer, .vendor are infrastructure).
    $file = $ScriptBlockAst.Extent.File
    if (-not $file) {
        return @()
    }
    $normalizedPath = $file.Replace('\', '/')
    $functionFilePattern = '/automation/[^/.][^/]*/(private/)?[^/]+\.ps1$'
    if ($normalizedPath -notmatch $functionFilePattern) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoScriptRootAnchor'

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
    # ([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
    $isVariable = {
        param($node)
        $node -is [System.Management.Automation.Language.VariableExpressionAst]
    }
    $variables = $ScriptBlockAst.FindAll($isVariable, $true)

    foreach ($variable in $variables) {
        if ($variable.VariablePath.UserPath -ne 'PSScriptRoot') {
            continue
        }
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "Locate module-internal content with Get-CatzcModuleRoot -ChildPath '<literal>' (ADR-AUTO-ASSETDEP:1); `$PSScriptRoot does not point at the module folder in build mode."
                Extent   = $variable.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
