<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationArtifacts.ps1
    folder: private
    name: write-test-automation-artifacts
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationArtifacts.ps1.md
  config:
    synopsis: Writes a run's report artifacts and the skip report — best-effort, never masking the run outcome.
    description: |-
      Persists summary.md + tests.csv beside the per-shard results (Write-TestAutomationReport), points
      latest.txt at the run, renders the end-of-run skip report (Write-TestAutomationSkipReport), and writes the
      ADR rule-enforcement coverage (Write-TestAutomationRuleCoverage — rule-coverage.md/.csv). Each part is
      try/catch-guarded independently: a rendering error is reported as a yellow line and swallowed, so a failing
      run still throws for its own reason, not a reporting one.
    parameters:
      Rows: The run's aggregated per-test rows.
      RunDirectory: The run's timestamped artifact directory.
      OutputFolder: The report base directory (latest.txt lands here).
      MaxLevel: The run's maximum tier (report metadata).
      Limits: The per-level duration limits (report metadata).
      RunResult: The aggregate verdict ('Passed'/'Failed').
      DurationSeconds: The run's wall-clock duration.
      EnforceTimings: Whether timing violations fail the run (report metadata).
      MinLevel: The run's minimum tier (skip-report scope).
      Category: The run's category (skip-report scope).
      Location: Where the run executed (report metadata) — 'in-place', or the snapshot's provenance.
---
#>

function Write-TestAutomationArtifacts {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()]
        [object[]] $Rows = @(),

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [string] $OutputFolder,

        [Parameter(Mandatory)]
        [int] $MaxLevel,

        [Parameter(Mandatory)]
        [hashtable] $Limits,

        [Parameter(Mandatory)]
        [string] $RunResult,

        [Parameter(Mandatory)]
        [double] $DurationSeconds,

        [switch] $EnforceTimings,

        [Parameter(Mandatory)]
        [int] $MinLevel,

        [Parameter(Mandatory)]
        [string] $Category,

        [string] $Location
    )

    try {
        Write-TestAutomationReport -Rows $Rows -OutputFolder $RunDirectory -Level $MaxLevel -Limits $Limits `
            -RunResult $RunResult -DurationSeconds $DurationSeconds -TimingsEnforced:$EnforceTimings -Location $Location
        Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $RunDirectory -Leaf) -Encoding utf8
    }
    catch {
        Write-Message "Could not write test report to ${RunDirectory}: $_" -ForegroundColor Yellow -NoHeader
    }

    try {
        Write-TestAutomationSkipReport -Rows $Rows -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category
    }
    catch {
        Write-Message "Could not render the skip report: $_" -ForegroundColor Yellow -NoHeader
    }

    try {
        $ruleIds = Get-CatsAdrRuleIds
        Write-TestAutomationRuleCoverage -Rows $Rows -AnalyzerCoverage @(Get-AnalyzerAdrCoverage) `
            -AllRuleIds @($ruleIds -replace ':', '#') -OutputFolder $RunDirectory
    }
    catch {
        Write-Message "Could not render the rule-coverage report: $_" -ForegroundColor Yellow -NoHeader
    }
}
