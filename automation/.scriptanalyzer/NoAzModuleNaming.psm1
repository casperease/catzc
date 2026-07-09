<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid Az PowerShell module naming.
.DESCRIPTION
    Functions must not use the Verb-Az<Noun> naming pattern of the Az PowerShell
    modules (Get-AzResource, New-AzVM, …). Name Azure-platform functions
    Verb-Azure<Noun> — Azure spelled out, so it cannot collide with Az.* cmdlets.

    The only sanctioned Az* prefixes are Verb-AzCli* (az CLI wrappers, e.g.
    Invoke-AzCli, Assert-AzCliIsConnected) and Verb-AzBicep* (az bicep checks).
    Both cover the az CLI itself, not the Az PowerShell modules — see the ADR to
    prefer Az CLI over Az PowerShell modules.
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

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew (ADR-AUTO-PSFORMAT:6).
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
