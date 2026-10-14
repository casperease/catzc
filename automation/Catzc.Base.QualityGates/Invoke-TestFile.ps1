<#
.SYNOPSIS
    Runs one or more test files by hand as a single worker shard — the blessed single-check entry point.
.DESCRIPTION
    The manual counterpart of a Test-Automation worker: it generates a one-shard runner through the SAME
    generator the parallel harness uses (New-TestAutomationShardScript, which builds its Pester
    configuration through the one shared New-PesterRunConfiguration) and executes it as a child pwsh worker
    (PesterRunner, live output). Parity is by construction, not imitation — the manual path cannot drift
    from the harness path because it IS the harness path, one shard wide.

    Why a child process and not an in-session Invoke-Pester: a worker starts from a fresh process — a freshly
    imported toolset with empty session caches, no state left by earlier commands, and its own top scope set
    strict by the shard script ([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)) —
    exactly the conditions CI runs under. A bare Invoke-Pester
    from an interactive session runs the same tests against whatever that session has accumulated; this entry
    point closes that gap.

    Use it for the manual single-check flow in docs/how-to/automation/manual-test-plan.md: pass the row's
    test file and (optionally) its FullNameFilter. No category exclusion is applied — a hand-run of a named
    check should run exactly that check. The run's artifacts (worker script, results-shard-0.xml,
    rows-shard-0.json, run.json) land in a timestamped folder under out/test-file/. run.json is the same state record
    Test-Automation writes (Write-TestRunManifest): 'running' when the worker starts, then 'passed', 'failed' or
    'crashed' on every exit path, with where the run executed (in place, or a snapshot with its provenance) — so every
    test run of [ADR-AUTO-TEST#34](/docs/adr/automation/test-automation.md#rule-adr-auto-test34) leaves one record shape.
    An earlier run in out/test-file/ whose process died is marked 'abandoned' first (Set-AbandonedTestRun).

    It never waits for another test run's use of the working folder
    ([ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32), Enter-TestRunLocation):
    when the working folder is free it runs in place; when another run holds it, it runs in a verified
    snapshot of the working folder instead — the test files map to the same repository-relative paths inside
    the snapshot, a test file outside the repository runs as given, and the artifacts still land in the
    working folder's out/test-file/. Every tier up to L3 runs in place; a snapshot run skips the L3 vertical system
    tests, which change state outside the repository, and says so (Resolve-TestRunMaxLevel,
    [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)). The opt-in L4 tests run only
    with -MaxLevel 4 ([ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)).
.PARAMETER Path
    The test file(s) to run — absolute, or repository-root-relative (never resolved against $PWD; see
    [ADR-AUTO-NOPWD](/docs/adr/automation/never-depend-on-pwd.md)).
.PARAMETER FullNameFilter
    Filter to tests whose full name contains this text (wrapped in wildcards) — the manual-test-plan row's
    FullNameFilter column, verbatim.
.PARAMETER Output
    Pester output verbosity inside the worker. Defaults to 'Detailed' — a hand-run wants one line per test.
.PARAMETER MaxLevel
    The highest tier to run (alias: -Level): 3 by default, every tier but the opt-in L4; 4 runs the file's L4 tests
    too.
.PARAMETER TimeoutSeconds
    Hard ceiling for the worker; on expiry it is killed and this throws. Defaults to this function's [TimeLimit]
    (360 s on a devbox, 600 s in a pipeline), unless timeouts.yml overrides it
    ([ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)).
.PARAMETER Isolated
    Run in a snapshot of the working folder even when it is free — immune to edits made while it runs.
.PARAMETER KeepSandbox
    Keep the snapshot (when the run used one) after the run instead of deleting it, for a post-mortem.
.PARAMETER PassThru
    Return a result object ({ Result, ExitCode, Rows, RunDirectory, Location }) instead of nothing. Rows are
    the worker's per-test rows (the same shape Test-Automation aggregates; File paths are working-folder
    paths even for a snapshot run) — the live Pester object cannot cross the process boundary. Location is
    the run's location as the run directory's run.json records it: 'in-place' or 'snapshot'.
.OUTPUTS
    None by default; the result object with -PassThru. The worker's Pester output streams either way, and a failed
    run ends with every failure's message (Write-TestRunFailures): each failed test, and each file that failed before
    its tests ran.
.EXAMPLE
    Invoke-TestFile automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
.EXAMPLE
    Invoke-TestFile automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1 -FullNameFilter 'Generated README copy-ins'
#>
function Invoke-TestFile {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 600)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [Parameter(Position = 1)]
        [string] $FullNameFilter,

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [ValidateSet(3, 4)]
        [Alias('Level')]
        [int] $MaxLevel = [Catzc.Base.Timeouts.TestTiers]::DefaultTop,

        [ValidateRange(60, 86400)]
        [int] $TimeoutSeconds = (Get-TimeoutSeconds -Command 'Invoke-TestFile'),

        [switch] $Isolated,

        [switch] $KeepSandbox,

        [switch] $PassThru
    )

    $repositoryRoot = Get-RepositoryRoot

    # Resolve repo-relative inputs against the repository root, never $PWD, and fail fast on a typo.
    $resolved = @(foreach ($testPath in $Path) {
            $full = if ([System.IO.Path]::IsPathRooted($testPath)) {
                $testPath
            }
            else {
                Join-Path $repositoryRoot $testPath
            }
            Assert-PathExist $full -PathType Leaf
            # Normalised, so it compares equal to the path Pester's discovery reports for the same file.
            [System.IO.Path]::GetFullPath($full)
        })

    # A timestamped run folder under out/test-file/, like the harness's out/test-automation/<stamp>/. Earlier runs whose
    # process died never stamped their run.json: mark them 'abandoned' first, as Test-Automation does.
    $reportBase = Join-Path (Get-OutputRoot -EnsureExists) 'test-file'
    Set-AbandonedTestRun -OutputFolder $reportBase | Out-Null
    $runDirectory = Join-Path $reportBase ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
    New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null

    # Claim where the run executes — in place, or in a snapshot when another run holds the working folder
    # (Enter-TestRunLocation owns the why). The worker inherits CATZC_TEST_RUN_LOCATION_HELD, as Test-Automation's
    # workers do, so a test that drives Invoke-TestFile for real inside this run runs in place in this run's
    # root rather than claiming a location of its own.
    $location = Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -RunDirectory $runDirectory -Isolated:$Isolated -KeepSandbox:$KeepSandbox
    $runStartedAt = [DateTimeOffset]::UtcNow.ToString('o')
    $manifestStatus = 'crashed'
    $workerRun = $null
    $failedCount = 0
    $failedShardLabels = @()
    $effectiveMaxLevel = $MaxLevel
    # try/finally: the terminal run.json is stamped on every exit path — pass, fail, or crash.
    try {
        try {
            # The worker loads from the root the run executes in (Get-TestRunLocationEntry); the test files map to it alike.
            $entry = Get-TestRunLocationEntry -Location $location
            # Every tier asked for that the location allows: in place that includes the L3 system tests; a snapshot skips
            # them and says so (Resolve-TestRunMaxLevel owns the why). L4 only when asked for.
            $effectiveMaxLevel = Resolve-TestRunMaxLevel -Location $location -Requested $MaxLevel
            $excludeTag = @(Get-TestExcludeTag -MinLevel 0 -MaxLevel $effectiveMaxLevel)
            $shard = New-TestAutomationShardScript -ShardIndex 0 -TestPath @(Convert-TestRunLocationPath -Location $location -Path $resolved) `
                -RunDirectory $runDirectory -Verbosity $Output -FullNameFilter $FullNameFilter -ExcludeTag $excludeTag `
                -LanguageExecutable (Get-LanguageTestExecutable) @entry

            Write-TestRunManifest -RunDirectory $runDirectory -Manifest ([ordered]@{
                    status     = 'running'
                    startedAt  = $runStartedAt
                    ownerPid   = $PID
                    ownerStart = [Catzc.Base.QualityGates.WorkerParentWatch]::CurrentStartTicks()
                    minLevel   = 0
                    maxLevel   = $effectiveMaxLevel
                }) | Out-Null

            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            $workerEnvironment = @{ CATZC_TEST_RUN_LOCATION_HELD = '1' }
            $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
                [string[]] @($shard.ScriptPath), [string[]] @($shard.Label), 1, $workerEnvironment, $TimeoutSeconds, $true)
            # The worker run as New-TestRunFinalManifest reads it: exit code per shard, duration, and location.
            $workerRun = [pscustomobject]@{
                ShardExitCodes  = [ordered]@{ $shard.Label = $runner.Results[0].ExitCode }
                DurationSeconds = $stopwatch.Elapsed.TotalSeconds
                Location        = $location
            }
        }
        finally {
            Exit-TestRunLocation -Location $location
        }
        $exitCode = $runner.Results[0].ExitCode

        # 0 = green, 1 = the run did not pass; anything else (or a missing rows sidecar) is a worker crash.
        if ($exitCode -notin 0, 1 -or -not (Test-Path $shard.RowsPath)) {
            $stderrTail = "$($runner.Results[0].Stderr)".Trim()
            throw ("Invoke-TestFile worker crashed (exit $exitCode) without completing its run." +
                $(if ($stderrTail) {
                        " Stderr:`n$stderrTail"
                    }))
        }

        $rows = @([System.IO.File]::ReadAllText($shard.RowsPath) | ConvertFrom-Json)
        $failedCount = @($rows | Where-Object { $_.Result -eq 'Failed' }).Count
        $result = if ($exitCode -eq 0) {
            'Passed'
        }
        else {
            'Failed'
        }
        $manifestStatus = $result.ToLowerInvariant()
        if ($exitCode -ne 0) {
            $failedShardLabels = @($shard.Label)
            # Every failure's message, on the console at every -Output level (the worker's own output does not reach a
            # redirected console): failed tests from the rows, and a file that failed before its tests ran from the
            # files sidecar.
            $files = if ([System.IO.File]::Exists($shard.FilesPath)) {
                @([System.IO.File]::ReadAllText($shard.FilesPath) | ConvertFrom-Json)
            }
            else {
                @()
            }
            Write-TestRunFailures -Rows $rows -Files $files
        }
        Write-Message "$result ($($location.Mode)) — artifacts in $runDirectory" -ForegroundColor $(if ($exitCode -eq 0) {
                'Green'
            }
            else {
                'Red'
            })

        if ($PassThru) {
            foreach ($row in $rows) {
                $row.File = Convert-TestRunLocationPath -Location $location -Path $row.File -ToSource
            }
            [pscustomobject]@{
                Result       = $result
                ExitCode     = $exitCode
                Rows         = $rows
                RunDirectory = $runDirectory
                Location     = $location.Mode
            }
        }
    }
    finally {
        $finalManifest = New-TestRunFinalManifest -Status $manifestStatus -StartedAt $runStartedAt -MaxLevel $effectiveMaxLevel `
            -FailedCount $failedCount -FailedShardLabels $failedShardLabels -WorkerRun $workerRun
        Write-TestRunManifest -RunDirectory $runDirectory -Manifest $finalManifest | Out-Null
    }
}
