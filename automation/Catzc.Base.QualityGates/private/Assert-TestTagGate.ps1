<#
.SYNOPSIS
    Fails the run when any discovered test is missing — or ambiguous on — a mandatory tag axis.
.DESCRIPTION
    Enforces the two mandatory tag axes (tier L0-L3 + category logic|integrity, ADR-AUTO-TEST:13/15) on every
    test of the run's discovery pass. The discovery sees all tests regardless of -Level, so a missing or
    ambiguous tag fails the run even when its tier would be excluded. Each violation is listed in red before the
    throw (Get-TestTagViolations owns the rules, including the optional-tag and citation checks).
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
        Write-Message "$($tagViolations.Count) test(s) missing a required tag (each needs exactly one tier L0-L3 + one category logic|integrity):" -ForegroundColor Red -NoHeader
        foreach ($violation in $tagViolations) {
            Write-Message "  [$($violation.Reason)] $($violation.Test)" -ForegroundColor Red -NoHeader
        }
        throw "$($tagViolations.Count) test(s) are missing a required tier/category tag — see the list above."
    }
}
