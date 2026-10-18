<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
    folder: private
    name: assert-test-tag-gate
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
    cites:
      - ADR-AUTO-TEST#13
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
