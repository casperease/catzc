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
    $greedyShardFile = @{}
    $serialPhaseOffsetMs = 0

    # Measured per-file durations deal the shards longest first, so they finish together.
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
            # An unmeasured greedy file goes first: sorted last it never starts in a run that overruns, so it is never measured.
            [double]::MaxValue
        }
    }
    $GreedyFiles = @($GreedyFiles | Sort-Object -Property @{ Expression = { & $weightOf $_ }; Descending = $true }, @{ Expression = { $_ } })

    # The test files and the entry script, as seen from the root the run executes in (a no-op in place).
    $sourceParallelFiles = @($ParallelFiles)
    $ParallelFiles = @(Convert-TestRunLocationPath -Location $Location -Path $ParallelFiles)
    $GreedyFiles = @(Convert-TestRunLocationPath -Location $Location -Path $GreedyFiles)
    $SerialFiles = @(Convert-TestRunLocationPath -Location $Location -Path $SerialFiles)

    # Shared by every phase, with the entry-script seam and the tools this session located.
    $shardArguments = @{
        RunDirectory       = $RunDirectory
        ExcludeTag         = $ExcludeTag
        IncludeTag         = $IncludeTag
        Verbosity          = $Verbosity
        LanguageExecutable = Get-LanguageTestExecutable
    } + (Get-TestRunLocationEntry -Location $Location -EntryScript $EntryScript -EntryParameter $EntryParameter)

    # ProcessorCount / 4 by default: measured flat up to / 2, while per-test time inflates.
    $workerCount = if ($Workers -gt 0) {
        $Workers
    }
    else {
        [Math]::Max(1, [int][Math]::Floor([Environment]::ProcessorCount / 4))
    }
    $workerCount = [Math]::Max(1, [Math]::Min($workerCount, $ParallelFiles.Count))

    # Longest first to the least-loaded shard, so the phase ends when its work does.
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
    $policy = if ($GreedyFiles.Count -gt 0) {
        Get-Config -Config test-policy
    }
    # Greedy files queue behind the parallel shards and overlap only up to the greedy cap.
    $greedyGroupSize = if ($GreedyGroupSize -gt 0) {
        $GreedyGroupSize
    }
    elseif ($policy) {
        $policy.greedy_group_size
    }
    else {
        1
    }
    # A file kept apart (it runs real builds) also counts against the one-at-a-time cap.
    $greedyCaps = [System.Collections.Generic.List[string[]]]::new()
    $nextShardIndex = $workerCount
    foreach ($greedyFile in $GreedyFiles) {
        $shard = New-TestAutomationShardScript -ShardIndex $nextShardIndex -TestPath @($greedyFile) @shardArguments
        $greedyShards.Add($shard)
        $greedyCaps.Add([string[]] @(if ($policy.IsApart($greedyFile)) {
                    'greedy', 'apart'
                }
                else {
                    'greedy'
                }))
        $shardFileCounts[$shard.Label] = 1
        $greedyShardFile[$shard.Label] = $greedyFile
        $nextShardIndex++
    }

    if ($SerialFiles.Count -gt 0) {
        $serialShard = New-TestAutomationShardScript -ShardIndex $nextShardIndex -TestPath $SerialFiles @shardArguments
        $shardFileCounts[$serialShard.Label] = $SerialFiles.Count
    }

    # Workers inherit the held location, so a nested Invoke-TestFile runs in this run's root.
    $WorkerEnvironment = if ($WorkerEnvironment) {
        $WorkerEnvironment.Clone()
    }
    else {
        @{}
    }
    $WorkerEnvironment['CATZC_TEST_RUN_LOCATION_HELD'] = '1'
    # One bicep build cache per run, so each template compiles once for all the files that build it (Build-Bicep).
    $WorkerEnvironment['CATZC_BICEP_BUILD_CACHE'] = Join-Path $RunDirectory 'bicep-build-cache'

    # The prewarm counts in the run's time: it fills the caches the pool's files would otherwise fill side by side.
    $stopwatch.Start()
    $null = Invoke-TestRunPrewarm -TestFile (@($ParallelFiles) + @($GreedyFiles) + @($SerialFiles)) -RunDirectory $RunDirectory `
        -WorkerEnvironment $WorkerEnvironment -TimeoutSeconds $TimeoutSeconds -EntryScript $shardArguments['EntryScript'] -EntryParameter $shardArguments['EntryParameter']

    # Announced before the pool blocks: each worker's imports would otherwise read as a hang.
    Write-Message "Running $($ParallelFiles.Count) test file(s) across $($shards.Count) parallel worker(s)$(if ($greedyShards.Count) { ", with $($GreedyFiles.Count) greedy file(s) taking slots as they free, up to $greedyGroupSize at once" })$(if ($serialShard) { ", then $($SerialFiles.Count) serial-tagged file(s)" })..." -NoHeader

    # Parallel and greedy share one pool and timeline; only the serial phase carries an offset.
    $pooled = @($shards) + @($greedyShards)
    $poolStartMs = $stopwatch.ElapsedMilliseconds
    $poolEndMs = $poolStartMs
    if ($pooled.Count -gt 0) {
        # One pool: the parallel shards first, then each greedy file in the first slot a shard frees, under its caps.
        $caps = [string[][]] @(@(foreach ($shard in $shards) {
                    , [string[]] @()
                }) + @(foreach ($cap in $greedyCaps) {
                    , $cap
                }))
        $poolSize = Get-TestPoolSize -ParallelShardCount $shards.Count -GreedyFileCount $greedyShards.Count -GreedyGroupSize $greedyGroupSize
        $runner = Wait-PesterRunner -Runner ([Catzc.Base.QualityGates.PesterRunner]::Start(
                [string[]] @($pooled.ScriptPath), [string[]] @($pooled.Label), $caps,
                @{ greedy = $greedyGroupSize; apart = 1 },
                $poolSize, $WorkerEnvironment, $TimeoutSeconds, $false))
        $workerResults.AddRange($runner.Results)
        $allShards.AddRange([object[]] $pooled)
        $poolEndMs = $stopwatch.ElapsedMilliseconds
    }

    # The serial phase runs last and alone: its files mutate shared state.
    if ($serialShard) {
        Write-Message "Serial phase: $($SerialFiles.Count) serial-tagged file(s) in one worker..." -NoHeader
        $serialPhaseOffsetMs = $stopwatch.ElapsedMilliseconds
        $serialRunner = Wait-PesterRunner -Runner ([Catzc.Base.QualityGates.PesterRunner]::Start(
                [string[]] @($serialShard.ScriptPath), [string[]] @($serialShard.Label), 1,
                $WorkerEnvironment, $TimeoutSeconds, $false))
        $workerResults.AddRange($serialRunner.Results)
        $allShards.Add($serialShard)
    }
    $stopwatch.Stop()

    # Rows in shard order; a worker missing its rows or results file crashed, whatever its exit code.
    $rows = [System.Collections.Generic.List[object]]::new()
    $failedShardLabels = [System.Collections.Generic.List[string]]::new()
    $shardExitCodes = [ordered]@{}
    $workerSummaries = [System.Collections.Generic.List[object]]::new()
    $shardTimings = [System.Collections.Generic.List[object]]::new()
    for ($shardIndex = 0; $shardIndex -lt $allShards.Count; $shardIndex++) {
        $shard = $allShards[$shardIndex]
        $workerResult = $workerResults[$shardIndex]
        $shardExitCodes[$shard.Label] = $workerResult.ExitCode
        # Saved before the crash check, so a crashed worker's console is read after the run.
        Save-TestAutomationWorkerLog -Path $shard.LogPath -StandardOutput $workerResult.Stdout -StandardError $workerResult.Stderr

        if ($workerResult.ExitCode -notin 0, 1 -or -not (Test-Path $shard.RowsPath) -or
            -not (Test-Path $shard.ResultsPath)) {
            $stderrTail = "$($workerResult.Stderr)".Trim()
            throw ("Test worker '$($shard.Label)' crashed (exit $($workerResult.ExitCode)) without completing its run" +
                " — see $($shard.LogPath) (run.json carries the run status)." +
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

        # One summary per worker: queue number is submission order, start is on the run's one timeline.
        $isSerial = $serialShard -and $shard.Label -eq $serialShard.Label
        # ForEach-Object, not .Label: member enumeration on an empty list throws under strict mode (no greedy files).
        $isGreedy = -not $isSerial -and $shard.Label -in @($greedyShards | ForEach-Object { $_.Label })
        # The pool's workers carry their own start offset from the run's start; only the serial phase starts later.
        $phaseOffsetMs = if ($isSerial) {
            $serialPhaseOffsetMs
        }
        else {
            0
        }
        # Offsets on the run's stopwatch (prewarm included): the pool's workers count from the pool's start.
        $timelineBaseMs = if ($isSerial) {
            $serialPhaseOffsetMs
        }
        else {
            $poolStartMs
        }
        $shardStartMs = $timelineBaseMs + $workerResult.StartOffsetMs
        $shardTimings.Add([ordered]@{
                label        = $shard.Label
                startSeconds = [math]::Round($shardStartMs / 1000, 2)
                endSeconds   = [math]::Round(($shardStartMs + $workerResult.DurationMs) / 1000, 2)
                files        = $shardFileCounts[$shard.Label]
            })
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

    $fileEntries = Save-TestShardDurations -Shard @($allShards) -GreedyShardFile $greedyShardFile -Location $Location `
        -RepositoryRoot $repositoryRoot -HistoryPath $historyPath

    [pscustomobject]@{
        Rows              = @($rows)
        Files             = @($fileEntries)
        FailedShardLabels = @($failedShardLabels)
        ShardExitCodes    = $shardExitCodes
        Shards            = @($allShards)
        WorkerSummaries   = @($workerSummaries)
        ShardTimings      = @($shardTimings)
        PoolStartSeconds  = $poolStartMs / 1000
        PoolEndSeconds    = $poolEndMs / 1000
        DurationSeconds   = $stopwatch.Elapsed.TotalSeconds
        Location          = $Location
    }
}
