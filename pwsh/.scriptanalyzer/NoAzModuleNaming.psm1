<#
---
catzc:
  immutable:
    with_body_sha: fe59d6fd84f4
  edges:
    docs: "[NoAzModuleNaming.psm1.md](docs/references/pwsh/scriptanalyzer/NoAzModuleNaming.psm1.md)"
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoAzModuleNaming {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()

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
