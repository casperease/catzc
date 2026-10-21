<#
---
catzc:
  immutable:
    with_body_sha: bc4de333415a
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationVerdict.Tests.ps1
    docs: "[Write-TestAutomationVerdict.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationVerdict.ps1.md)"
    cites:
      - ADR-AUTO-CONSOLE-SPARINGCOLOUR
      - ADR-AUTO-FAILFAST
      - ADR-AUTO-XPLAT-INVARIANTCULTURE
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
