<#
.SYNOPSIS
    Prints the findings of a source check in report mode: every finding, then its count, and never a failure.
.DESCRIPTION
    Findings are a work list printed under the check's name, never passed to the gate report as issues.
    [ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-ReportModeFinding.ps1.md#comment1)
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
