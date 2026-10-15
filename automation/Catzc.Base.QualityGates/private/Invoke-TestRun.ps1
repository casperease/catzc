<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#26
      - ADR-AUTO-TEST#30
      - ADR-AUTO-TEST#31
      - ADR-AUTO-TEST#44
      - ADR-PWSH-ANNOUNCE#6
      - ADR-PWSH-PARAM#4
      - ADR-REPO-PROTGLOB#9
  config:
    synopsis: Performs one test run through the parallel harness — the shared core of Test-Automation and Test-CatzcBuild.
    description: |-
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
    parameters:
      EntryPoint: |-
        The entry point's command name: 'Test-Automation' or 'Test-CatzcBuild'. Its key names the default report folder
        (out/test-automation, out/test-catzc-build) and prefixes the protection key.
      Title: The banner title (Write-TestAutomationHeader).
      MinLevel: The lowest tier asked for; it must not exceed MaxLevel (Test-Automation's -MinLevel).
      MaxLevel: 'The highest tier asked for; the run''s location caps it (Resolve-TestRunMaxLevel): a snapshot never runs L3.'
      Modules: The modules whose tests/ folders run; empty runs every module plus the dot-prefixed infrastructure.
      Category: 'Logic, Integrity or Both: which category of tests runs (Test-Automation''s -Category).'
      Workers: Explicit pool size; 0 sizes automatically (Test-Automation's -Workers).
      GreedyGroupSize: Greedy files run side by side in groups of this size; 0 reads greedy_group_size from test-policy.yml.
      TimeoutSeconds: The entry point's own limit (its [TimeLimit] through Get-TimeoutSeconds -Command); no default here.
      Output: 'Pester output verbosity: Detailed, Normal, Minimal or Diagnostic (Test-Automation''s -Output).'
      PassThru: Return the aggregated per-test rows and the shard descriptors (Test-Automation's -PassThru).
      EnforceTimings: Fail the run when a test is over its time limit; by default over-limit tests are only reported (Test-Automation's -EnforceTimings).
      Rule: Narrows the run to the tests that cite these ADR rules (Test-Automation's -Rule).
      Suite: A test suite's name, when -Modules was resolved from one (Test-Automation -Suite); the context block names it.
      OutputFolder: Report base; empty resolves to <out>/<entry point in lowercase>.
      OptOutTag: 'Opt-out tags of this test run: tests carrying one are excluded, counted, and listed — never silently.'
      EntryScript: The script each worker dot-sources to load the modules; empty is the source importer.
      EntryParameter: Named arguments for -EntryScript.
      Isolated: Run in a snapshot of the working folder even when it is free (Enter-TestRunLocation).
      KeepSandbox: Keep the snapshot (when the run used one) after the run, for a post-mortem.
---
#>

function Invoke-TestRun {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = '-OutputFolder is forwarded empty by every entry point that got none, and its default is keyed by the entry point the body resolves; an explicit empty argument would override a declared default (ADR-PWSH-PARAM#4)')]
    [CmdletBinding()]
    param(
        [ValidateSet('Test-Automation', 'Test-CatzcBuild')]
        [string] $EntryPoint = 'Test-Automation',

        [string] $Title = 'Test Automation',

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MaxLevel = 3,

        [AllowEmptyCollection()]
        [string[]] $Modules = @(),

        [ValidateSet('Logic', 'Integrity', 'Both')]
        [string] $Category = 'Both',

        [ValidateRange(0, 64)]
        [int] $Workers = 0,

        [ValidateRange(0, 64)]
        [int] $GreedyGroupSize = 0,

        [Parameter(Mandatory)]
        [ValidateRange(60, 86400)]
        [int] $TimeoutSeconds,

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [switch] $PassThru,

        [switch] $EnforceTimings,

        [AllowEmptyCollection()]
        [string[]] $Rule = @(),

        [string] $Suite,

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
    # Liveness dots: discovery runs before the banner and takes a while, so each stage shows a dot.
    # [comment:26](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment26)
    Write-Message '.' -NoHeader -NoNewline

    # The run's tests folders, foundation-first — module dependency order, dot-prefixed infrastructure last...
    # [comment:27](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment27)
    $testPaths = @(Get-TestAutomationTestPaths -Modules $Modules)
    Write-Message '.' -NoHeader -NoNewline

    if (-not $testPaths) {
        if ($Modules) {
            throw "No test folders found for the requested module(s): $($Modules -join ', '). A module has tests only if it has a tests/ folder."
        }
        throw 'No test folders found'
    }

    # One discovery-only pass feeds every pre-run inspection: the tag check below and the phase split...
    # [comment:28](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment28)
    $discovery = Get-TestDiscovery -TestPath $testPaths
    Write-Message '.' -NoHeader -NoNewline

    # Enforce the two mandatory tag axes on every test, regardless of -Level (Assert-TestTagGate).
    Assert-TestTagGate -Discovery $discovery

    # Resolve the run directory — a timestamped subfolder under the report base so each run's artifacts are preserved...
    # [comment:29](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment29)
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) $entryPointKey
    }
    # Earlier runs whose owning process died never reached their finally: mark them 'abandoned' rather than leave...
    # [comment:30](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment30)
    Set-AbandonedTestRun -OutputFolder $OutputFolder | Out-Null
    $runDir = New-TestAutomationRunDirectory -OutputFolder $OutputFolder

    # Claim the run's location before anything is filtered (Enter-TestRunLocation; it decides the top tier); the...
    # [comment:31](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment31)
    $location = Enter-TestRunLocation -EntryPoint $EntryPoint -RunDirectory $runDir -Isolated:$Isolated -KeepSandbox:$KeepSandbox
    $runStartedAt = [DateTimeOffset]::UtcNow.ToString('o')
    $manifestStatus = 'crashed'
    $failedCount = 0
    $failedShardLabels = @()
    $workerRun = $null
    $optOutExcludedTests = @()
    $context = $null

    # try/finally: the location is released and the terminal manifest stamped on every exit path — pass, fail, or crash.
    # [comment:32](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment32)
    try {
        $requestedMaxLevel = $MaxLevel
        $MaxLevel = Resolve-TestRunMaxLevel -Location $location -Requested $MaxLevel -MinLevel $MinLevel

        # The run's context — what it is and where it runs — printed under the banner and recorded in run.json...
        # [comment:33](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment33)
        $context = Get-TestRunContext -EntryPoint $EntryPoint -EntryScript $EntryScript -Location $location -MinLevel $MinLevel `
            -RequestedMaxLevel $requestedMaxLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Suite $Suite -Rule $Rule

        # Build tag filter — exclude tiers outside [MinLevel, MaxLevel] and (when -Category is given) the other...
        # [comment:34](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment34)
        $excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category

        # The run's self-describing state record (run.json): stamped 'running' now, and terminally...
        # [comment:35](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment35)
        Write-TestRunManifest -RunDirectory $runDir -Manifest ([ordered]@{
                status     = 'running'
                startedAt  = $runStartedAt
                ownerPid   = $PID
                ownerStart = [Catzc.Base.QualityGates.WorkerParentWatch]::CurrentStartTicks()
                minLevel   = $MinLevel
                maxLevel   = $MaxLevel
                category   = $Category
                modules    = @($Modules)
                context    = $context
            }) | Out-Null

        # The work-list: every test file, narrowed by -Rule, by tier and category scope, and by the opt-out tag...
        # [comment:36](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment36)
        $selection = Select-TestRunFiles -TestPath $testPaths -Discovery $discovery -Rule $Rule -ExcludeTag $excludeTags `
            -OptOutTag $OptOutTag -RunDirectory $runDir -EntryPoint $EntryPoint
        $testFiles = @($selection.Files)
        $excludeTags = @($selection.ExcludeTag)
        $optOutExcludedTests = @($selection.OptOutExcludedTests)

        # Three execution phases — parallel shards, greedy single-file shards, strict serial (see...
        # [comment:37](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment37)
        $phases = Split-TestAutomationFiles -Discovery $discovery -TestFiles $testFiles
        $parallelFiles = @($phases.Parallel)
        $greedyFiles = @($phases.Greedy)
        $serialFiles = @($phases.Serial)

        # Per-module protection: units whose composite identity is unchanged since their last green run this session...
        # [comment:38](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment38)
        $protectionKey = "$entryPointKey|L$MinLevel-L$MaxLevel|$Category|$($Rule -join ',')"
        $protectionPlan = Select-ProtectedTestFile -ParallelFiles @($parallelFiles) -GreedyFiles @($greedyFiles) `
            -SerialFiles @($serialFiles) -Discovery $discovery -ProtectionKey $protectionKey
        $parallelFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.ParallelFiles)
        $greedyFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.GreedyFiles)
        $serialFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.SerialFiles)
        $protectedModules = @($protectionPlan.ProtectedModules)
        Write-Message '.' -NoHeader -NoNewline

        # The unit-test tripwire for tool-free levels (L0/L1) travels on each worker's own process environment —...
        # [comment:39](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment39)
        $workerEnvironment = if ($MaxLevel -lt 2) {
            @{ CATZC_BLOCK_REAL_PROCESS = '1' }
        }
        else {
            $null
        }

        Write-Message '' -NoHeader   # ends the dot line
        Write-TestAutomationHeader -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Title $Title
        Write-TestRunContext -Context $context

        # Shard, run the pool (then the greedy and serial phases), and aggregate the row sidecars — the engine.
        # [comment:40](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment40)
        $workerRun = if (($parallelFiles.Count + $greedyFiles.Count + $serialFiles.Count) -eq 0) {
            $nothingToRun = if ($testFiles.Count -eq 0) {
                "No test in scope at L$MinLevel-L$MaxLevel — nothing to run."
            }
            else {
                'Every module in scope is protected — nothing to run.'
            }
            Write-Message $nothingToRun -ForegroundColor Yellow
            [pscustomobject]@{ Rows = @(); Files = @(); FailedShardLabels = @(); DurationSeconds = 0.0; Shards = @(); WorkerSummaries = @(); Location = $null }
        }
        else {
            Invoke-TestAutomationWorkers -ParallelFiles @($parallelFiles) -GreedyFiles @($greedyFiles) `
                -SerialFiles @($serialFiles) -Location $location `
                -RunDirectory $runDir -ExcludeTag $excludeTags -IncludeTag $Rule -Verbosity $Output -Workers $Workers -GreedyGroupSize $GreedyGroupSize `
                -TimeoutSeconds $TimeoutSeconds -WorkerEnvironment $workerEnvironment `
                -EntryScript $EntryScript -EntryParameter $EntryParameter
        }
        $rows = @($workerRun.Rows)
        $failedShardLabels = @($workerRun.FailedShardLabels)
        Write-TestAutomationWorkerSummary -WorkerSummaries @($workerRun.WorkerSummaries) -DurationSeconds $workerRun.DurationSeconds

        # Promote protection for every candidate unit that came back green — per-module attribution over the rows,...
        # [comment:41](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment41)
        Protect-TestedModule -Candidates @($protectionPlan.Candidates) -Rows $rows `
            -FailedShardLabels $failedShardLabels -ProtectionKey $protectionKey

        # The scope filter's dropped files report their tests as NotRun, once, after protection (which promotes only...
        # [comment:42](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment42)
        $rows = @($rows) + @($selection.OutOfScopeRows)

        $failedCount = @($rows | Where-Object { $_.Result -eq 'Failed' }).Count
        # A shard can report failure with zero failed test rows — a container/discovery error fails its run without...
        # [comment:43](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment43)
        $runResult = if ($failedCount -gt 0 -or $failedShardLabels.Count -gt 0) {
            'Failed'
        }
        else {
            'Passed'
        }
        $manifestStatus = $runResult.ToLowerInvariant()

        # Validate test durations against the per-level limits and render the over-limit section...
        # [comment:44](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment44)
        $testTimeLimits = Get-TestTimeLimits
        $limits = $testTimeLimits.LevelMs
        $timingFailure = Write-TestAutomationTimingReport -Rows $rows -Limits $limits -EnforceTimings:$EnforceTimings
        # A devbox run that outlasts its whole-run budget fails.
        # [comment:45](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment45)
        $budgetFailure = Test-TestRunOverBudget -DurationSeconds $workerRun.DurationSeconds -BudgetSeconds $testTimeLimits.RunSeconds
        if ($timingFailure -or $budgetFailure) {
            $manifestStatus = 'failed'
        }

        # Persist summary.md/tests.csv + latest.txt and render the skip report — best-effort, never masking the run...
        # [comment:46](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment46)

        Write-TestAutomationArtifacts -Rows $rows -RunDirectory $runDir -OutputFolder $OutputFolder `
            -MaxLevel $MaxLevel -Limits $limits -RunResult $runResult -DurationSeconds $workerRun.DurationSeconds `
            -EnforceTimings:$EnforceTimings -MinLevel $MinLevel -Category $Category `
            -Location (Get-TestRunLocationSummary -Location $workerRun.Location).Text

        $passedCount = @($rows | Where-Object { $_.Result -eq 'Passed' }).Count
        $skippedCount = @($rows | Where-Object { $_.Result -eq 'Skipped' }).Count

        # Derive the verdict (Result + one-line reason) once; the closing banner and the failure throw both consume...
        # [comment:47](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment47)
        $verdict = Get-TestAutomationVerdict -Rows $rows -Limits $limits -RunResult $runResult `
            -FailedCount $failedCount -FailedShardLabels $failedShardLabels -TimingFailure:$timingFailure `
            -BudgetFailure:$budgetFailure -RunBudgetSeconds $testTimeLimits.RunSeconds `
            -PassedCount $passedCount -SkippedCount $skippedCount -DurationSeconds $workerRun.DurationSeconds

        # Every failed test's and failed file's message, right before the verdict (nothing on a green run).
        Write-TestRunFailures -Rows $rows -Files @($workerRun.Files)
        # The closing bracket prints on every exit path — pass, fail, and -PassThru alike — so a run is always...
        # [comment:48](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment48)
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
        elseif ($runResult -ne 'Passed' -or $timingFailure -or $budgetFailure) {
            throw "$EntryPoint failed: $($verdict.Summary)"
        }
    }
    finally {
        $finalManifest = New-TestRunFinalManifest -Status $manifestStatus -StartedAt $runStartedAt -MinLevel $MinLevel `
            -MaxLevel $MaxLevel -Category $Category -Modules $Modules -FailedCount $failedCount `
            -FailedShardLabels $failedShardLabels -Context $context -WorkerRun $workerRun -OptOutTag $OptOutTag `
            -OptOutExcludedCount (@($optOutExcludedTests).Count)
        try {
            Write-TestRunManifest -RunDirectory $runDir -Manifest $finalManifest | Out-Null
        }
        finally {
            Exit-TestRunLocation -Location $location
        }
    }
}
