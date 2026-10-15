# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Fails the run when any discovered test is missing — or ambiguous on — a mandatory tag axis.
.DESCRIPTION
    Discovery ignores -Level, so a missing or ambiguous tag fails the run even for a tier that would be excluded.
    [ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Assert-TestTagGate.ps1.md#comment1)
.PARAMETER Discovery
    The run's discovery-only Pester result (Get-TestDiscovery).
#>
function Assert-TestTagGate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Discovery
    )

    $tagViolations = Get-TestTagViolations -Discovery $Discovery
    if ($tagViolations.Count -gt 0) {
        Write-Message "$($tagViolations.Count) test(s) missing a required tag (each needs exactly one tier $([Catzc.Base.Timeouts.TestTiers]::Names -join '|') + one category logic|integrity):" -ForegroundColor Red -NoHeader
        foreach ($violation in $tagViolations) {
            Write-Message "  [$($violation.Reason)] $($violation.Test)" -ForegroundColor Red -NoHeader
        }
        throw "$($tagViolations.Count) test(s) are missing a required tier/category tag — see the list above."
    }
}
