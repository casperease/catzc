Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid calling Write-Information directly.
.DESCRIPTION
    Console/log output must go through the repo's writers, which all route through the single chokepoint...
    [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md)
    [comment:1](/docs/references/automation/scriptanalyzer/NoRawInformationStream.psm1.md#comment1)
#>

function Measure-NoRawInformationStream {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawInformationStream'
    $exemptFunctions = @('Write-InformationColored', 'Write-ImporterMessage')

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)
    # [comment:2](/docs/references/automation/scriptanalyzer/NoRawInformationStream.psm1.md#comment2)
    $isCommand = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst]
    }
    $commands = $ScriptBlockAst.FindAll($isCommand, $true)

    foreach ($cmd in $commands) {
        if ($cmd.GetCommandName() -ne 'Write-Information') {
            continue
        }

        # Exempt the two sanctioned callers — the chokepoint wrappers themselves.
        $insideExempt = $false
        $parent = $cmd.Parent
        while ($null -ne $parent) {
            if ($parent -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                $parent.Name -in $exemptFunctions) {
                $insideExempt = $true
                break
            }
            $parent = $parent.Parent
        }
        if ($insideExempt) {
            continue
        }

        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "Do not call Write-Information directly — it bypasses the Write-InformationColored chokepoint that silences output during Pester runs, so it leaks into test output, and it skips Write-Message's caller header. Use Write-Message (with -NoHeader / -ForegroundColor as needed) for any console/log message."
                Extent   = $cmd.Extent
                RuleName = $ruleName
                Severity = 'Warning'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
