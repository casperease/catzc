<#
.SYNOPSIS
    Runs all Pester tests found across automation modules, sharded across parallel worker processes.
.DESCRIPTION
    The harness parallelizes at whole-file granularity: the run's test files are round-robin sharded across
    worker processes (pwsh children driven by the PesterRunner type), each of which imports the repository,
    runs its shard, writes results-shard-<N>.xml plus a rows-shard-<N>.json sidecar, and streams its output
    through the pool — the first unfinished worker is live, later workers buffer and replay in submission
    order, so the console reads sequentially while the wall clock runs in parallel. Files containing any
    'serial'-tagged test (tests that mutate state shared across processes) run in a final one-worker phase,
    alone. Pester executes tests sequentially within a worker; a single file never splits across workers.
.PARAMETER MaxLevel
    Maximum test level to run (alias: -Level). Defaults to 2 (L0 + L1 + L2) — the L2 tier drives the
    locally-installed CLI tools and self-skips a test when its tool is absent, so the default stays green
    on a machine that is missing one.
    Tiers are defined by what a test integrates with (not by speed):
    L0/L1 = unit tests — pure logic with every external boundary mocked. L2 = integrates with a local CLI
    tool for real (e.g. `az bicep build`, python, dotnet);
    runs on a devbox and in fast CI where the tools are installed, and self-skips a test when its tool
    is absent. L3 = integrates with the cloud API layer (real cloud, maybe through a CLI tool such as
    `az deployment create`); opt-in, needs cloud access, self-skips when unavailable.
    Level 1 runs L0 + L1. Level 2 runs L0 + L1 + L2. Level 3 runs all.
    Every test must carry exactly one tier tag (L0-L3) and one category tag (logic|integrity); tests
    missing a tag are reported before the run (see Get-TestTagViolations).
.PARAMETER MinLevel
    Minimum test level to run. Defaults to 0 (no lower bound). Tiers below MinLevel are excluded, so
    -MinLevel 2 -MaxLevel 2 runs only L2 tests. Must not exceed MaxLevel.
.PARAMETER Modules
    One or more automation module names to test (tab-completes from Get-AutomationModules). Only the named
    modules' tests/ folders run; dot-prefixed infrastructure (.internal, .scriptanalyzer) is excluded.
    Empty (the default) runs every module plus that infrastructure. Composes with -Level and -Category.
.PARAMETER Category
    Which category of test to run: `Logic` (function-logic tests on mocks/fixtures), `Integrity`
    (tests that read the real repository contents — shipped configs, real templates, the module graph,
    checked-in binaries, conventions), or `Both` (the default). Composes with -Level — e.g.
    `-Level 1 -Category Logic` runs the L0/L1 logic tests only. Implemented by excluding the other
    category's tag.
.PARAMETER Workers
    How many parallel worker processes to shard the test files across. 0 (the default) sizes the pool
    automatically — min(ProcessorCount - 1, 8), never more than the file count. 1 runs everything through a
    single worker process (serialized, but still process-isolated). The serial phase always runs one worker,
    after the parallel shards complete.
.PARAMETER TimeoutSeconds
    Hard ceiling on each execution phase (the parallel pool, then the serial phase). On expiry every worker
    is killed and the run throws. Defaults to 3600.
.PARAMETER Output
    Pester output verbosity level inside each worker. Defaults to 'Detailed' (one line per test with its
    own duration); use 'Normal' for one line per file, or 'Minimal' for just the final tally.
.PARAMETER PassThru
    Returns the run summary object: Result, TotalCount/PassedCount/FailedCount/SkippedCount/NotRunCount,
    DurationSeconds, Rows (the aggregated per-test rows), RunDirectory, and Shards (the shard descriptors).
    By default, no object is returned.
.PARAMETER EnforceTimings
    Fail the run when a test exceeds its level's time limit. Off by default — timings are
    machine-dependent, so the run only *reports* over-limit tests (with their durations) and stays
    green. Pass this (e.g. in a controlled CI lane) to turn the report into a failure.
.PARAMETER OutputFolder
    Base directory for the run report. Every run writes a timestamped subfolder
    (<OutputFolder>/yyyyMMdd-HHmmss/) holding the per-shard results-shard-<N>.xml (Pester NUnit), the
    rows-shard-<N>.json sidecars, summary.md, and tests.csv. Defaults to <out>/test-automation (out/
    locally, the artifact staging directory in a pipeline).
.EXAMPLE
    Test-Automation
.EXAMPLE
    Test-Automation -Level 2
.EXAMPLE
    Test-Automation -MinLevel 2 -MaxLevel 2   # run only the L2 tier (skip L0/L1)
.EXAMPLE
    Test-Automation -Modules Catzc.Base.ModuleSystem   # run only one module's tests
.EXAMPLE
    Test-Automation -Modules Catzc.Azure, Catzc.Azure.Cli -Level 2   # several modules, through L2
.EXAMPLE
    Test-Automation -Category Integrity   # run only integrity tests (real configs/templates/repo checks)
.EXAMPLE
    Test-Automation -Category Logic       # run only the hermetic logic tests
.EXAMPLE
    Test-Automation -Workers 4            # pin the pool size instead of the automatic sizing
.EXAMPLE
    Test-Automation -Output Detailed -PassThru
.EXAMPLE
    Test-Automation -EnforceTimings   # fail if any test is over its level's limit
.EXAMPLE
    Test-Automation -OutputFolder C:\reports\catzc   # write the run report under a custom base
#>
function Test-Automation {
    [CmdletBinding()]
    param(
        [ValidateSet(0, 1, 2, 3)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3)]
        [Alias('Level')]
        [int] $MaxLevel = 2,

        [ArgumentCompleter({ Get-AutomationModules })]
        [ValidateScript({ $_ -in (Get-AutomationModules) })]
        [string[]] $Modules = @(),

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Both',

        [ValidateRange(0, 64)]
        [int] $Workers = 0,

        [ValidateRange(60, 86400)]
        [int] $TimeoutSeconds = 3600,

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [switch] $PassThru,

        [switch] $EnforceTimings,

        [string] $OutputFolder
    )

    if ($MinLevel -gt $MaxLevel) {
        throw "MinLevel ($MinLevel) cannot exceed MaxLevel ($MaxLevel)."
    }

    # Lazy-load Pester — deferred at import time for speed. The parent needs it only for the discovery pass;
    # each worker imports its own copy for the actual run.
    if (-not (Get-Module Pester)) {
        $pesterPath = Join-Path $env:RepositoryRoot 'automation/.vendor/Pester'
        Write-Verbose "Lazy-loading Pester from: $pesterPath"
        Import-Module $pesterPath -Scope Global -Force
    }

    $automationRoot = Join-Path $env:RepositoryRoot 'automation'

    # Discover every automation/<dir>/tests folder in a single .NET directory scan — one enumeration
    # instead of two Get-ChildItem passes, with no pipeline/object overhead (and fewer filesystem round
    # trips on network-backed repos, see effective-in-enterprises). Module tests run FOUNDATION-FIRST
    # (Get-ModuleTestOrder — a topological sort of the declared dependency graph), so a broken base
    # module's failures surface before the dependents that cascade from it; dot-prefixed infrastructure
    # (.internal, .scriptanalyzer) runs after, ordinally.
    $allDirs = [System.IO.Directory]::GetDirectories($automationRoot)
    [Array]::Sort($allDirs)

    $moduleTestsByName = [ordered]@{}
    $infraTestPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in $allDirs) {
        $dirName = [System.IO.Path]::GetFileName($dir)
        $isInfra = $dirName.StartsWith('.')

        # -Modules narrows the run to the named automation modules. Dot-prefixed infrastructure
        # (.internal, .scriptanalyzer) is never a named module, so it only runs in the unfiltered case.
        if ($Modules -and ($isInfra -or $dirName -notin $Modules)) {
            continue
        }

        $testsPath = [System.IO.Path]::Combine($dir, 'tests')
        if (-not [System.IO.Directory]::Exists($testsPath)) {
            continue
        }

        if ($isInfra) {
            $infraTestPaths.Add($testsPath)
        }
        else {
            $moduleTestsByName[$dirName] = $testsPath
        }
    }

    # Foundation-first module order from the dependency graph — best-effort: if the graph cannot be
    # ordered (a malformed or cyclic dependencies.yml, which its OWN tests then report), fall back to the
    # ordinal order so the suite still runs rather than the runner crashing on the config it is testing.
    $moduleOrder = try {
        Get-ModuleTestOrder
    }
    catch {
        Write-Verbose "Get-ModuleTestOrder failed ($_); falling back to ordinal module order."
        @($moduleTestsByName.Keys)
    }

    $moduleTestPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $moduleOrder) {
        if ($moduleTestsByName.Contains($name)) {
            $moduleTestPaths.Add($moduleTestsByName[$name])
            $moduleTestsByName.Remove($name)
        }
    }
    # Any discovered module the order did not name (safety) — append in the ordinal order already scanned.
    foreach ($name in @($moduleTestsByName.Keys)) {
        $moduleTestPaths.Add($moduleTestsByName[$name])
    }

    $testPaths = @($moduleTestPaths) + @($infraTestPaths)

    if (-not $testPaths) {
        if ($Modules) {
            throw "No test folders found for the requested module(s): $($Modules -join ', '). A module has tests only if it has a tests/ folder."
        }
        throw 'No test folders found'
    }

    # One discovery-only pass feeds every pre-run inspection: the tag gate below and the serial-phase split
    # (Get-TestSerialFiles) share it, so the tree is discovered once per run.
    $discovery = Get-TestDiscovery -TestPath $testPaths

    # Enforce the two mandatory tag axes (tier L0-L3 + category logic|integrity) on every test. The discovery
    # pass sees all tests regardless of -Level, so a missing/ambiguous tag fails the run even when its
    # tier would be excluded (see docs/adr/automation/test-automation.md).
    $tagViolations = Get-TestTagViolations -Discovery $discovery
    if ($tagViolations.Count -gt 0) {
        Write-Message "$($tagViolations.Count) test(s) missing a required tag (each needs exactly one tier L0-L3 + one category logic|integrity):" -ForegroundColor Red -NoHeader
        foreach ($violation in $tagViolations) {
            Write-Message "  [$($violation.Reason)] $($violation.Test)" -ForegroundColor Red -NoHeader
        }
        throw "$($tagViolations.Count) test(s) are missing a required tier/category tag — see the list above."
    }

    # Build tag filter — exclude tiers outside [MinLevel, MaxLevel] and (when -Category is given) the other
    # category, so only the requested category's tests run. ExcludeTag matches an item's own tag, so a mixed
    # file's per-Context category tags filter correctly. Shared with Test-InIsolation via Get-TestExcludeTag.
    $excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category

    # Resolve the run directory — a timestamped subfolder under the report base so each run's artifacts are
    # preserved (and cleared with the rest of out/). The shard scripts, per-shard results-shard-<N>.xml and
    # rows-shard-<N>.json, and summary.md/tests.csv all land here.
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) 'test-automation'
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $runDir = Join-Path $OutputFolder $stamp
    $i = 2
    while (Test-Path $runDir) {
        $runDir = Join-Path $OutputFolder "$stamp-$i"
        $i++
    }
    New-Item -ItemType Directory -Path $runDir -Force | Out-Null

    # Collect the run's test files in foundation-first folder order (recursing so tests/types/ is included),
    # then split off the serial files — any file containing a 'serial'-tagged test mutates state shared
    # across worker processes and runs in a final one-worker phase, alone.
    $testFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($testsPath in $testPaths) {
        $files = @([System.IO.Directory]::GetFiles($testsPath, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories))
        [Array]::Sort($files, [System.StringComparer]::Ordinal)
        foreach ($file in $files) {
            $testFiles.Add($file)
        }
    }
    if ($testFiles.Count -eq 0) {
        throw 'No test files found in the discovered tests folders.'
    }

    $serialLookup = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] (Get-TestSerialFiles -Discovery $discovery), [System.StringComparer]::OrdinalIgnoreCase)
    $parallelFiles = [System.Collections.Generic.List[string]]::new()
    $serialFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $testFiles) {
        if ($serialLookup.Contains($file)) {
            $serialFiles.Add($file)
        }
        else {
            $parallelFiles.Add($file)
        }
    }

    # Pool size: explicit -Workers, else CPU-tracked and capped (the proven shard heuristic) — never more
    # workers than files, and at least one when only serial files exist (that pool is skipped below).
    $workerCount = if ($Workers -gt 0) {
        $Workers
    }
    else {
        [Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 8))
    }
    $workerCount = [Math]::Max(1, [Math]::Min($workerCount, $parallelFiles.Count))

    # Round-robin the parallel files across the shards — spreads the heavy modules; the serial phase (when
    # present) is one extra shard scheduled after the pool completes.
    $shardFiles = @{}
    for ($shardIndex = 0; $shardIndex -lt $workerCount; $shardIndex++) {
        $shardFiles[$shardIndex] = [System.Collections.Generic.List[string]]::new()
    }
    for ($fileIndex = 0; $fileIndex -lt $parallelFiles.Count; $fileIndex++) {
        $shardFiles[$fileIndex % $workerCount].Add($parallelFiles[$fileIndex])
    }

    $shards = [System.Collections.Generic.List[object]]::new()
    for ($shardIndex = 0; $shardIndex -lt $workerCount; $shardIndex++) {
        if ($shardFiles[$shardIndex].Count -eq 0) {
            continue
        }
        $shards.Add((New-TestAutomationShardScript -ShardIndex $shardIndex -TestPath $shardFiles[$shardIndex] `
                    -RunDirectory $runDir -ExcludeTag $excludeTags -Verbosity $Output))
    }
    $serialShard = $null
    if ($serialFiles.Count -gt 0) {
        $serialShard = New-TestAutomationShardScript -ShardIndex $workerCount -TestPath $serialFiles `
            -RunDirectory $runDir -ExcludeTag $excludeTags -Verbosity $Output
    }

    # The unit-test tripwire for tool-free levels (L0/L1) travels on each worker's own process environment —
    # never the parent's $env:. If a worker's test then launches a real process, a Mock failed to intercept
    # it — almost always a -ModuleName pointing at the wrong module — so Invoke-Executable throws inside the
    # worker instead of leaking. L2+ legitimately drive real CLIs, so it stays off there.
    $workerEnvironment = if ($MaxLevel -lt 2) {
        @{ CATZC_BLOCK_REAL_PROCESS = '1' }
    }
    else {
        $null
    }

    Write-TestAutomationHeader -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules

    # Announce before the pool blocks: each worker pays its own importer + Pester load before the first
    # Pester line streams, so silence here would read as a hang (ADR-CONSOLE:10).
    Write-Message "Running $($parallelFiles.Count) test file(s) across $($shards.Count) parallel worker(s)$(if ($serialShard) { ", then $($serialFiles.Count) serial-tagged file(s)" })..." -NoHeader

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $workerResults = [System.Collections.Generic.List[object]]::new()
    $allShards = [System.Collections.Generic.List[object]]::new()

    if ($shards.Count -gt 0) {
        $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
            [string[]] @($shards.ScriptPath), [string[]] @($shards.Label), $shards.Count,
            $workerEnvironment, $TimeoutSeconds, $false)
        $workerResults.AddRange($runner.Results)
        $allShards.AddRange($shards)
    }

    # The serial phase runs after the pool, alone — its files mutate state the parallel workers must not see
    # changing underneath them.
    if ($serialShard) {
        Write-Message "Serial phase: $($serialFiles.Count) serial-tagged file(s) in one worker..." -NoHeader
        $serialRunner = [Catzc.Base.QualityGates.PesterRunner]::Run(
            [string[]] @($serialShard.ScriptPath), [string[]] @($serialShard.Label), 1,
            $workerEnvironment, $TimeoutSeconds, $false)
        $workerResults.AddRange($serialRunner.Results)
        $allShards.Add($serialShard)
    }
    $stopwatch.Stop()

    # Aggregate the rows sidecars, in shard order. A worker that exited outside {0,1} or never wrote its
    # sidecar crashed before finishing its run — fail loudly naming the shard rather than reporting a
    # partial run as the whole truth.
    $rows = [System.Collections.Generic.List[object]]::new()
    $failedShardLabels = [System.Collections.Generic.List[string]]::new()
    for ($shardIndex = 0; $shardIndex -lt $allShards.Count; $shardIndex++) {
        $shard = $allShards[$shardIndex]
        $workerResult = $workerResults[$shardIndex]

        if ($workerResult.ExitCode -notin 0, 1 -or -not (Test-Path $shard.RowsPath)) {
            $stderrTail = "$($workerResult.Stderr)".Trim()
            throw ("Test worker '$($shard.Label)' crashed (exit $($workerResult.ExitCode)) without completing its run." +
                $(if ($stderrTail) {
                        " Stderr:`n$stderrTail"
                    }))
        }
        if ($workerResult.ExitCode -eq 1) {
            $failedShardLabels.Add($shard.Label)
        }

        foreach ($row in @([System.IO.File]::ReadAllText($shard.RowsPath) | ConvertFrom-Json)) {
            $rows.Add($row)
        }
    }
    $rows = @($rows)

    $failedCount = @($rows | Where-Object { $_.Result -eq 'Failed' }).Count
    # A shard can report failure with zero failed test rows — a container/discovery error fails its run
    # without producing a failed test. Either signal fails the aggregate verdict.
    $runResult = if ($failedCount -gt 0 -or $failedShardLabels.Count -gt 0) {
        'Failed'
    }
    else {
        'Passed'
    }

    # Validate test durations against level limits
    # L0 < 400ms, L1 < 2s (default for untagged), L2 < 120s, L3 < 30s
    $limits = @{ 'L0' = 400; 'L1' = 2000; 'L2' = 120000; 'L3' = 30000 }
    $violations = @()

    foreach ($row in $rows) {
        if ($row.Result -ne 'Passed') {
            continue
        }
        if (-not $row.Level) {
            continue
        }   # untagged/ambiguous tier — already reported by the tag check
        $limitMs = $limits[$row.Level]

        if ($row.DurationMs -gt $limitMs) {
            $violations += "[$($row.Level) > ${limitMs}ms] $($row.ExpandedName) took $($row.DurationMs)ms"
        }
    }

    $timingFailure = $false
    if ($violations.Count -gt 0) {
        # Timings are machine-dependent, so report them by default and only FAIL the run when the
        # caller opts in with -EnforceTimings. Either way the durations are written out below.
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
        foreach ($v in $violations) {
            Write-Message "  $v" -ForegroundColor $color -NoHeader
        }
        Write-Message 'Tag slow tests with a higher level or optimize them.' -NoHeader
        Write-Footer -ForegroundColor $color
        $timingFailure = [bool]$EnforceTimings
    }

    # Persist the run report (summary.md + tests.csv) beside the per-shard results-shard-<N>.xml — written
    # here, before any throw, so a failing run still produces it. Best-effort: a rendering error must never
    # mask the outcome.
    try {
        Write-TestAutomationReport -Rows $rows -OutputFolder $runDir -Level $MaxLevel -Limits $limits `
            -RunResult $runResult -DurationSeconds $stopwatch.Elapsed.TotalSeconds -TimingsEnforced:$EnforceTimings
        Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $runDir -Leaf) -Encoding utf8
        Write-Message '' -NoHeader
        Write-Message "Test report: $runDir" -ForegroundColor Cyan -NoHeader
    }
    catch {
        Write-Message "Could not write test report to ${runDir}: $_" -ForegroundColor Yellow -NoHeader
    }

    # Final section: what was skipped (a self-skip, with its reason) or not run (excluded by this run's
    # tier/category scope). Best-effort — a rendering error here must never mask the run outcome below.
    try {
        Write-TestAutomationSkipReport -Rows $rows -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category
    }
    catch {
        Write-Message "Could not render the skip report: $_" -ForegroundColor Yellow -NoHeader
    }

    if ($PassThru) {
        [pscustomobject]@{
            Result          = $runResult
            TotalCount      = $rows.Count
            PassedCount     = @($rows | Where-Object { $_.Result -eq 'Passed' }).Count
            FailedCount     = $failedCount
            SkippedCount    = @($rows | Where-Object { $_.Result -eq 'Skipped' }).Count
            NotRunCount     = @($rows | Where-Object { $_.Result -eq 'NotRun' }).Count
            DurationSeconds = [math]::Round($stopwatch.Elapsed.TotalSeconds, 2)
            Rows            = $rows
            RunDirectory    = $runDir
            Shards          = @($allShards)
        }
    }
    elseif ($runResult -ne 'Passed' -or $timingFailure) {
        # The failure gets its own red banner (a self-contained box) before the throw, so the outcome reads at
        # a glance above the raw error.
        $failureText = if ($failedCount -gt 0) {
            "$failedCount test(s) failed"
        }
        elseif ($failedShardLabels.Count -gt 0) {
            "worker(s) $($failedShardLabels -join ', ') reported a failed run with no failed tests (a container/discovery error — see the output above)"
        }
        else {
            "$($violations.Count) test(s) exceeded their level time limit (-EnforceTimings)"
        }
        Write-Header "Test Automation FAILED — $failureText" -ForegroundColor Red
        throw "Test-Automation failed: $failureText"
    }
}
