<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationTimingReport.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Write-TestAutomationTimingReport.Tests.ps1
  config:
    synopsis: Renders the over-limit timing section of a Test-Automation run and returns whether it fails the run.
    description: |-
      Validates the run's rows against the per-level time limits (Get-TestTimingViolation owns the per-row
      check) and, when any test is over, writes the framed report — red and run-failing under
      -EnforceTimings, yellow and report-only otherwise (timings are machine-dependent, so enforcement is
      the caller's opt-in). Silent when nothing is over.
    parameters:
      Rows: The run's aggregated per-test rows.
      Limits: The per-level millisecond limits (level tag -> limit).
      EnforceTimings: Turn the report into a run failure (the returned value).
    outputs: '[bool] $true when violations exist AND -EnforceTimings was passed — the run''s timing verdict.'
---
#>

function Write-TestAutomationTimingReport {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Rows,

        [Parameter(Mandatory)]
        [hashtable] $Limits,

        [switch] $EnforceTimings
    )

    $violations = @(Get-TestTimingViolation -Rows $Rows -Limits $Limits)
    if ($violations.Count -eq 0) {
        return $false
    }

    $color = if ($EnforceTimings) {
        'Red'
    }
    else {
        'Yellow'
    }
    $header = if ($EnforceTimings) {
        'Tests exceeding level time limits'
    }
    else {
        'Tests exceeding level time limits (report-only — pass -EnforceTimings to fail)'
    }
    Write-Message '' -NoHeader
    Write-Header $header -ForegroundColor $color
    foreach ($violation in $violations) {
        Write-Message "  $violation" -ForegroundColor $color -NoHeader
    }
    Write-Message 'Tag slow tests with a higher level or optimize them.' -NoHeader
    Write-Footer -ForegroundColor $color

    [bool]$EnforceTimings
}
