<#
.SYNOPSIS
    Performs one test run through the parallel harness — the shared core of Test-Automation and Test-CatzcBuild.
.DESCRIPTION
    The harness both runs share ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)):
    lazy-load Pester from the code root, scan the selected
    modules' tests/ folders, discover once, enforce the mandatory tag axes, build the tier/category filter, open
    a timestamped run directory with its run.json state record, split the files into parallel/greedy/serial
    phases, apply per-module protection, run the workers, and write the timing check, reports, verdict, and
    -PassThru summary. The two test runs differ only in what they pass in:

    - the entry script each shard worker dot-sources (-EntryScript/-EntryParameter, empty for the source
      importer; the build's Import-Catzc.ps1 for the build run) — the one seam;
    - an opt-out tag (-OptOutTag 'source-only' for the build run): its tests are excluded from the run
      and counted and listed on the console and in excluded-tests.csv in the run directory
      ([ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31));
    - the entry point's name (-EntryPoint), which names the default report folder under out/, the protection key,
      and the failure message; and the banner title (-Title).
.PARAMETER EntryPoint
    The entry point's command name: 'Test-Automation' or 'Test-CatzcBuild'. Its key names the default report folder
    (out/test-automation, out/test-catzc-build) and prefixes the protection key.
.PARAMETER Title
    The banner title (Write-TestAutomationHeader).
.PARAMETER Modules
    The modules whose tests/ folders run; empty runs every module plus the dot-prefixed infrastructure.
.PARAMETER OptOutTag
    Opt-out tags of this test run: tests carrying one are excluded, counted, and listed — never silently.
.PARAMETER EntryScript
    The script each worker dot-sources to load the modules; empty is the source importer.
.PARAMETER EntryParameter
    Named arguments for -EntryScript.
.PARAMETER OutputFolder
    Report base; empty resolves to <out>/<entry point in lowercase>.
.PARAMETER Isolated
    Run in a snapshot of the working folder even when it is free (Enter-TestRunSlot).
.PARAMETER KeepSandbox
    Keep the snapshot (when the run used one) after the run, for a post-mortem.
.NOTES
    The remaining parameters are Test-Automation's own, passed through unchanged — see its help.
#>
function Invoke-TestRun {
    [CmdletBinding()]
    param(
        [ValidateSet('Test-Automation', 'Test-CatzcBuild')]
        [string] $EntryPoint = 'Test-Automation',

        [string] $Title = 'Test Automation',

        [ValidateSet(0, 1, 2, 3)]
        [int] $MinLevel = 0,

        # The highest tier asked for; the slot caps it (Resolve-TestRunMaxLevel): a snapshot never runs L3.
        [ValidateSet(0, 1, 2, 3)]
        [int] $MaxLevel = 3,

        [AllowEmptyCollection()]
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

        [AllowEmptyCollection()]
        [string[]] $Rule = @(),

        [string] $OutputFolder,

        [AllowEmptyCollection()]
        [string[]] $OptOutTag = @(),

        [string] $EntryScript,

        [hashtable] $EntryParameter = @{},

        [switch] $Isolated,

        [switch] $KeepSandbox
    )

    # The entry point's key: its default report folder under out/ and its protection-key prefix.
    $entryPointKey = @{ 'Test-Automation' = 'test-automation'; 'Test-CatzcBuild' = 'test-catzc-build' }[$EntryPoint]

    # The parent needs Pester only for the discovery pass; each worker imports its own copy for the actual run.
    Import-VendoredPester

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

    # Enforce the two mandatory tag axes on every test, regardless of -Level (Assert-TestTagGate).
    Assert-TestTagGate -Discovery $discovery

    # Resolve the run directory — a timestamped subfolder under the report base so each run's artifacts are
    # preserved (and cleared with the rest of out/). The shard scripts, per-shard results-shard-<N>.xml and
    # rows-shard-<N>.json, and summary.md/tests.csv all land here.
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) $entryPointKey
    }
    # Earlier runs whose owning process died never reached their finally: mark them 'abandoned' rather than
    # leave them claiming 'running' (Set-AbandonedTestRun reads the owner recorded below).
    Set-AbandonedTestRun -OutputFolder $OutputFolder | Out-Null
    $runDir = New-TestAutomationRunDirectory -OutputFolder $OutputFolder

    # Claim the slot before anything is filtered (Enter-TestRunSlot; it decides the top tier); the finally releases it.
    $slot = Enter-TestRunSlot -EntryPoint $EntryPoint -RunDirectory $runDir -Isolated:$Isolated
    $runStartedAt = [DateTimeOffset]::UtcNow.ToString('o')
    $manifestStatus = 'crashed'
    $failedCount = 0
    $failedShardLabels = @()
    $workerRun = $null
    $optOutExcludedTests = @()

    # try/finally: the slot is released and the terminal manifest stamped on every exit path — pass, fail, or crash.
    # The stamp is what makes run.json trustworthy, so it sits in the finally, not in a best-effort catch.
    try {
        $MaxLevel = Resolve-TestRunMaxLevel -Slot $slot -Requested $MaxLevel -MinLevel $MinLevel

        # Build tag filter — exclude tiers outside [MinLevel, MaxLevel] and (when -Category is given) the other
        # category, so only the requested category's tests run. ExcludeTag matches an item's own tag, so a mixed
        # file's per-Context category tags filter correctly. Shared with Test-InIsolation via Get-TestExcludeTag.
        $excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category

        # The run's self-describing state record (run.json): stamped 'running' now, and terminally
        # ('passed'|'failed'|'crashed') in the finally below — so a reader never has to infer completeness from
        # which artifact files happen to exist yet (Write-TestRunManifest; the write is atomic). The owner (PID
        # and start time) lets a later run tell a live run from one whose process died ('abandoned').
        Write-TestRunManifest -RunDirectory $runDir -Manifest ([ordered]@{
                status     = 'running'
                startedAt  = $runStartedAt
                ownerPid   = $PID
                ownerStart = [Catzc.Base.QualityGates.WorkerParentWatch]::CurrentStartTicks()
                minLevel   = $MinLevel
                maxLevel   = $MaxLevel
                category   = $Category
                modules    = @($Modules)
            }) | Out-Null

        # The run's test files in foundation-first folder order (Get-TestAutomationTestFiles owns the scan).
        $testFiles = [System.Collections.Generic.List[string]]::new([string[]] (Get-TestAutomationTestFiles -TestPath $testPaths))

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

        # The run's opt-out tag (the build run's 'source-only',
        # [ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31)): exclude its tests from the
        # run, drop files left with nothing to run, and count and list every excluded test — never silently.
        if ($OptOutTag.Count -gt 0) {
            $optOutExclusion = Get-TestOptOutExclusion -Discovery $discovery -Tag $OptOutTag `
                -ExcludeTag $excludeTags -TestFiles @($testFiles)
            $optOutExcludedTests = @($optOutExclusion.Tests)
            $excludeTags = @($excludeTags) + @($OptOutTag)
            $testFiles = [System.Collections.Generic.List[string]]::new([string[]] @($optOutExclusion.RemainingFiles))
            Write-TestOptOutExclusion -Tests $optOutExcludedTests -Tag $OptOutTag -RunDirectory $runDir
            if ($testFiles.Count -eq 0) {
                throw "Every test in scope carries $($OptOutTag -join ', ') — nothing to run in $EntryPoint."
            }
        }

        # Three execution phases — parallel shards, greedy single-file shards, strict serial (see
        # Split-TestAutomationFiles / [ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)).
        $phases = Split-TestAutomationFiles -Discovery $discovery -TestFiles $testFiles
        $parallelFiles = @($phases.Parallel)
        $greedyFiles = @($phases.Greedy)
        $serialFiles = @($phases.Serial)

        # Per-module protection
        # ([ADR-REPO-PROTGLOB#9](/docs/adr/automation/protected-globs.md#rule-adr-repo-protglob9)): units whose
        # composite identity is unchanged since their last
        # green run this session are dropped from the work-list here in the orchestrator (workers never see
        # the map; in a pipeline the selection is a pass-through). The key carries the entry point and the run
        # parameters, so an L0-L1 green never skips an L2 run and a green source run never skips the build run.
        $protectionKey = "$entryPointKey|L$MinLevel-L$MaxLevel|$Category|$($Rule -join ',')"
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

        Write-TestAutomationHeader -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Title $Title

        # Shard, run the pool (then the greedy and serial phases), and aggregate the row sidecars — the engine.
        # When protection drained the whole work-list, there is nothing to execute: the run is vacuously green.
        $workerRun = if (($parallelFiles.Count + $greedyFiles.Count + $serialFiles.Count) -eq 0) {
            Write-Message 'Every module in scope is protected — nothing to run.' -ForegroundColor Yellow
            [pscustomobject]@{ Rows = @(); FailedShardLabels = @(); DurationSeconds = 0.0; Shards = @(); WorkerSummaries = @(); Location = $null }
        }
        else {
            Invoke-TestAutomationWorkers -ParallelFiles @($parallelFiles) -GreedyFiles @($greedyFiles) `
                -SerialFiles @($serialFiles) -Slot $slot `
                -RunDirectory $runDir -ExcludeTag $excludeTags -IncludeTag $Rule -Verbosity $Output -Workers $Workers `
                -TimeoutSeconds $TimeoutSeconds -WorkerEnvironment $workerEnvironment `
                -EntryScript $EntryScript -EntryParameter $EntryParameter `
                -KeepSandbox:$KeepSandbox
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
            -EnforceTimings:$EnforceTimings -MinLevel $MinLevel -Category $Category `
            -Location (Get-TestRunLocationSummary -Location $workerRun.Location).Text

        $passedCount = @($rows | Where-Object { $_.Result -eq 'Passed' }).Count
        $skippedCount = @($rows | Where-Object { $_.Result -eq 'Skipped' }).Count

        # Derive the verdict (Result + one-line reason) once; the closing banner and the failure throw both
        # consume it, so the reason wording lives in exactly one place.
        $verdict = Get-TestAutomationVerdict -Rows $rows -Limits $limits -RunResult $runResult `
            -FailedCount $failedCount -FailedShardLabels $failedShardLabels -TimingFailure:$timingFailure `
            -PassedCount $passedCount -SkippedCount $skippedCount -DurationSeconds $workerRun.DurationSeconds

        # The closing bracket prints on every exit path — pass, fail, and -PassThru alike — so a run is always
        # visually closed. Console UX is orthogonal to the -PassThru data return (banner on the information
        # stream, object on the output stream), and orthogonal to the throw that still fires last on a fail.
        Write-TestAutomationVerdict -Result $verdict.Result -Summary $verdict.Summary `
            -PassedCount $passedCount -FailedCount $failedCount -SkippedCount $skippedCount `
            -DurationSeconds $workerRun.DurationSeconds -ReportPath $runDir

        if ($PassThru) {
            $summary = [pscustomobject]@{
                Result           = $runResult
                TotalCount       = $rows.Count
                PassedCount      = $passedCount
                FailedCount      = $failedCount
                SkippedCount     = $skippedCount
                NotRunCount      = @($rows | Where-Object { $_.Result -eq 'NotRun' }).Count
                DurationSeconds  = [math]::Round($workerRun.DurationSeconds, 2)
                Rows             = $rows
                RunDirectory     = $runDir
                Shards           = @($workerRun.Shards)
                ProtectedModules = @($protectedModules)
            }
            if ($OptOutTag.Count -gt 0) {
                $summary | Add-Member -NotePropertyName ExcludedTests -NotePropertyValue @($optOutExcludedTests)
            }
            $summary
        }
        elseif ($runResult -ne 'Passed' -or $timingFailure) {
            throw "$EntryPoint failed: $($verdict.Summary)"
        }
    }
    finally {
        $finalManifest = [ordered]@{
            status            = $manifestStatus
            startedAt         = $runStartedAt
            finishedAt        = [DateTimeOffset]::UtcNow.ToString('o')
            minLevel          = $MinLevel
            maxLevel          = $MaxLevel
            category          = $Category
            modules           = @($Modules)
            failedCount       = $failedCount
            failedShardLabels = @($failedShardLabels)
        }
        # What only the worker run knows: shard exit codes, duration, and where it executed (with a snapshot's provenance).
        $workerEntries = ConvertTo-TestRunManifestEntry -WorkerRun $workerRun
        foreach ($key in $workerEntries.Keys) {
            $finalManifest[$key] = $workerEntries[$key]
        }
        if ($OptOutTag.Count -gt 0) {
            $finalManifest['optOutTag'] = @($OptOutTag)
            $finalManifest['optOutExcludedCount'] = @($optOutExcludedTests).Count
        }
        try {
            Write-TestRunManifest -RunDirectory $runDir -Manifest $finalManifest | Out-Null
        }
        finally {
            Exit-TestRunSlot -Slot $slot -KeepSandbox:$KeepSandbox
        }
    }
}
