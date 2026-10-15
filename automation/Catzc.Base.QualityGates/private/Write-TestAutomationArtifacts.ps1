<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationArtifacts.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Writes a run's report artifacts and the skip report — best-effort, never masking the run outcome.
.DESCRIPTION
    Each part is guarded alone, so a reporting error is swallowed and a failing run throws for its own reason.
.PARAMETER Rows
    The run's aggregated per-test rows.
.PARAMETER RunDirectory
    The run's timestamped artifact directory.
.PARAMETER OutputFolder
    The report base directory (latest.txt lands here).
.PARAMETER MaxLevel
    The run's maximum tier (report metadata).
.PARAMETER Limits
    The per-level duration limits (report metadata).
.PARAMETER RunResult
    The aggregate verdict ('Passed'/'Failed').
.PARAMETER DurationSeconds
    The run's wall-clock duration.
.PARAMETER EnforceTimings
    Whether timing violations fail the run (report metadata).
.PARAMETER MinLevel
    The run's minimum tier (skip-report scope).
.PARAMETER Category
    The run's category (skip-report scope).
.PARAMETER Location
    Where the run executed (report metadata) — 'in-place', or the snapshot's provenance.
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

    # Written before any throw, so a failing run still produces its report.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationArtifacts.ps1.md#comment2)
    try {
        Write-TestAutomationReport -Rows $Rows -OutputFolder $RunDirectory -Level $MaxLevel -Limits $Limits `
            -RunResult $RunResult -DurationSeconds $DurationSeconds -TimingsEnforced:$EnforceTimings -Location $Location
        Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $RunDirectory -Leaf) -Encoding utf8
    }
    catch {
        Write-Message "Could not write test report to ${RunDirectory}: $_" -ForegroundColor Yellow -NoHeader
    }

    # A self-skip carries its reason; a test not run was excluded by this run's tier or category scope.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationArtifacts.ps1.md#comment3)
    try {
        Write-TestAutomationSkipReport -Rows $Rows -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category
    }
    catch {
        Write-Message "Could not render the skip report: $_" -ForegroundColor Yellow -NoHeader
    }

    # Plain assignment keeps the comma-wrapped getter result intact; a colon maps to a hash so the tags match.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationArtifacts.ps1.md#comment4)
    try {
        $ruleIds = Get-CatsAdrRuleIds
        Write-TestAutomationRuleCoverage -Rows $Rows -AnalyzerCoverage @(Get-AnalyzerAdrCoverage) `
            -AllRuleIds @($ruleIds -replace ':', '#') -OutputFolder $RunDirectory
    }
    catch {
        Write-Message "Could not render the rule-coverage report: $_" -ForegroundColor Yellow -NoHeader
    }
}
