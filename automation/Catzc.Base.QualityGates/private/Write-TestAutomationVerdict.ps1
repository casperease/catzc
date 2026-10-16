<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Write-TestAutomationVerdict.Tests.ps1
    adrs:
      - ADR-AUTO-CONSOLE#7
      - ADR-AUTO-FAILFAST
      - ADR-AUTO-XPLAT#6
  config:
    synopsis: |-
      Writes the closing verdict banner for a completed Test-Automation run — the rainbow-framed bracket that
      mirrors the scope header the run opens with.
    description: |-
      Renders one end-of-run banner and nothing else: a Write-Header whose rule lines carry a per-character
      gradient (green-rainbow on a passing run, red-rainbow on a failing one,
      [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)) while its
      titled line
      keeps the anchor's solid base colour, a default-coloured counts detail line (the banner rule carries the
      signal; the counts are data), and a Write-Footer closing the same gradient. It is the symmetric close to
      Write-TestAutomationHeader's cyan opener, printed on every exit path so a run is always visually bracketed.
      Every line routes through the shared Write-InformationColored chokepoint, so it stays silent under the Pester
      harness ($global:__PesterRunning) with no per-function plumbing.
    parameters:
      Result: |-
        The aggregate run verdict — the primary argument (Position 0). A ValidateSet, so a value other than 'Passed'
        or 'Failed' is rejected at binding (fail-fast,
        [ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)). It selects the gradient anchor: green for a
        pass, red for a fail.
      Summary: |-
        The one-line reason shown in the banner title (e.g. '812 passed, 14 skipped in 42.3s', or '3 test(s)
        failed') — the caller builds it, so the run's existing pass/failure wording is preserved verbatim.
      PassedCount: Passed-test count, rendered on the default-coloured detail line under the title.
      FailedCount: Failed-test count, rendered on the detail line.
      SkippedCount: Skipped-test count, rendered on the detail line.
      DurationSeconds: Wall-clock duration, rendered on the detail line.
      ReportPath: |-
        The run's report directory. Rendered on its own line inside the closing bracket so the "where do I look"
        pointer travels with the verdict itself rather than adrift in earlier output. Omitted (empty) prints no line.
---
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

    $anchor = if ($Result -eq 'Passed') {
        'Green'
    }
    else {
        'Red'
    }
    $rainbow = [Catzc.Base.Writers.RainbowColor]::new([System.ConsoleColor] $anchor)

    Write-Message '' -NoHeader
    Write-Header "Test Automation $($Result.ToUpperInvariant()) — $Summary" -ForegroundColor $rainbow
    $detail = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture,
        '{0} passed · {1} skipped · {2} failed · {3:N1}s wall clock', $PassedCount, $SkippedCount, $FailedCount, $DurationSeconds)
    Write-Message $detail -NoHeader
    if ($ReportPath) {
        Write-Message "Report: $ReportPath" -NoHeader
    }
    Write-Footer -ForegroundColor $rainbow
}
