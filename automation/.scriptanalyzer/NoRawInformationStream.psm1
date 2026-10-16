<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/NoRawInformationStream.psm1
    folder: automation/.scriptanalyzer
    name: no-raw-information-stream
    filetype: psm1
    kind: analyzer-rule
    language: powershell
    track: automation
    relatives:
      page: docs/references/automation/scriptanalyzer/NoRawInformationStream.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

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
