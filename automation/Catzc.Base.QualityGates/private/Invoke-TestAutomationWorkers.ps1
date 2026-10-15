# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Runs the test files through the parallel worker pool (and the serial phase) and aggregates the rows.
.DESCRIPTION
    A run never waits for another: it runs in place when the folder is free, else in a verified snapshot of it.
    [ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment1)
.PARAMETER ParallelFiles
    The test files to shard across the pool (may be empty when only tagged files are in scope).
.PARAMETER GreedyFiles
    Greedy files overlap each other but never the parallel phase, which is why each gets a single-file shard.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment2)
.PARAMETER SerialFiles
    The serial-tagged test files for the final one-worker phase (may be empty).
.PARAMETER Location
    The location the test run claimed (Enter-TestRunLocation) — where the run executes. The caller releases it.
.PARAMETER RunDirectory
    The run directory the shard scripts and their artifacts are written into.
.PARAMETER ExcludeTag
    Tags excluded from every worker's run (from Get-TestExcludeTag).
.PARAMETER Verbosity
    Pester output verbosity inside each worker.
.PARAMETER Workers
    Explicit pool size; 0 sizes automatically — max(1, ProcessorCount / 4), never more than the file count.
.PARAMETER GreedyGroupSize
    Greedy files run side by side in groups of this size, one group after another; 0 reads greedy_group_size from test-policy.yml.
.PARAMETER TimeoutSeconds
    Hard ceiling per execution phase; on expiry the pool is killed and the run throws.
.PARAMETER WorkerEnvironment
    Extra environment variables for each worker's process (the L0/L1 tripwire) — never the parent's $env:.
.PARAMETER EntryScript
    Empty loads the source importer; only a build run passes its own Import-Catzc.ps1 here.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment3)
.PARAMETER EntryParameter
    Named arguments for -EntryScript (the build run's @{ RepositoryRoot = <repo> }).
.OUTPUTS
    [pscustomobject] with Rows (aggregated, in shard order), Files (every shard's files-sidecar entries — File as a
    working-folder path, DurationMs, Result, ErrorMessage), FailedShardLabels (shards that exited 1),
    ShardExitCodes (label -> exit code, for the run manifest), Shards (the shard descriptors, serial last),
    WorkerSummaries (one per worker: queue number, label, file/test tallies, wall-clock start and duration —
    the end-of-run table's rows), DurationSeconds (wall clock across both phases), and Location (the
    -Location the workers executed in, the same object — Get-TestRunLocationSummary renders it for the run
    manifest and the report).
#>
function Invoke-TestAutomationWorkers {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $ParallelFiles,

        [AllowEmptyCollection()]
        [string[]] $GreedyFiles = @(),

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $SerialFiles,

        [Parameter(Mandatory)]
        [pscustomobject] $Location,

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @(),

        [AllowEmptyCollection()]
        [string[]] $IncludeTag = @(),

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Verbosity = 'Detailed',

        [ValidateRange(0, 64)]
        [int] $Workers = 0,

        [ValidateRange(0, 64)]
        [int] $GreedyGroupSize = 0,

        # The entry point's own limit, passed down by Invoke-TestRun; no default here.
        [Parameter(Mandatory)]
        [ValidateRange(60, 86400)]
        [int] $TimeoutSeconds,

        [hashtable] $WorkerEnvironment,

        [string] $EntryScript,

        [hashtable] $EntryParameter = @{}
    )

    $stopwatch = [System.Diagnostics.Stopwatch]::new()
    $workerResults = [System.Collections.Generic.List[object]]::new()
    $allShards = [System.Collections.Generic.List[object]]::new()
    $greedyShards = [System.Collections.Generic.List[object]]::new()
    $serialShard = $null
    $shardFileCounts = @{}
    $greedyOffsetMs = @{}
    $serialPhaseOffsetMs = 0

    # Per-machine durations deal the shards longest first so they finish together, and order the greedy files too.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment4)
    $repositoryRoot = Get-RepositoryRoot
    $historyPath = Join-Path ([System.IO.Path]::GetDirectoryName([System.IO.Path]::TrimEndingDirectorySeparator($RunDirectory))) 'durations.json'
    $history = Get-TestDurationHistory -Path $historyPath
    $weightOf = {
        param([string] $Path)
        $relative = [System.IO.Path]::GetRelativePath($repositoryRoot, $Path) -replace '\\', '/'
        if ($history.Contains($relative)) {
            $history[$relative]
        }
        else {
            0
        }
    }
    $GreedyFiles = @($GreedyFiles | Sort-Object -Property @{ Expression = { & $weightOf $_ }; Descending = $true }, @{ Expression = { $_ } })

    # The test files and the entry script, as seen from the root the run executes in (a no-op in place).
    $sourceParallelFiles = @($ParallelFiles)
    $ParallelFiles = @(Convert-TestRunLocationPath -Location $Location -Path $ParallelFiles)
    $GreedyFiles = @(Convert-TestRunLocationPath -Location $Location -Path $GreedyFiles)
    $SerialFiles = @(Convert-TestRunLocationPath -Location $Location -Path $SerialFiles)

    # A build's engine has no tools.yml entry to locate the language tools from, so this source session passes them.
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment5)
    $shardArguments = @{
        RunDirectory       = $RunDirectory
        ExcludeTag         = $ExcludeTag
        IncludeTag         = $IncludeTag
        Verbosity          = $Verbosity
        LanguageExecutable = Get-LanguageTestExecutable
    } + (Get-TestRunLocationEntry -Location $Location -EntryScript $EntryScript -EntryParameter $EntryParameter)

    # ProcessorCount / 4: more workers add no speed but inflate per-test time until level limits read as breached.
    # [comment:6](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment6)
    $workerCount = if ($Workers -gt 0) {
        $Workers
    }
    else {
        [Math]::Max(1, [int][Math]::Floor([Environment]::ProcessorCount / 4))
    }
    $workerCount = [Math]::Max(1, [Math]::Min($workerCount, $ParallelFiles.Count))

    # Longest first to the least-loaded shard, so the phase ends when its work does, not its unluckiest shard.
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment7)
    $assignment = @(Select-TestShardAssignment -File $sourceParallelFiles -WorkerCount $workerCount -DurationMs $history -RepositoryRoot $repositoryRoot)
    $shardFiles = @{}
    for ($shardIndex = 0; $shardIndex -lt $workerCount; $shardIndex++) {
        $shardFiles[$shardIndex] = [System.Collections.Generic.List[string]]::new()
        foreach ($sourceFile in $assignment[$shardIndex]) {
            $shardFiles[$shardIndex].Add((Convert-TestRunLocationPath -Location $Location -Path $sourceFile))
        }
    }

    $shards = [System.Collections.Generic.List[object]]::new()
    for ($shardIndex = 0; $shardIndex -lt $workerCount; $shardIndex++) {
        if ($shardFiles[$shardIndex].Count -eq 0) {
            continue
        }
        $shard = New-TestAutomationShardScript -ShardIndex $shardIndex -TestPath $shardFiles[$shardIndex] @shardArguments
        $shards.Add($shard)
        $shardFileCounts[$shard.Label] = $shardFiles[$shardIndex].Count
    }
    # Greedy files have L2-scale limits, so they overlap each other after the parallel phase, not starving it.
    # [comment:8](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment8)
    $greedyGroupSize = if ($GreedyGroupSize -gt 0) {
        $GreedyGroupSize
    }
    elseif ($GreedyFiles.Count -gt 0) {
        (Get-Config -Config test-policy).greedy_group_size
    }
    else {
        1
    }
    $nextShardIndex = $workerCount
    foreach ($greedyFile in $GreedyFiles) {
        $shard = New-TestAutomationShardScript -ShardIndex $nextShardIndex -TestPath @($greedyFile) @shardArguments
        $greedyShards.Add($shard)
        $shardFileCounts[$shard.Label] = 1
        $nextShardIndex++
    }

    if ($SerialFiles.Count -gt 0) {
        $serialShard = New-TestAutomationShardScript -ShardIndex $nextShardIndex -TestPath $SerialFiles @shardArguments
        $shardFileCounts[$serialShard.Label] = $SerialFiles.Count
    }

    # The held variable makes a nested Invoke-TestFile run in place in this run's root, not claim its own location.
    # [comment:9](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment9)
    $WorkerEnvironment = if ($WorkerEnvironment) {
        $WorkerEnvironment.Clone()
    }
    else {
        @{}
    }
    $WorkerEnvironment['CATZC_TEST_RUN_LOCATION_HELD'] = '1'

    # Silence here would read as a hang: each worker pays its own importer and Pester load before its first line.
    # [ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)
    # [comment:10](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment10)
    Write-Message "Running $($ParallelFiles.Count) test file(s) across $($shards.Count) parallel worker(s)$(if ($greedyShards.Count) { ", then $($GreedyFiles.Count) greedy file(s) in groups of $greedyGroupSize" })$(if ($serialShard) { ", then $($SerialFiles.Count) serial-tagged file(s)" })..." -NoHeader

    $stopwatch.Start()
    if ($shards.Count -gt 0) {
        $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
            [string[]] @($shards.ScriptPath), [string[]] @($shards.Label), $shards.Count,
            $WorkerEnvironment, $TimeoutSeconds, $false)
        $workerResults.AddRange($runner.Results)
        $allShards.AddRange($shards)
    }

    # Phase offsets put every phase's workers on one wall-clock timeline; their own start offsets are per run.
    # [comment:11](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment11)
    if ($greedyShards.Count -gt 0) {
        $groupCount = [Math]::Ceiling($greedyShards.Count / $greedyGroupSize)
        Write-Message "Greedy phase: $($greedyShards.Count) file(s) in $groupCount group(s) of up to $greedyGroupSize, one group after another..." -NoHeader
        for ($groupStart = 0; $groupStart -lt $greedyShards.Count; $groupStart += $greedyGroupSize) {
            $group = @($greedyShards.GetRange($groupStart, [Math]::Min($greedyGroupSize, $greedyShards.Count - $groupStart)))
            $groupOffsetMs = $stopwatch.ElapsedMilliseconds
            foreach ($member in $group) {
                $greedyOffsetMs[$member.Label] = $groupOffsetMs
            }
            $greedyRunner = [Catzc.Base.QualityGates.PesterRunner]::Run(
                [string[]] @($group.ScriptPath), [string[]] @($group.Label), $group.Count,
                $WorkerEnvironment, $TimeoutSeconds, $false)
            $workerResults.AddRange($greedyRunner.Results)
            $allShards.AddRange($group)
        }
    }

    # The serial phase runs last, alone — its files mutate state no other worker may see changing underneath it.
    # [comment:12](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment12)
    if ($serialShard) {
        Write-Message "Serial phase: $($SerialFiles.Count) serial-tagged file(s) in one worker..." -NoHeader
        $serialPhaseOffsetMs = $stopwatch.ElapsedMilliseconds
        $serialRunner = [Catzc.Base.QualityGates.PesterRunner]::Run(
            [string[]] @($serialShard.ScriptPath), [string[]] @($serialShard.Label), 1,
            $WorkerEnvironment, $TimeoutSeconds, $false)
        $workerResults.AddRange($serialRunner.Results)
        $allShards.Add($serialShard)
    }
    $stopwatch.Stop()

    # A worker exiting outside 0 and 1, or missing its rows or results file, fails the run, never a partial report.
    # [comment:13](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment13)
    $rows = [System.Collections.Generic.List[object]]::new()
    $failedShardLabels = [System.Collections.Generic.List[string]]::new()
    $shardExitCodes = [ordered]@{}
    $workerSummaries = [System.Collections.Generic.List[object]]::new()
    for ($shardIndex = 0; $shardIndex -lt $allShards.Count; $shardIndex++) {
        $shard = $allShards[$shardIndex]
        $workerResult = $workerResults[$shardIndex]
        $shardExitCodes[$shard.Label] = $workerResult.ExitCode

        if ($workerResult.ExitCode -notin 0, 1 -or -not (Test-Path $shard.RowsPath) -or -not (Test-Path $shard.ResultsPath)) {
            $stderrTail = "$($workerResult.Stderr)".Trim()
            throw ("Test worker '$($shard.Label)' crashed (exit $($workerResult.ExitCode)) without completing its run" +
                " — see $RunDirectory (run.json carries the run status)." +
                $(if ($stderrTail) {
                        " Stderr:`n$stderrTail"
                    }))
        }
        if ($workerResult.ExitCode -eq 1) {
            $failedShardLabels.Add($shard.Label)
        }

        $shardRows = @([System.IO.File]::ReadAllText($shard.RowsPath) | ConvertFrom-Json)
        foreach ($row in $shardRows) {
            # Reports and module protection read working-folder paths, wherever the run executed.
            $row.File = Convert-TestRunLocationPath -Location $Location -Path $row.File -ToSource
            $rows.Add($row)
        }

        # Queue number is submission order, greedy after the pool and serial last; start is on the run's timeline.
        # [comment:14](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment14)
        $isSerial = $serialShard -and $shard.Label -eq $serialShard.Label
        # ForEach-Object, not .Label: member enumeration on an empty list throws under strict mode (no greedy files).
        $isGreedy = -not $isSerial -and $shard.Label -in @($greedyShards | ForEach-Object { $_.Label })
        $phaseOffsetMs = if ($isSerial) {
            $serialPhaseOffsetMs
        }
        elseif ($isGreedy) {
            $greedyOffsetMs[$shard.Label]
        }
        else {
            0
        }
        $label = if ($isSerial) {
            "$($shard.Label) (serial)"
        }
        elseif ($isGreedy) {
            "$($shard.Label) (greedy)"
        }
        else {
            $shard.Label
        }
        $workerSummaries.Add([pscustomobject]@{
                QueueNumber     = $shardIndex + 1
                Label           = $label
                Files           = $shardFileCounts[$shard.Label]
                Tests           = $shardRows.Count
                Passed          = @($shardRows | Where-Object { $_.Result -eq 'Passed' }).Count
                Failed          = @($shardRows | Where-Object { $_.Result -eq 'Failed' }).Count
                Skipped         = @($shardRows | Where-Object { $_.Result -eq 'Skipped' }).Count
                StartSeconds    = ($phaseOffsetMs + $workerResult.StartOffsetMs) / 1000
                DurationSeconds = $workerResult.DurationMs / 1000
            })
    }

    # A shard without a files sidecar adds nothing, so the history keeps that file's last measurement.
    # [comment:15](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md#comment15)
    $measured = @{}
    $fileEntries = [System.Collections.Generic.List[object]]::new()
    foreach ($shard in $allShards) {
        if ([System.IO.File]::Exists($shard.FilesPath)) {
            foreach ($entry in @([System.IO.File]::ReadAllText($shard.FilesPath) | ConvertFrom-Json)) {
                $source = Convert-TestRunLocationPath -Location $Location -Path $entry.File -ToSource
                $measured[([System.IO.Path]::GetRelativePath($repositoryRoot, $source) -replace '\\', '/')] = $entry.DurationMs
                $entry.File = $source
                $fileEntries.Add($entry)
            }
        }
    }
    if ($measured.Count -gt 0) {
        Save-TestDurationHistory -Path $historyPath -DurationMs $measured
    }

    [pscustomobject]@{
        Rows              = @($rows)
        Files             = @($fileEntries)
        FailedShardLabels = @($failedShardLabels)
        ShardExitCodes    = $shardExitCodes
        Shards            = @($allShards)
        WorkerSummaries   = @($workerSummaries)
        DurationSeconds   = $stopwatch.Elapsed.TotalSeconds
        Location          = $Location
    }
}
