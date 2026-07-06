<#
.SYNOPSIS
    Runs all Pester tests found across automation modules, sharded across parallel worker processes.
.DESCRIPTION
    The harness parallelizes at whole-file granularity: the run's test files are round-robin sharded across
    worker processes (pwsh children driven by the PesterRunner type), each of which imports the repository,
    runs its shard, writes results-shard-<N>.xml plus a rows-shard-<N>.json sidecar, and streams its output
    through the pool — the first unfinished worker is live, later workers buffer and replay in submission
    order, so the console reads sequentially while the wall clock runs in parallel. Files containing a
    'greedy'-tagged test (tests that fan out heavy machine load of their own but share no state) follow as
    single-file shards through the pool, one file per worker slot; files containing a 'serial'-tagged test
    (tests that mutate state shared across processes) run last in a one-worker phase, alone — see
    ADR-TEST:26. Pester executes tests sequentially within a worker; a single file never splits across
    workers.
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
    automatically — max(1, ProcessorCount / 4), never more than the file count: past that the box is
    throughput-saturated, so extra workers only inflate per-test wall clock against the level time limits.
    1 runs everything through a single worker process (serialized, but still process-isolated). The serial
    phase always runs one worker, after the parallel shards complete.
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
.PARAMETER Rule
    Run only the tests that cite one of these ADR rules (the provenance filter) — e.g. `-Rule ADR-ERROR#3`.
    Each value is a citation in `ADR-<CODE>#<n>` form. The run narrows to the files carrying a matching test
    and, within them, to the cited tests (Pester tag include). Composes with -Level/-Category/-Modules. It is
    the executable companion of the rule-coverage report: find a rule's tests, then run just them.
.PARAMETER Marker
    Run a marker's declared blast radius: the named globset's `verify:` scope in globs.yml resolves to
    the module list and tier to run (ADR-GLOBS:7) — "which tests do I need to run to verify a change in
    that area-of-control". Mutually exclusive with -Modules; a marker without a verify scope throws with
    the remedy. Find the touched markers for a change with Get-MarkerBlastRadius.
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
    Test-Automation -Rule ADR-ERROR#3   # run only the tests that cite ADR-ERROR#3
.EXAMPLE
    Test-Automation -Marker foundation   # run the foundation unit's declared verify scope (globs.yml)
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

        [ValidatePattern('^ADR-[A-Z]+#\d+$')]
        [string[]] $Rule = @(),

        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Marker,

        [string] $OutputFolder
    )

    if ($MinLevel -gt $MaxLevel) {
        throw "MinLevel ($MinLevel) cannot exceed MaxLevel ($MaxLevel)."
    }

    # -Marker: run the named area-of-control's declared blast radius — its globs.yml verify scope resolves
    # to the module list and tier (Resolve-MarkerVerify, ADR-GLOBS:7).
    if ($Marker) {
        if ($Modules.Count -gt 0) {
            throw 'Pass -Marker or -Modules, not both — a marker resolves its own module scope.'
        }
        $markerScope = Resolve-MarkerVerify -Name $Marker
        $Modules = @($markerScope.Modules)
        $MaxLevel = $markerScope.Level
    }

    # Lazy-load Pester — deferred at import time for speed. The parent needs it only for the discovery pass;
    # each worker imports its own copy for the actual run.
    if (-not (Get-Module Pester)) {
        $pesterPath = Join-Path $env:RepositoryRoot 'automation/.vendor/Pester'
        Write-Verbose "Lazy-loading Pester from: $pesterPath"
        Import-Module $pesterPath -Scope Global -Force
    }

    # The run's tests folders, foundation-first — module dependency order, dot-prefixed infrastructure last
    # (Get-TestAutomationTestPaths owns the scan and the ordering).
    $testPaths = @(Get-TestAutomationTestPaths -Modules $Modules)

    if (-not $testPaths) {
        if ($Modules) {
            throw "No test folders found for the requested module(s): $($Modules -join ', '). A module has tests only if it has a tests/ folder."
        }
        throw 'No test folders found'
    }

    # One discovery-only pass feeds every pre-run inspection: the tag gate below and the phase split
    # (Split-TestAutomationFiles) share it, so the tree is discovered once per run.
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
    $runDir = New-TestAutomationRunDirectory -OutputFolder $OutputFolder

    # The run's self-describing state record (run.json): stamped 'running' now, and terminally
    # ('passed'|'failed'|'crashed') in the finally below — so a reader never has to infer completeness from
    # which artifact files happen to exist yet (Write-TestRunManifest; the write is atomic).
    $runStartedAt = [DateTimeOffset]::UtcNow.ToString('o')
    Write-TestRunManifest -RunDirectory $runDir -Manifest ([ordered]@{
            status    = 'running'
            startedAt = $runStartedAt
            minLevel  = $MinLevel
            maxLevel  = $MaxLevel
            category  = $Category
            modules   = @($Modules)
        }) | Out-Null

    # Everything below runs inside try/finally so the terminal manifest is stamped on every exit path —
    # pass, fail (the throw at the tail), or crash (any unexpected throw). The stamp must never be skipped:
    # it is what makes run.json trustworthy, so it sits in the finally, not in a best-effort catch.
    $manifestStatus = 'crashed'
    $failedCount = 0
    $failedShardLabels = @()
    $workerRun = $null
    try {
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

        # -Rule: narrow the work-list to the files carrying a test that cites one of the given ADR rules (the
        # provenance filter). The worker also filters within a file via IncludeTag, so a file that mixes matched
        # and other tests runs only the matched ones; this keeps whole non-matching files off the work-list.
        if ($Rule.Count -gt 0) {
            $testFiles = [System.Collections.Generic.List[string]]::new(
                [string[]] (Select-RuleTaggedFiles -TestFile @($testFiles) -Discovery $discovery -Rule $Rule))
            if ($testFiles.Count -eq 0) {
                throw "No test cites $($Rule -join ', ') — nothing to run for -Rule."
            }
        }

        # Three execution phases — parallel shards, greedy single-file shards, strict serial (see
        # Split-TestAutomationFiles / ADR-TEST:26).
        $phases = Split-TestAutomationFiles -Discovery $discovery -TestFiles $testFiles
        $parallelFiles = @($phases.Parallel)
        $greedyFiles = @($phases.Greedy)
        $serialFiles = @($phases.Serial)

        # Per-module protection (ADR-PROTGLOB:9): units whose composite identity is unchanged since their last
        # green run this session are dropped from the work-list here in the orchestrator (workers never see
        # the map; in a pipeline the selection is a pass-through). The key carries the run parameters, so an
        # L0-L1 green never skips an L2 run.
        $protectionKey = "test-automation|L$MinLevel-L$MaxLevel|$Category|$($Rule -join ',')"
        $protectionPlan = Select-ProtectedTestFile -ParallelFiles @($parallelFiles) -GreedyFiles @($greedyFiles) `
            -SerialFiles @($serialFiles) -Discovery $discovery -ProtectionKey $protectionKey
        $parallelFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.ParallelFiles)
        $greedyFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.GreedyFiles)
        $serialFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.SerialFiles)
        $protectedModules = @($protectionPlan.ProtectedModules)

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

        # Shard, run the pool (then the greedy and serial phases), and aggregate the row sidecars — the engine.
        # When protection drained the whole work-list, there is nothing to execute: the run is vacuously green.
        $workerRun = if (($parallelFiles.Count + $greedyFiles.Count + $serialFiles.Count) -eq 0) {
            Write-Message 'Every module in scope is protected — nothing to run.' -ForegroundColor Yellow
            [pscustomobject]@{ Rows = @(); FailedShardLabels = @(); DurationSeconds = 0.0; Shards = @(); WorkerSummaries = @() }
        }
        else {
            Invoke-TestAutomationWorkers -ParallelFiles @($parallelFiles) -GreedyFiles @($greedyFiles) `
                -SerialFiles @($serialFiles) `
                -RunDirectory $runDir -ExcludeTag $excludeTags -IncludeTag $Rule -Verbosity $Output -Workers $Workers `
                -TimeoutSeconds $TimeoutSeconds -WorkerEnvironment $workerEnvironment
        }
        $rows = @($workerRun.Rows)
        $failedShardLabels = @($workerRun.FailedShardLabels)
        Write-TestAutomationWorkerSummary -WorkerSummaries @($workerRun.WorkerSummaries) -DurationSeconds $workerRun.DurationSeconds

        # Promote protection for every candidate unit that came back green — per-module attribution over the
        # rows, conservative on anything unattributable (Protect-TestedModule owns the rules).
        Protect-TestedModule -Candidates @($protectionPlan.Candidates) -Rows $rows `
            -FailedShardLabels $failedShardLabels -ProtectionKey $protectionKey

        $failedCount = @($rows | Where-Object { $_.Result -eq 'Failed' }).Count
        # A shard can report failure with zero failed test rows — a container/discovery error fails its run
        # without producing a failed test. Either signal fails the aggregate verdict.
        $runResult = if ($failedCount -gt 0 -or $failedShardLabels.Count -gt 0) {
            'Failed'
        }
        else {
            'Passed'
        }
        $manifestStatus = $runResult.ToLowerInvariant()

        # Validate test durations against the per-level limits and render the over-limit section
        # (Write-TestAutomationTimingReport): report-only by default, run-failing under -EnforceTimings.
        $limits = @{ 'L0' = 400; 'L1' = 2000; 'L2' = 120000; 'L3' = 30000 }
        $timingFailure = Write-TestAutomationTimingReport -Rows $rows -Limits $limits -EnforceTimings:$EnforceTimings
        if ($timingFailure) {
            $manifestStatus = 'failed'
        }

        # Persist summary.md/tests.csv + latest.txt and render the skip report — best-effort, never masking
        # the run outcome (Write-TestAutomationArtifacts owns the guards).
        Write-TestAutomationArtifacts -Rows $rows -RunDirectory $runDir -OutputFolder $OutputFolder `
            -MaxLevel $MaxLevel -Limits $limits -RunResult $runResult -DurationSeconds $workerRun.DurationSeconds `
            -EnforceTimings:$EnforceTimings -MinLevel $MinLevel -Category $Category

        if ($PassThru) {
            [pscustomobject]@{
                Result           = $runResult
                TotalCount       = $rows.Count
                PassedCount      = @($rows | Where-Object { $_.Result -eq 'Passed' }).Count
                FailedCount      = $failedCount
                SkippedCount     = @($rows | Where-Object { $_.Result -eq 'Skipped' }).Count
                NotRunCount      = @($rows | Where-Object { $_.Result -eq 'NotRun' }).Count
                DurationSeconds  = [math]::Round($workerRun.DurationSeconds, 2)
                Rows             = $rows
                RunDirectory     = $runDir
                Shards           = @($workerRun.Shards)
                ProtectedModules = @($protectedModules)
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
    finally {
        Write-TestRunManifest -RunDirectory $runDir -Manifest ([ordered]@{
                status            = $manifestStatus
                startedAt         = $runStartedAt
                finishedAt        = [DateTimeOffset]::UtcNow.ToString('o')
                minLevel          = $MinLevel
                maxLevel          = $MaxLevel
                category          = $Category
                modules           = @($Modules)
                failedCount       = $failedCount
                failedShardLabels = @($failedShardLabels)
                shardExitCodes    = $(if ($workerRun -and $workerRun.PSObject.Properties['ShardExitCodes']) {
                        $workerRun.ShardExitCodes
                    }
                    else {
                        @{}
                    })
                durationSeconds   = $(if ($workerRun) {
                        [math]::Round($workerRun.DurationSeconds, 2)
                    }
                    else {
                        0
                    })
            }) | Out-Null
    }
}
