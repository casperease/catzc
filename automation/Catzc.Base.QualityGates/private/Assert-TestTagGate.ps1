<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#13
  config:
    synopsis: Fails the run when any discovered test is missing — or ambiguous on — a mandatory tag axis.
    description: |-
      Enforces the two mandatory tag axes (tier L0-L4 + category logic|integrity,
      [ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13)/15) on every
      test of the run's discovery pass. The discovery sees all tests regardless of -Level, so a missing or
      ambiguous tag fails the run even when its tier would be excluded. Each violation is listed in red before the
      throw (Get-TestTagViolations owns the rules, including the optional-tag and citation checks).
    parameters:
      Discovery: The run's discovery-only Pester result (Get-TestDiscovery).
---
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
