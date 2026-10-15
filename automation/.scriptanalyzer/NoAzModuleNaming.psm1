<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/NoAzModuleNaming.psm1
    kind: other
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid Az PowerShell module naming.
.DESCRIPTION
    Azure is spelled out in full so a function name never collides with a cmdlet of the Az modules.
    [comment:1](/docs/references/automation/scriptanalyzer/NoAzModuleNaming.psm1.md#comment1)
#>

function Measure-NoAzModuleNaming {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:2](/docs/references/automation/scriptanalyzer/NoAzModuleNaming.psm1.md#comment2)
    $isFunctionDefinition = {
        param($node)
        $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
    }
    $functions = $ScriptBlockAst.FindAll($isFunctionDefinition, $true)

    foreach ($fn in $functions) {
        if ($fn.Name -match '^\w+-Az' -and $fn.Name -notmatch '^\w+-Az(ure|Cli|Bicep)') {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Function '$($fn.Name)' uses Az PowerShell module naming (Verb-Az*). Name Azure-platform functions Verb-Azure<Noun>; the only sanctioned Az* prefixes are AzCli* (az CLI wrappers) and AzBicep* (az bicep checks)."
                    Extent   = $fn.Extent
                    RuleName = 'Measure-NoAzModuleNaming'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
