<#
---
catzc:
  immutable:
    with_body_sha: "471e57c38fa0"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
    docs: "[Assert-TestTagGate.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Assert-TestTagGate.ps1.md)"
    cites:
      - ADR-AUTO-TEST-TWOMANDATORYTAGS
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
