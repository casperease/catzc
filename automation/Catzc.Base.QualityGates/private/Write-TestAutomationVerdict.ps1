<#
.SYNOPSIS
    Writes the closing verdict banner for a completed Test-Automation run — the rainbow-framed bracket that
    mirrors the scope header the run opens with.
.DESCRIPTION
    Renders one end-of-run banner and nothing else: a Write-Header whose rule lines carry a per-character gradient...
    [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment1)
.PARAMETER Result
    The aggregate run verdict — the primary argument (Position 0).
    [ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment2)
.PARAMETER Summary
    The one-line reason shown in the banner title (e.g.
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
    The run's report directory.
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

    # Green-rainbow celebrates a pass, red-rainbow marks a fail — the gradient lives in this one end-of-run verdict...
    # [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
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
    # [ADR-AUTO-XPLAT#6](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat6)
    # [comment:6](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment6)
    $detail = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture,
        '{0} passed · {1} skipped · {2} failed · {3:N1}s wall clock', $PassedCount, $SkippedCount, $FailedCount, $DurationSeconds)
    Write-Message $detail -NoHeader
    # The report pointer rides inside the bracket, on its own default-coloured line — the verdict is where a reader...
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md#comment7)
    if ($ReportPath) {
        Write-Message "Report: $ReportPath" -NoHeader
    }
    Write-Footer -ForegroundColor $rainbow
}
