<#
---
catzc:
  immutable:
    with_body_sha: "5c1c05c8bda5"
  edges:
    docs: "[Invoke-TestAutomationWorkers.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md)"
    cites:
      - ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING
      - ADR-AUTO-TEST-ONESCHEDULINGPOOL
      - ADR-AUTO-TEST-RUNSNEVERWAIT
---
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

    $shardArguments = @{
        RunDirectory       = $RunDirectory
        ExcludeTag         = $ExcludeTag
        IncludeTag         = $IncludeTag
        Verbosity          = $Verbosity
        LanguageExecutable = Get-LanguageTestExecutable
    } + (Get-TestRunLocationEntry -Location $Location -EntryScript $EntryScript -EntryParameter $EntryParameter)

    $workerCount = if ($Workers -gt 0) {
        $Workers
    }
    else {
        [Math]::Max(1, [int][Math]::Floor([Environment]::ProcessorCount / 4))
    }
    $workerCount = [Math]::Max(1, [Math]::Min($workerCount, $ParallelFiles.Count))

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
    $greedyGroupSize = if ($GreedyGroupSize -gt 0) {
        $GreedyGroupSize
    }
    elseif ($policy) {
        $policy.greedy_group_size
    }
    else {
        1
    }
    # A greedy file counts against the greedy cap; one the policy keeps apart (it runs real builds) also against the one-at-a-time cap.
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

    $WorkerEnvironment = if ($WorkerEnvironment) {
        $WorkerEnvironment.Clone()
    }
    else {
        @{}
    }
    $WorkerEnvironment['CATZC_TEST_RUN_LOCATION_HELD'] = '1'

    Write-Message "Running $($ParallelFiles.Count) test file(s) across $($shards.Count) parallel worker(s)$(if ($greedyShards.Count) { ", with $($GreedyFiles.Count) greedy file(s) taking slots as they free, up to $greedyGroupSize at once" })$(if ($serialShard) { ", then $($SerialFiles.Count) serial-tagged file(s)" })..." -NoHeader

    $stopwatch.Start()
    $pooled = @($shards) + @($greedyShards)
    if ($pooled.Count -gt 0) {
        # One pool: the parallel shards first, then each greedy file in the first slot a shard frees, under its caps.
        $caps = [string[][]] @(@(foreach ($shard in $shards) {
                    , [string[]] @()
                }) + @(foreach ($cap in $greedyCaps) {
                    , $cap
                }))
        $poolSize = Get-TestPoolSize -ParallelShardCount $shards.Count -GreedyFileCount $greedyShards.Count -GreedyGroupSize $greedyGroupSize
        $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
            [string[]] @($pooled.ScriptPath), [string[]] @($pooled.Label), $caps, @{ greedy = $greedyGroupSize; apart = 1 },
            $poolSize, $WorkerEnvironment, $TimeoutSeconds, $false)
        $workerResults.AddRange($runner.Results)
        $allShards.AddRange([object[]] $pooled)
    }

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

    $measured = @{}
    $fileEntries = [System.Collections.Generic.List[object]]::new()
    foreach ($shard in $allShards) {
        if ([System.IO.File]::Exists($shard.FilesPath)) {
            $shardEntries = @([System.IO.File]::ReadAllText($shard.FilesPath) | ConvertFrom-Json)
            $shardSource = if ($greedyShardFile.ContainsKey($shard.Label) -and $shardEntries.Count -eq 1) {
                Convert-TestRunLocationPath -Location $Location -Path $greedyShardFile[$shard.Label] -ToSource
            }
            else {
                ''
            }
            foreach ($entry in $shardEntries) {
                $source = Convert-TestRunLocationPath -Location $Location -Path $entry.File -ToSource
                $measured[(Get-TestDurationKey -File $source -ShardFile $shardSource -RepositoryRoot $repositoryRoot)] = $entry.DurationMs
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
