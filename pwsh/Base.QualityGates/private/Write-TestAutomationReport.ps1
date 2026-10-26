<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationReport.ps1.md"
  header: "generated"
---
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

    # Slowest first; Rules makes tests.csv the backtrack table from a rule to its tests.
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
    # Invariant: ':' is the culture's time separator, '.' under some locales.
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
