<#
.SYNOPSIS
    Writes the closing verdict banner for a completed Test-Automation run — the rainbow-framed bracket that
    mirrors the opening scope header.
.DESCRIPTION
    Renders one end-of-run banner and nothing else: a Write-Header whose rule lines carry a per-character
    gradient (green-rainbow on a passing run, red-rainbow on a failing one, ADR-CONSOLE:7) while its titled line
    keeps the anchor's solid base colour, a default-coloured counts detail line (the banner rule carries the
    signal; the counts are data), and a Write-Footer closing the same gradient. It is the symmetric close to
    Write-TestAutomationHeader's cyan opener, printed on every exit path so a run is always visually bracketed.
    Every line routes through the shared Write-InformationColored chokepoint, so it stays silent under the Pester
    harness ($global:__PesterRunning) with no per-function plumbing.
.PARAMETER Result
    The aggregate run verdict — the primary argument (Position 0). A ValidateSet, so a value other than 'Passed'
    or 'Failed' is rejected at binding (fail-fast, ADR-FAILFAST). It selects the gradient anchor: green for a
    pass, red for a fail.
.PARAMETER Summary
    The one-line reason shown in the banner title (e.g. '812 passed, 14 skipped in 42.3s', or '3 test(s)
    failed') — the caller builds it, so the run's existing pass/failure wording is preserved verbatim.
.PARAMETER PassedCount
    Passed-test count, rendered on the default-coloured detail line under the title.
.PARAMETER FailedCount
    Failed-test count, rendered on the detail line.
.PARAMETER SkippedCount
    Skipped-test count, rendered on the detail line.
.PARAMETER DurationSeconds
    Wall-clock duration, rendered on the detail line.
.PARAMETER ReportPath
    The run's report directory. Rendered on its own line inside the closing bracket so the "where do I look"
    pointer travels with the verdict itself rather than adrift in earlier output. Omitted (empty) prints no line.
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

    # Green-rainbow celebrates a pass, red-rainbow marks a fail — the gradient lives in this one end-of-run
    # verdict and nowhere else (ADR-CONSOLE:7 "sparingly"). The rule lines take the per-character walk; the
    # title keeps the anchor's solid base colour (the profile side-grades to Base on the titled line).
    $anchor = if ($Result -eq 'Passed') {
        'Green'
    }
    else {
        'Red'
    }
    $rainbow = [Catzc.Base.Writers.RainbowColor]::new([System.ConsoleColor] $anchor)

    Write-Message '' -NoHeader
    Write-Header "Test Automation $($Result.ToUpperInvariant()) — $Summary" -ForegroundColor $rainbow
    # Invariant so the duration reads the same on any devbox culture (ADR-XPLAT:6), matching the title's summary.
    $detail = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture,
        '{0} passed · {1} skipped · {2} failed · {3:N1}s wall clock', $PassedCount, $SkippedCount, $FailedCount, $DurationSeconds)
    Write-Message $detail -NoHeader
    # The report pointer rides inside the bracket, on its own default-coloured line — the verdict is where a
    # reader looks last, so it is where "and here is the full report" belongs.
    if ($ReportPath) {
        Write-Message "Report: $ReportPath" -NoHeader
    }
    Write-Footer -ForegroundColor $rainbow
}
