<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
    folder: private
    name: write-test-automation-verdict
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
    page: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationVerdict.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Write-TestAutomationVerdict.Tests.ps1
    cites:
      - ADR-AUTO-CONSOLE#7
      - ADR-AUTO-FAILFAST
      - ADR-AUTO-XPLAT#6
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
