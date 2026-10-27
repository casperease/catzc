function Invoke-TestRun {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '',
        Justification = '-OutputFolder is forwarded empty by every entry point that got none, and its default is keyed by the entry point the body resolves; an explicit empty argument would override a declared default (ADR-PWSH-PARAM-RESOLUTIONORDER)')]
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.TestRunResult])]
    param(
        [ValidateSet('Test-Automation', 'Test-CatzcBuild')]
        [string] $EntryPoint = 'Test-Automation',

        [string] $Title = 'Test Automation',

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0,

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MaxLevel = [Catzc.Base.Timeouts.TestTiers]::DefaultTop,

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
    # Discovery runs before the banner and takes a while, so each stage prints a liveness dot.
    Write-Message '.' -NoHeader -NoNewline

    # Foundation first: module dependency order, dot-prefixed infrastructure last.
    $testPaths = @(Get-TestAutomationTestPaths -Modules $Modules)
    Write-Message '.' -NoHeader -NoNewline

    if (-not $testPaths) {
        if ($Modules) {
            throw "No test folders found for the requested module(s): $($Modules -join ', '). A module has tests only if it has a tests/ folder."
        }
        throw 'No test folders found'
    }

    # One discovery pass feeds the tag check and the phase split.
    $discovery = Get-TestDiscovery -TestPath $testPaths
    Write-Message '.' -NoHeader -NoNewline

    # Enforce the two mandatory tag axes on every test, regardless of -Level (Assert-TestTagGate).
    Assert-TestTagGate -Discovery $discovery

    # A timestamped run folder under the report base keeps each run's artifacts.
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) $entryPointKey
    }
    # Runs whose owner died never reached their finally, so they are marked abandoned.
    Set-AbandonedTestRun -OutputFolder $OutputFolder | Out-Null
    $runDir = New-TestAutomationRunDirectory -OutputFolder $OutputFolder

    # The location is claimed before anything is filtered; the finally releases it.
    $location = Enter-TestRunLocation -EntryPoint $EntryPoint -RunDirectory $runDir -Isolated:$Isolated -KeepSandbox:$KeepSandbox
    $runStartedAt = [DateTimeOffset]::UtcNow.ToString('o')
    $manifestStatus = 'crashed'
    $failedCount = 0
    $failedShardLabels = @()
    $workerRun = $null
    $optOutExcludedTests = @()
    $context = $null

    # The finally releases the location and stamps run.json on every exit path.
    try {
        $requestedMaxLevel = $MaxLevel
        $MaxLevel = Resolve-TestRunMaxLevel -Location $location -Requested $MaxLevel -MinLevel $MinLevel

        # What the run is and where it runs: printed under the banner, recorded in run.json.
        $context = Get-TestRunContext -EntryPoint $EntryPoint -EntryScript $EntryScript -Location $location -MinLevel $MinLevel `
            -RequestedMaxLevel $requestedMaxLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Suite $Suite -Rule $Rule

        # Tiers outside the range and the other category are excluded.
        $excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category

        # Stamped running now and terminally in the finally, so no reader infers completeness.
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

        # Files dropped for scope come back as NotRun rows, reported once after protection.
        $selection = Select-TestRunFiles -TestPath $testPaths -Discovery $discovery -Rule $Rule -ExcludeTag $excludeTags `
            -OptOutTag $OptOutTag -RunDirectory $runDir -EntryPoint $EntryPoint
        $testFiles = @($selection.Files)
        $excludeTags = @($selection.ExcludeTag)
        $optOutExcludedTests = @($selection.OptOutExcludedTests)

        # Three phases: parallel shards, greedy single-file shards, strict serial.
        $phases = Split-TestAutomationFiles -Discovery $discovery -TestFiles $testFiles
        $parallelFiles = @($phases.Parallel)
        $greedyFiles = @($phases.Greedy)
        $serialFiles = @($phases.Serial)

        # A unit whose identity is unchanged since its last green run this session is skipped.
        $protectionKey = "$entryPointKey|L$MinLevel-L$MaxLevel|$Category|$($Rule -join ',')"
        $protectionPlan = Select-ProtectedTestFile -ParallelFiles @($parallelFiles) -GreedyFiles @($greedyFiles) `
            -SerialFiles @($serialFiles) -Discovery $discovery -ProtectionKey $protectionKey
        $parallelFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.ParallelFiles)
        $greedyFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.GreedyFiles)
        $serialFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.SerialFiles)
        $protectedModules = @($protectionPlan.ProtectedModules)
        Write-Message '.' -NoHeader -NoNewline

        # The L0/L1 tripwire rides each worker's own environment: a real process there means a missed Mock.
        $workerEnvironment = @{
            CATZC_BLOCK_REAL_PROCESS = if ($MaxLevel -lt [Catzc.Base.Timeouts.TestTiers]::FirstRealProcessTier) {
                [Catzc.Base.Timeouts.TestTiers]::BlockEveryLaunch
            }
            else {
                [Catzc.Base.Timeouts.TestTiers]::BlockByTier
            }
        }

        Write-Message '' -NoHeader   # ends the dot line
        Write-TestAutomationHeader -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Title $Title
        Write-TestRunContext -Context $context

        # A work-list protection drained is vacuously green.
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

        # Green candidates are promoted, conservatively on anything unattributable.
        Protect-TestedModule -Candidates @($protectionPlan.Candidates) -Rows $rows `
            -FailedShardLabels $failedShardLabels -ProtectionKey $protectionKey

        # Out-of-scope rows join after protection, so every report reads the same rows.
        $rows = @($rows) + @($selection.OutOfScopeRows)

        $failedCount = @($rows | Where-Object { $_.Result -eq 'Failed' }).Count
        # A container error fails a shard with no failed row; either signal fails the run.
        $runResult = if ($failedCount -gt 0 -or $failedShardLabels.Count -gt 0) {
            'Failed'
        }
        else {
            'Passed'
        }
        $manifestStatus = $runResult.ToLowerInvariant()

        # Over-limit tests are reported, and fail the run only under -EnforceTimings.
        $testTimeLimits = Get-TestTimeLimits
        $limits = $testTimeLimits.LevelMs
        $timingFailure = Write-TestAutomationTimingReport -Rows $rows -Limits $limits -EnforceTimings:$EnforceTimings
        # A devbox run past its whole-run budget fails.
        $budgetFailure = Test-TestRunOverBudget -DurationSeconds $workerRun.DurationSeconds -BudgetSeconds $testTimeLimits.RunSeconds
        if ($timingFailure -or $budgetFailure) {
            $manifestStatus = 'failed'
        }

        # Best-effort artifacts, never masking the run's outcome.
        Write-TestAutomationArtifacts -Rows $rows -RunDirectory $runDir -OutputFolder $OutputFolder `
            -MaxLevel $MaxLevel -Limits $limits -RunResult $runResult -DurationSeconds $workerRun.DurationSeconds `
            -EnforceTimings:$EnforceTimings -MinLevel $MinLevel -Category $Category `
            -Location (Get-TestRunLocationSummary -Location $workerRun.Location).Text

        $passedCount = @($rows | Where-Object { $_.Result -eq 'Passed' }).Count
        $skippedCount = @($rows | Where-Object { $_.Result -eq 'Skipped' }).Count

        # One verdict feeds the banner and the throw, so the reason is worded once.
        $verdict = Get-TestAutomationVerdict -Rows $rows -Limits $limits -RunResult $runResult `
            -FailedCount $failedCount -FailedShardLabels $failedShardLabels -TimingFailure:$timingFailure `
            -BudgetFailure:$budgetFailure -RunBudgetSeconds $testTimeLimits.RunSeconds `
            -PassedCount $passedCount -SkippedCount $skippedCount -DurationSeconds $workerRun.DurationSeconds

        # Every failed test's and failed file's message, right before the verdict (nothing on a green run).
        Write-TestRunFailures -Rows $rows -Files @($workerRun.Files)
        # The closing bracket prints on every exit path, -PassThru included.
        Write-TestAutomationVerdict -Result $verdict.Result -Summary $verdict.Summary `
            -PassedCount $passedCount -FailedCount $failedCount -SkippedCount $skippedCount `
            -DurationSeconds $workerRun.DurationSeconds -ReportPath $runDir

        if ($PassThru) {
            $notRunCount = @($rows | Where-Object { $_.Result -eq 'NotRun' }).Count
            [Catzc.Base.Reports.TestRunResult]::new($runResult, $passedCount, $failedCount, $skippedCount, $notRunCount,
                [math]::Round($workerRun.DurationSeconds, 2), $runDir, [object[]] $rows,
                [object[]] @($workerRun.Shards),
                [string[]] @($protectedModules), [object[]] @($optOutExcludedTests))
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
