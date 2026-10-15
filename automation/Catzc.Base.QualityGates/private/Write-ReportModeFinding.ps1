<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-ReportModeFinding.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PRIN-CONFIG#4
  config:
    synopsis: 'Prints the findings of a source check in report mode: every finding, then its count, and never a failure.'
    description: |-
      The one way a gate shows a check whose config sets mode: report (Catzc.Base.QualityGates.SourceCheck,
      [ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)): the check's findings
      are its work list, printed with the check's name so a reader can tell them from the gate's issues, and they are
      never passed to Write-QualityGateReport as issues. Nothing is printed when the check found nothing.
    parameters:
      Check: The check's name as its config spells it ('string_citations', 'engine_set').
      Finding: The check's findings, one '<file>:<line>…' line each.
    examples:
      - Write-ReportModeFinding -Check engine_set -Finding $engineSetFindings
---
#>

function Write-ReportModeFinding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Check,

        [AllowEmptyCollection()]
        [string[]] $Finding = @()
    )

    if ($Finding.Count -eq 0) {
        return
    }
    foreach ($line in $Finding) {
        Write-Message "[$Check] $line" -NoHeader
    }
    Write-Message "$($Finding.Count) $Check finding(s) in report mode: listed, not failing the run (mode: report)." -ForegroundColor Yellow
}
