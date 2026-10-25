<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Assert-TestTagGate.ps1.md"
  warning: "Generated Header"
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
            # The file is named on the line, so the test is found without a search.
            $file = if ($violation.File) {
                " in $($violation.File)"
            }
            else {
                ''
            }
            Write-Message "  [$($violation.Reason)] $($violation.Test)$file" -ForegroundColor Red -NoHeader
        }
        throw "$($tagViolations.Count) test(s) are missing a required tier/category tag — see the list above."
    }
}
