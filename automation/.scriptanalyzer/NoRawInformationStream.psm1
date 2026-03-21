<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid calling Write-Information directly.
.DESCRIPTION
    Console/log output must go through the repo's writers, which all route through the single chokepoint
    Write-InformationColored — and that chokepoint is where output is SUPPRESSED during a Pester run (the
    $global:__PesterRunning guard returns before writing). A direct Write-Information call skips that guard, so
    its output LEAKS into test output: Pester captures the information stream regardless of $InformationPreference
    and replays it. It also skips the caller-identity header Write-Message adds (useful in local and CI logs).

    Use Write-Message for any message from the automation to the console/log — it carries the [caller] header
    (drop it with -NoHeader) and supports -ForegroundColor, and it is guarded. Write-InformationColored is the
    low-level chokepoint Write-Message builds on; it is the one place Write-Information may be called, so a
    Write-Information inside the function Write-InformationColored is exempt.

    See ADR: docs/adr/automation/test-automation.md (the Pester-suppression chokepoint).
#>

function Measure-NoRawInformationStream {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # PSScriptAnalyzer invokes custom rules for every ScriptBlockAst in the parse tree; FindAll recurses, so
    # only process the root to avoid duplicate diagnostics.
    if ($ScriptBlockAst.Parent) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawInformationStream'
    $exemptFunction = 'Write-InformationColored'

    # Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew (ADR-PSFORMAT:6).
    $isCommand = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst]
    }
    $commands = $ScriptBlockAst.FindAll($isCommand, $true)

    foreach ($cmd in $commands) {
        if ($cmd.GetCommandName() -ne 'Write-Information') {
            continue
        }

        # Exempt the one sanctioned caller — the chokepoint wrapper itself.
        $insideExempt = $false
        $parent = $cmd.Parent
        while ($null -ne $parent) {
            if ($parent -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                $parent.Name -eq $exemptFunction) {
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
