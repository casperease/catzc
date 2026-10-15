<#
.SYNOPSIS
    Performs one test run through the parallel harness — the shared core of Test-Automation and Test-CatzcBuild.
.DESCRIPTION
    The two test runs differ only in what they pass in: entry script, opt-out tag, entry point name and banner title.
    [ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30),
    [ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment1)
.PARAMETER EntryPoint
    Its key names the default report folder under out/ and prefixes the protection key.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment2)
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
    Run in a snapshot of the working folder even when it is free (Enter-TestRunLocation).
.PARAMETER KeepSandbox
    Keep the snapshot (when the run used one) after the run, for a post-mortem.
.NOTES
    The remaining parameters are Test-Automation's own, passed through unchanged — see its help.
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

        # The highest tier asked for; the run's location caps it (Resolve-TestRunMaxLevel): a snapshot never runs L3.
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

        # The entry point's own limit (its [TimeLimit] through Get-TimeoutSeconds -Command); no default here.
        [Parameter(Mandatory)]
        [ValidateRange(60, 86400)]
        [int] $TimeoutSeconds,

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [switch] $PassThru,

        [switch] $EnforceTimings,

        [AllowEmptyCollection()]
        [string[]] $Rule = @(),

        # A test suite's name, when -Modules was resolved from one (Test-Automation -Suite); the context block names it.
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
    # Discovery runs before the banner and takes a while, so each stage prints a dot to show the run is alive.
    # [ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)
    # [comment:25](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment25)
    Write-Message '.' -NoHeader -NoNewline

    # Module dependency order puts foundations first and the dot-prefixed infrastructure last.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment3)
    $testPaths = @(Get-TestAutomationTestPaths -Modules $Modules)
    Write-Message '.' -NoHeader -NoNewline

    if (-not $testPaths) {
        if ($Modules) {
            throw "No test folders found for the requested module(s): $($Modules -join ', '). A module has tests only if it has a tests/ folder."
        }
        throw 'No test folders found'
    }

    # The tag check and the phase split share this one discovery pass, so the test tree is discovered once per run.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment4)
    $discovery = Get-TestDiscovery -TestPath $testPaths
    Write-Message '.' -NoHeader -NoNewline

    # Enforce the two mandatory tag axes on every test, regardless of -Level (Assert-TestTagGate).
    Assert-TestTagGate -Discovery $discovery

    # A timestamped run directory keeps each run's artifacts apart; clearing out/ removes them with the rest.
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment5)
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) $entryPointKey
    }
    # Without this a dead run claims 'running' forever; the owner recorded below tells a dead process from a live one.
    # [comment:6](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment6)
    Set-AbandonedTestRun -OutputFolder $OutputFolder | Out-Null
    $runDir = New-TestAutomationRunDirectory -OutputFolder $OutputFolder

    # The location decides the top tier, so it is claimed before any filtering; the finally releases it.
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment7)
    $location = Enter-TestRunLocation -EntryPoint $EntryPoint -RunDirectory $runDir -Isolated:$Isolated -KeepSandbox:$KeepSandbox
    $runStartedAt = [DateTimeOffset]::UtcNow.ToString('o')
    $manifestStatus = 'crashed'
    $failedCount = 0
    $failedShardLabels = @()
    $workerRun = $null
    $optOutExcludedTests = @()
    $context = $null

    # The stamp sits in the finally, not a best-effort catch, so run.json stays trustworthy on every exit path.
    # [comment:8](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment8)
    try {
        $requestedMaxLevel = $MaxLevel
        $MaxLevel = Resolve-TestRunMaxLevel -Location $location -Requested $MaxLevel -MinLevel $MinLevel

        # One context record feeds both the banner and run.json, so the two cannot disagree.
        # [comment:9](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment9)
        $context = Get-TestRunContext -EntryPoint $EntryPoint -EntryScript $EntryScript -Location $location -MinLevel $MinLevel `
            -RequestedMaxLevel $requestedMaxLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Suite $Suite -Rule $Rule

        # ExcludeTag matches an item's own tag, so a mixed file's per-Context category tags filter correctly.
        # [comment:10](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment10)
        $excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category

        # Stamped 'running' now and terminally later, so a reader never infers completeness from which files exist.
        # [comment:11](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment11)
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
        # [comment:12](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment12)
        $selection = Select-TestRunFiles -TestPath $testPaths -Discovery $discovery -Rule $Rule -ExcludeTag $excludeTags `
            -OptOutTag $OptOutTag -RunDirectory $runDir -EntryPoint $EntryPoint
        $testFiles = @($selection.Files)
        $excludeTags = @($selection.ExcludeTag)
        $optOutExcludedTests = @($selection.OptOutExcludedTests)

        # Greedy files overlap only each other, and serial files run last and alone.
        # [ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)
        # [comment:13](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment13)
        $phases = Split-TestAutomationFiles -Discovery $discovery -TestFiles $testFiles
        $parallelFiles = @($phases.Parallel)
        $greedyFiles = @($phases.Greedy)
        $serialFiles = @($phases.Serial)

        # The key carries entry point and parameters, so an L0-L1 green never skips an L2 run or the build run.
        # [ADR-REPO-PROTGLOB#9](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob9)
        # [comment:14](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment14)
        $protectionKey = "$entryPointKey|L$MinLevel-L$MaxLevel|$Category|$($Rule -join ',')"
        $protectionPlan = Select-ProtectedTestFile -ParallelFiles @($parallelFiles) -GreedyFiles @($greedyFiles) `
            -SerialFiles @($serialFiles) -Discovery $discovery -ProtectionKey $protectionKey
        $parallelFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.ParallelFiles)
        $greedyFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.GreedyFiles)
        $serialFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.SerialFiles)
        $protectedModules = @($protectionPlan.ProtectedModules)
        Write-Message '.' -NoHeader -NoNewline

        # A real process started in an L0/L1 worker means a Mock missed it, so Invoke-Executable throws there.
        # [comment:15](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment15)
        $workerEnvironment = if ($MaxLevel -lt 2) {
            @{ CATZC_BLOCK_REAL_PROCESS = '1' }
        }
        else {
            $null
        }

        Write-Message '' -NoHeader   # ends the dot line
        Write-TestAutomationHeader -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Title $Title
        Write-TestRunContext -Context $context

        # With the whole work-list protected away there is nothing to execute, so the run is vacuously green.
        # [comment:16](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment16)
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

        # Anything the rows cannot attribute to a unit stays unprotected, so doubt never protects a module.
        # [comment:17](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment17)
        Protect-TestedModule -Candidates @($protectionPlan.Candidates) -Rows $rows `
            -FailedShardLabels $failedShardLabels -ProtectionKey $protectionKey

        # NotRun rows join after protection, which promotes only what workers ran; every report reads the same rows.
        # [comment:18](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment18)
        $rows = @($rows) + @($selection.OutOfScopeRows)

        $failedCount = @($rows | Where-Object { $_.Result -eq 'Failed' }).Count
        # A container or discovery error fails a shard with no failed test row, so either signal fails the verdict.
        # [comment:19](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment19)
        $runResult = if ($failedCount -gt 0 -or $failedShardLabels.Count -gt 0) {
            'Failed'
        }
        else {
            'Passed'
        }
        $manifestStatus = $runResult.ToLowerInvariant()

        # Timing is report-only unless -EnforceTimings is set; the limits come from config, never a literal here.
        # [comment:20](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment20)
        $testTimeLimits = Get-TestTimeLimits
        $limits = $testTimeLimits.LevelMs
        $timingFailure = Write-TestAutomationTimingReport -Rows $rows -Limits $limits -EnforceTimings:$EnforceTimings
        # The budget check is separate from the timings and fails the run even when timings are report-only.
        # [ADR-AUTO-TEST#44](/docs/adr/automation/test-automation.md#rule-adr-auto-test44)
        # [comment:21](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment21)
        $budgetFailure = Test-TestRunOverBudget -DurationSeconds $workerRun.DurationSeconds -BudgetSeconds $testTimeLimits.RunSeconds
        if ($timingFailure -or $budgetFailure) {
            $manifestStatus = 'failed'
        }

        # Artifact writing is best-effort, so a report failure never masks the run outcome.
        # [comment:22](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment22)

        Write-TestAutomationArtifacts -Rows $rows -RunDirectory $runDir -OutputFolder $OutputFolder `
            -MaxLevel $MaxLevel -Limits $limits -RunResult $runResult -DurationSeconds $workerRun.DurationSeconds `
            -EnforceTimings:$EnforceTimings -MinLevel $MinLevel -Category $Category `
            -Location (Get-TestRunLocationSummary -Location $workerRun.Location).Text

        $passedCount = @($rows | Where-Object { $_.Result -eq 'Passed' }).Count
        $skippedCount = @($rows | Where-Object { $_.Result -eq 'Skipped' }).Count

        # One verdict feeds the closing banner and the failure throw, so the reason wording lives in one place.
        # [comment:23](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment23)
        $verdict = Get-TestAutomationVerdict -Rows $rows -Limits $limits -RunResult $runResult `
            -FailedCount $failedCount -FailedShardLabels $failedShardLabels -TimingFailure:$timingFailure `
            -BudgetFailure:$budgetFailure -RunBudgetSeconds $testTimeLimits.RunSeconds `
            -PassedCount $passedCount -SkippedCount $skippedCount -DurationSeconds $workerRun.DurationSeconds

        # Every failed test's and failed file's message, right before the verdict (nothing on a green run).
        Write-TestRunFailures -Rows $rows -Files @($workerRun.Files)
        # The closing line prints on every exit path, -PassThru included, and before the failure throw fires.
        # [comment:24](/docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md#comment24)
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
