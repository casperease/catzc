<#
.SYNOPSIS
    Renders a human-readable run report (summary.md + tests.csv) from a Pester result.
.DESCRIPTION
    Writes two files into $OutputFolder from a Pester run object ($result, produced with Run.PassThru):
      - tests.csv   : one row per test (ExpandedPath, Result, DurationMs, Level, File, Line), slowest first.
      - summary.md  : run header + counts, the failures (with file:line and message), the slowest tests,
                      and the over-limit timing violations (the same per-level rule the console prints).
    The canonical machine artifact (results.xml) is written by Pester itself; this adds the at-a-glance view.
    Level resolution is shared with Test-Automation via Get-TestLevelTag, and the limit map is passed in so
    there is a single source of truth.
.PARAMETER Result
    The Pester run object ($result from Invoke-Pester -Configuration <with Run.PassThru>).
.PARAMETER OutputFolder
    The run directory the files are written into (created if missing).
.PARAMETER Level
    The -Level the run was invoked with (recorded in the header).
.PARAMETER Limits
    Per-level millisecond limits keyed by tag (L0/L1/L2/L3) — the over-limit threshold per test level.
.PARAMETER SlowestCount
    How many slowest passed tests to list. Defaults to 20.
.PARAMETER TimingsEnforced
    Whether -EnforceTimings was set (annotates the over-limit section).
#>
function Write-TestAutomationReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Result,

        [Parameter(Mandatory)]
        [string] $OutputFolder,

        [int] $Level,

        [hashtable] $Limits = @{ 'L0' = 400; 'L1' = 2000; 'L2' = 120000; 'L3' = 30000 },

        [int] $SlowestCount = 20,

        [switch] $TimingsEnforced
    )

    if (-not (Test-Path $OutputFolder -PathType Container)) {
        New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    }

    $tests = @($Result.Tests)

    # tests.csv — one row per test, slowest first.
    $rows = foreach ($t in $tests) {
        [pscustomobject]@{
            ExpandedPath = $t.ExpandedPath
            Result       = $t.Result
            DurationMs   = [int]$t.Duration.TotalMilliseconds
            Level        = Get-TestLevelTag -Test $t
            Category     = Get-TestCategoryTag -Test $t
            File         = $t.ScriptBlock.File
            Line         = $t.ScriptBlock.StartPosition.StartLine
        }
    }
    $rows = @($rows | Sort-Object -Property DurationMs -Descending)
    $rows | Export-Csv -Path (Join-Path $OutputFolder 'tests.csv') -NoTypeInformation -Encoding utf8

    # summary.md
    $failed = @($tests | Where-Object { $_.Result -eq 'Failed' })
    $slowest = @($rows | Where-Object { $_.Result -eq 'Passed' } | Select-Object -First $SlowestCount)

    # Over-limit timings — the same per-level rule Test-Automation prints to the console.
    $violations = foreach ($t in $tests) {
        if ($t.Result -ne 'Passed') {
            continue
        }
        $tag = Get-TestLevelTag -Test $t
        if (-not $tag) {
            continue
        }   # untagged/ambiguous tier — no level limit applies (mirrors Test-Automation)
        $limitMs = $Limits[$tag]
        $ms = [int]$t.Duration.TotalMilliseconds
        if ($limitMs -and $ms -gt $limitMs) {
            [pscustomobject]@{ Tag = $tag; LimitMs = $limitMs; Ms = $ms; Name = $t.ExpandedName }
        }
    }
    $violations = @($violations | Sort-Object -Property Ms -Descending)

    $pesterVersion = (Get-Module Pester | Select-Object -First 1).Version
    # InvariantCulture: a bare ':' in a .NET date format is the culture's time-separator placeholder, which
    # renders as '.' under some locales (see the cross-platform ADR). Force literal colons.
    $now = [datetime]::Now.ToString('yyyy-MM-dd HH:mm:ss', [System.Globalization.CultureInfo]::InvariantCulture)
    $os = [System.Runtime.InteropServices.RuntimeInformation]::OSDescription.Trim()
    $totalSeconds = [math]::Round($Result.Duration.TotalSeconds, 2)

    $stringBuilder = [System.Text.StringBuilder]::new()
    [void]$stringBuilder.AppendLine('# Test-Automation report')
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine("- Date: $now")
    [void]$stringBuilder.AppendLine("- Level: $Level")
    [void]$stringBuilder.AppendLine("- Host: $([System.Environment]::MachineName) ($os)")
    [void]$stringBuilder.AppendLine("- Pester: $pesterVersion")
    [void]$stringBuilder.AppendLine("- Duration: ${totalSeconds}s")
    [void]$stringBuilder.AppendLine("- Result: $($Result.Result)")
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine('## Counts')
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine('| Total | Passed | Failed | Skipped | NotRun |')
    [void]$stringBuilder.AppendLine('| ----- | ------ | ------ | ------- | ------ |')
    [void]$stringBuilder.AppendLine("| $($Result.TotalCount) | $($Result.PassedCount) | $($Result.FailedCount) | $($Result.SkippedCount) | $($Result.NotRunCount) |")
    [void]$stringBuilder.AppendLine('')

    [void]$stringBuilder.AppendLine("## Failures ($($failed.Count))")
    [void]$stringBuilder.AppendLine('')
    if ($failed.Count -eq 0) {
        [void]$stringBuilder.AppendLine('_None._')
        [void]$stringBuilder.AppendLine('')
    }
    else {
        foreach ($t in $failed) {
            $loc = if ($t.ScriptBlock.File) {
                "$($t.ScriptBlock.File):$($t.ScriptBlock.StartPosition.StartLine)"
            }
            else {
                '(unknown)'
            }
            $message = (@($t.ErrorRecord) | ForEach-Object { $_.Exception.Message }) -join "`n"
            $stack = (@($t.ErrorRecord) | ForEach-Object { $_.ScriptStackTrace }) -join "`n"
            [void]$stringBuilder.AppendLine("### $($t.ExpandedPath)")
            [void]$stringBuilder.AppendLine('')
            [void]$stringBuilder.AppendLine("- Location: $loc")
            [void]$stringBuilder.AppendLine('')
            [void]$stringBuilder.AppendLine('```')
            [void]$stringBuilder.AppendLine($message)
            if ($stack) {
                [void]$stringBuilder.AppendLine('')
                [void]$stringBuilder.AppendLine($stack)
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
