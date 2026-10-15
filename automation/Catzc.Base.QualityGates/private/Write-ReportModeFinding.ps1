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
---
#>

<#
.SYNOPSIS
    Prints the findings of a source check in report mode: every finding, then its count, and never a failure.
.DESCRIPTION
    Findings are a work list printed under the check's name, never passed to the gate report as issues.
.PARAMETER Check
    The check's name as its config spells it ('string_citations', 'engine_set').
.PARAMETER Finding
    The check's findings, one '<file>:<line>…' line each.
.EXAMPLE
    Write-ReportModeFinding -Check engine_set -Finding $engineSetFindings
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
