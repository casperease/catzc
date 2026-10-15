<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/NoScriptRootAnchor.psm1
    kind: other
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid $PSScriptRoot anchors in module function files.
.DESCRIPTION
    In build mode the functions merge into one file, so the script root no longer names the module folder.
    [comment:1](/docs/references/automation/scriptanalyzer/NoScriptRootAnchor.psm1.md#comment1)
#>

function Measure-NoScriptRootAnchor {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # Dot-prefixed modules are infrastructure that anchors the modules root itself, so they are out of scope.
    # [comment:2](/docs/references/automation/scriptanalyzer/NoScriptRootAnchor.psm1.md#comment2)
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

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:3](/docs/references/automation/scriptanalyzer/NoScriptRootAnchor.psm1.md#comment3)
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
                Message  = "Locate module-internal content with Get-CatzcModuleRoot -ChildPath '<literal>' (ADR-AUTO-ASSETDEP#1); `$PSScriptRoot does not point at the module folder in build mode."
                Extent   = $variable.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
