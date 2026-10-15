<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-CONSOLE#7
      - ADR-AUTO-FAILFAST
      - ADR-AUTO-XPLAT#6
---
#>

<#
.SYNOPSIS
    Writes the closing verdict banner for a completed Test-Automation run — the rainbow-framed bracket that
    mirrors the scope header the run opens with.
.DESCRIPTION
    Printed on every exit path as the close of the cyan opener, so a run is always visibly bracketed.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment1)
.PARAMETER Result
    Anything but Passed or Failed is rejected at binding; the value picks the gradient anchor, green or red.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment2)
.PARAMETER Summary
    The caller builds it, so the run's existing pass and failure wording stays verbatim in the title.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment3)
.PARAMETER PassedCount
    Passed-test count, rendered on the default-coloured detail line under the title.
.PARAMETER FailedCount
    Failed-test count, rendered on the detail line.
.PARAMETER SkippedCount
    Skipped-test count, rendered on the detail line.
.PARAMETER DurationSeconds
    Wall-clock duration, rendered on the detail line.
.PARAMETER ReportPath
    Printed inside the bracket so the pointer to the full report travels with the verdict; empty prints no line.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment4)
#>
function Write-TestAutomationVerdict {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('Passed', 'Failed')]
        [string] $Result,

        [Parameter(Mandatory)]
        [string] $Summary,

        [int] $PassedCount,

        [int] $FailedCount,

        [int] $SkippedCount,

        [double] $DurationSeconds,

        [string] $ReportPath
    )

    # The gradient is reserved for this one end-of-run verdict, so it appears nowhere else in the console output.
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment5)
    $anchor = if ($Result -eq 'Passed') {
        'Green'
    }
    else {
        'Red'
    }
    $rainbow = [Catzc.Base.Writers.RainbowColor]::new([System.ConsoleColor] $anchor)

    Write-Message '' -NoHeader
    Write-Header "Test Automation $($Result.ToUpperInvariant()) — $Summary" -ForegroundColor $rainbow
    # Invariant so the duration reads the same on any devbox culture, matching the title's summary.
    # [comment:6](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment6)
    $detail = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture,
        '{0} passed · {1} skipped · {2} failed · {3:N1}s wall clock', $PassedCount, $SkippedCount, $FailedCount, $DurationSeconds)
    Write-Message $detail -NoHeader
    # The verdict is where a reader looks last, so the pointer to the full report belongs here.
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment7)
    if ($ReportPath) {
        Write-Message "Report: $ReportPath" -NoHeader
    }
    Write-Footer -ForegroundColor $rainbow
}
