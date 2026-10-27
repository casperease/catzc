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
        if ($fn.Name -match '^\w+-Az' -and $fn.Name -notmatch '^\w+-Az(ure|Cli)') {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "Function '$($fn.Name)' uses Az PowerShell module naming (Verb-Az*). Name Azure-platform functions Verb-Azure<Noun>; the only sanctioned Az* prefix is AzCli* (az CLI wrappers)."
                    Extent   = $fn.Extent
                    RuleName = 'Measure-NoAzModuleNaming'
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
