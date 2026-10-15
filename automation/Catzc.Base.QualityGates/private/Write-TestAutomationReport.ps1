<#
.SYNOPSIS
    Renders a human-readable run report (summary.md + tests.csv) from the run's row set.
.DESCRIPTION
    Writes two files into $OutputFolder from the aggregated per-test rows (ConvertTo-TestAutomationRowSet): -...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md#comment1)
.PARAMETER Rows
    The aggregated per-test rows (ConvertTo-TestAutomationRowSet output, merged across shards).
.PARAMETER OutputFolder
    The run directory the files are written into (created if missing).
.PARAMETER Level
    The -Level the run was invoked with (recorded in the header).
.PARAMETER RunResult
    The run's aggregate verdict ('Passed'/'Failed'), recorded in the header.
.PARAMETER DurationSeconds
    The run's wall-clock duration in seconds, recorded in the header.
.PARAMETER Limits
    Per-level millisecond limits keyed by tag (L0/L1/L2/L3) — the over-limit threshold per test level.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md#comment2)
.PARAMETER RunBudgetSeconds
    The budget for the whole run, in seconds; the header records the run against it (a devbox run over it fails, ).
    [ADR-AUTO-TEST#44](/docs/adr/automation/test-automation.md#rule-adr-auto-test44)
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md#comment3)
.PARAMETER SlowestCount
    How many slowest passed tests to list. Defaults to 20.
.PARAMETER TimingsEnforced
    Whether -EnforceTimings was set (annotates the over-limit section).
.PARAMETER Location
    Where the run executed — 'in-place', or the snapshot's provenance — recorded in the header when given.
#>
function Write-TestAutomationReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Rows,

        [Parameter(Mandatory)]
        [string] $OutputFolder,

        [int] $Level,

        [string] $RunResult = '',

        [double] $DurationSeconds = 0,

        [hashtable] $Limits = (Get-TestTimeLimits).LevelMs,

        [int] $RunBudgetSeconds = (Get-TestTimeLimits).RunSeconds,

        [int] $SlowestCount = 20,

        [switch] $TimingsEnforced,

        [string] $Location
    )

    if (-not (Test-Path $OutputFolder -PathType Container)) {
        New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    }

    # tests.csv — one row per test, slowest first (the report's columns; failure detail stays in summary.md).
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md#comment4)
    $csvRows = @($Rows |
            Select-Object ExpandedPath, Result, DurationMs, Level, Category, Rules, File, Line |
            Sort-Object -Property DurationMs -Descending)
    $csvRows | Export-Csv -Path (Join-Path $OutputFolder 'tests.csv') -NoTypeInformation -Encoding utf8

    # summary.md
    $failed = @($Rows | Where-Object { $_.Result -eq 'Failed' })
    $slowest = @($csvRows | Where-Object { $_.Result -eq 'Passed' } | Select-Object -First $SlowestCount)

    # Over-limit timings — the same per-level rule Test-Automation prints to the console.
    $violations = foreach ($row in $Rows) {
        if ($row.Result -ne 'Passed') {
            continue
        }
        if (-not $row.Level) {
            continue
        }   # untagged/ambiguous tier — no level limit applies (mirrors Test-Automation)
        $limitMs = $Limits[$row.Level]
        if ($limitMs -and $row.DurationMs -gt $limitMs) {
            [pscustomobject]@{ Tag = $row.Level; LimitMs = $limitMs; Ms = $row.DurationMs; Name = $row.ExpandedName }
        }
    }
    $violations = @($violations | Sort-Object -Property Ms -Descending)

    # Counts are derived from the rows — the one shape every shard contributes to.
    $passedCount = @($Rows | Where-Object { $_.Result -eq 'Passed' }).Count
    $skippedCount = @($Rows | Where-Object { $_.Result -eq 'Skipped' }).Count
    $notRunCount = @($Rows | Where-Object { $_.Result -eq 'NotRun' }).Count

    $pesterVersion = (Get-Module Pester | Select-Object -First 1).Version
    # InvariantCulture: a bare ':' in a.NET date format is the culture's time-separator placeholder, which renders as...
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md#comment5)
    $now = [datetime]::Now.ToString('yyyy-MM-dd HH:mm:ss', [System.Globalization.CultureInfo]::InvariantCulture)
    $os = [System.Runtime.InteropServices.RuntimeInformation]::OSDescription.Trim()
    $totalSeconds = [math]::Round($DurationSeconds, 2)

    $stringBuilder = [System.Text.StringBuilder]::new()
    [void]$stringBuilder.AppendLine('# Test-Automation report')
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine("- Date: $now")
    [void]$stringBuilder.AppendLine("- Level: $Level")
    [void]$stringBuilder.AppendLine("- Host: $([System.Environment]::MachineName) ($os)")
    [void]$stringBuilder.AppendLine("- Pester: $pesterVersion")
    [void]$stringBuilder.AppendLine("- Duration: ${totalSeconds}s")
    if ($DurationSeconds -gt $RunBudgetSeconds) {
        $overSeconds = [math]::Round($DurationSeconds - $RunBudgetSeconds, 2)
        [void]$stringBuilder.AppendLine("- Run budget: ${RunBudgetSeconds}s — exceeded by ${overSeconds}s (fails a devbox run; tests.run_seconds in timeouts.yml)")
    }
    else {
        [void]$stringBuilder.AppendLine("- Run budget: ${RunBudgetSeconds}s — within")
    }
    [void]$stringBuilder.AppendLine("- Result: $RunResult")
    if ($Location) {
        [void]$stringBuilder.AppendLine("- Location: $Location")
    }
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine('## Counts')
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine('| Total | Passed | Failed | Skipped | NotRun |')
    [void]$stringBuilder.AppendLine('| ----- | ------ | ------ | ------- | ------ |')
    [void]$stringBuilder.AppendLine("| $($Rows.Count) | $passedCount | $($failed.Count) | $skippedCount | $notRunCount |")
    [void]$stringBuilder.AppendLine('')

    [void]$stringBuilder.AppendLine("## Failures ($($failed.Count))")
    [void]$stringBuilder.AppendLine('')
    if ($failed.Count -eq 0) {
        [void]$stringBuilder.AppendLine('_None._')
        [void]$stringBuilder.AppendLine('')
    }
    else {
        foreach ($row in $failed) {
            $loc = if ($row.File) {
                "$($row.File):$($row.Line)"
            }
            else {
                '(unknown)'
            }
            [void]$stringBuilder.AppendLine("### $($row.ExpandedPath)")
            [void]$stringBuilder.AppendLine('')
            [void]$stringBuilder.AppendLine("- Location: $loc")
            [void]$stringBuilder.AppendLine('')
            [void]$stringBuilder.AppendLine('```')
            [void]$stringBuilder.AppendLine($row.ErrorMessage)
            if ($row.ErrorStack) {
                [void]$stringBuilder.AppendLine('')
                [void]$stringBuilder.AppendLine($row.ErrorStack)
            }
            [void]$stringBuilder.AppendLine('```')
            [void]$stringBuilder.AppendLine('')
        }
    }

    [void]$stringBuilder.AppendLine("## Slowest tests (top $SlowestCount)")
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine('| Duration (ms) | Test |')
    [void]$stringBuilder.AppendLine('| ------------- | ---- |')
    foreach ($r in $slowest) {
        [void]$stringBuilder.AppendLine("| $($r.DurationMs) | $($r.ExpandedPath) |")
    }
    [void]$stringBuilder.AppendLine('')

    $enforceNote = if ($TimingsEnforced) {
        'enforced — these fail the run'
    }
    else {
        'report-only — pass -EnforceTimings to fail'
    }
    [void]$stringBuilder.AppendLine("## Over-limit timings ($($violations.Count)) [$enforceNote]")
    [void]$stringBuilder.AppendLine('')
    if ($violations.Count -eq 0) {
        [void]$stringBuilder.AppendLine('_None._')
    }
    else {
        foreach ($v in $violations) {
            [void]$stringBuilder.AppendLine("- [$($v.Tag) > $($v.LimitMs)ms] $($v.Name) took $($v.Ms)ms")
        }
    }
    [void]$stringBuilder.AppendLine('')

    [System.IO.File]::WriteAllText((Join-Path $OutputFolder 'summary.md'), $stringBuilder.ToString())
}
