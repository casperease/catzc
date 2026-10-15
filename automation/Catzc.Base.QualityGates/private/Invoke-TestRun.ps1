<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Invoke-TestRun.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#{26,30,31,44}
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
    Write-Message '.' -NoHeader -NoNewline

    $testPaths = @(Get-TestAutomationTestPaths -Modules $Modules)
    Write-Message '.' -NoHeader -NoNewline

    if (-not $testPaths) {
        if ($Modules) {
            throw "No test folders found for the requested module(s): $($Modules -join ', '). A module has tests only if it has a tests/ folder."
        }
        throw 'No test folders found'
    }

    $discovery = Get-TestDiscovery -TestPath $testPaths
    Write-Message '.' -NoHeader -NoNewline

    # Enforce the two mandatory tag axes on every test, regardless of -Level (Assert-TestTagGate).
    Assert-TestTagGate -Discovery $discovery

    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) $entryPointKey
    }
    Set-AbandonedTestRun -OutputFolder $OutputFolder | Out-Null
    $runDir = New-TestAutomationRunDirectory -OutputFolder $OutputFolder

    $location = Enter-TestRunLocation -EntryPoint $EntryPoint -RunDirectory $runDir -Isolated:$Isolated -KeepSandbox:$KeepSandbox
    $runStartedAt = [DateTimeOffset]::UtcNow.ToString('o')
    $manifestStatus = 'crashed'
    $failedCount = 0
    $failedShardLabels = @()
    $workerRun = $null
    $optOutExcludedTests = @()
    $context = $null

    try {
        $requestedMaxLevel = $MaxLevel
        $MaxLevel = Resolve-TestRunMaxLevel -Location $location -Requested $MaxLevel -MinLevel $MinLevel

        $context = Get-TestRunContext -EntryPoint $EntryPoint -EntryScript $EntryScript -Location $location -MinLevel $MinLevel `
            -RequestedMaxLevel $requestedMaxLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Suite $Suite -Rule $Rule

        $excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category

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

        $selection = Select-TestRunFiles -TestPath $testPaths -Discovery $discovery -Rule $Rule -ExcludeTag $excludeTags `
            -OptOutTag $OptOutTag -RunDirectory $runDir -EntryPoint $EntryPoint
        $testFiles = @($selection.Files)
        $excludeTags = @($selection.ExcludeTag)
        $optOutExcludedTests = @($selection.OptOutExcludedTests)

        $phases = Split-TestAutomationFiles -Discovery $discovery -TestFiles $testFiles
        $parallelFiles = @($phases.Parallel)
        $greedyFiles = @($phases.Greedy)
        $serialFiles = @($phases.Serial)

        $protectionKey = "$entryPointKey|L$MinLevel-L$MaxLevel|$Category|$($Rule -join ',')"
        $protectionPlan = Select-ProtectedTestFile -ParallelFiles @($parallelFiles) -GreedyFiles @($greedyFiles) `
            -SerialFiles @($serialFiles) -Discovery $discovery -ProtectionKey $protectionKey
        $parallelFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.ParallelFiles)
        $greedyFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.GreedyFiles)
        $serialFiles = [System.Collections.Generic.List[string]]::new([string[]]$protectionPlan.SerialFiles)
        $protectedModules = @($protectionPlan.ProtectedModules)
        Write-Message '.' -NoHeader -NoNewline

        $workerEnvironment = if ($MaxLevel -lt 2) {
            @{ CATZC_BLOCK_REAL_PROCESS = '1' }
        }
        else {
            $null
        }

        Write-Message '' -NoHeader   # ends the dot line
        Write-TestAutomationHeader -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category -Modules $Modules -Title $Title
        Write-TestRunContext -Context $context

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

        Protect-TestedModule -Candidates @($protectionPlan.Candidates) -Rows $rows `
            -FailedShardLabels $failedShardLabels -ProtectionKey $protectionKey

        $rows = @($rows) + @($selection.OutOfScopeRows)

        $failedCount = @($rows | Where-Object { $_.Result -eq 'Failed' }).Count
        $runResult = if ($failedCount -gt 0 -or $failedShardLabels.Count -gt 0) {
            'Failed'
        }
        else {
            'Passed'
        }
        $manifestStatus = $runResult.ToLowerInvariant()

        $testTimeLimits = Get-TestTimeLimits
        $limits = $testTimeLimits.LevelMs
        $timingFailure = Write-TestAutomationTimingReport -Rows $rows -Limits $limits -EnforceTimings:$EnforceTimings
        $budgetFailure = Test-TestRunOverBudget -DurationSeconds $workerRun.DurationSeconds -BudgetSeconds $testTimeLimits.RunSeconds
        if ($timingFailure -or $budgetFailure) {
            $manifestStatus = 'failed'
        }

        Write-TestAutomationArtifacts -Rows $rows -RunDirectory $runDir -OutputFolder $OutputFolder `
            -MaxLevel $MaxLevel -Limits $limits -RunResult $runResult -DurationSeconds $workerRun.DurationSeconds `
            -EnforceTimings:$EnforceTimings -MinLevel $MinLevel -Category $Category `
            -Location (Get-TestRunLocationSummary -Location $workerRun.Location).Text

        $passedCount = @($rows | Where-Object { $_.Result -eq 'Passed' }).Count
        $skippedCount = @($rows | Where-Object { $_.Result -eq 'Skipped' }).Count

        $verdict = Get-TestAutomationVerdict -Rows $rows -Limits $limits -RunResult $runResult `
            -FailedCount $failedCount -FailedShardLabels $failedShardLabels -TimingFailure:$timingFailure `
            -BudgetFailure:$budgetFailure -RunBudgetSeconds $testTimeLimits.RunSeconds `
            -PassedCount $passedCount -SkippedCount $skippedCount -DurationSeconds $workerRun.DurationSeconds

        # Every failed test's and failed file's message, right before the verdict (nothing on a green run).
        Write-TestRunFailures -Rows $rows -Files @($workerRun.Files)
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
