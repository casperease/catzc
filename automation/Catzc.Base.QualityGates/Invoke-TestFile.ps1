<#
.SYNOPSIS
    Runs one or more test files by hand as a single worker shard — the blessed single-check entry point.
.DESCRIPTION
    The manual path cannot drift from the harness: it is the harness path, one shard wide, in a fresh child process.
    [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25),
    [ADR-AUTO-TEST#34](/docs/adr/automation/test-automation.md#rule-adr-auto-test34),
    [ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32),
    [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33),
    [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment1)
.PARAMETER Path
    A relative path always means repository-root-relative, never relative to the current directory.
    [ADR-AUTO-NOPWD](/docs/adr/automation/never-depend-on-pwd.md)
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment2)
.PARAMETER FullNameFilter
    Pass the manual-test-plan row's FullNameFilter column verbatim; it is wrapped in wildcards.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment3)
.PARAMETER Output
    Pester output verbosity inside the worker. Defaults to 'Detailed' — a hand-run wants one line per test.
.PARAMETER MaxLevel
    L4 tests are opt-in: the default of 3 skips them, and only 4 runs the file's L4 tests.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment4)
.PARAMETER TimeoutSeconds
    Defaults to this function's own time limit unless timeouts.yml overrides it; a worker past it is killed.
    [ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)
    [comment:5](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment5)
.PARAMETER Isolated
    Run in a snapshot of the working folder even when it is free — immune to edits made while it runs.
.PARAMETER KeepSandbox
    Keep the snapshot (when the run used one) after the run instead of deleting it, for a post-mortem.
.PARAMETER PassThru
    Rows are the worker's per-test rows, as the live Pester object cannot cross the process boundary.
    [comment:6](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment6)
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

    # Earlier runs whose process died never stamped their run.json, so they are marked abandoned first.
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment7)
    $reportBase = Join-Path (Get-OutputRoot -EnsureExists) 'test-file'
    Set-AbandonedTestRun -OutputFolder $reportBase | Out-Null
    $runDirectory = Join-Path $reportBase ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
    New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null

    # The worker inherits CATZC_TEST_RUN_LOCATION_HELD, so a nested Invoke-TestFile runs in place in this root.
    # [comment:8](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment8)
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
            # A snapshot run skips the L3 system tests, which change state outside the repository, and says so.
            # [comment:9](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment9)
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
            # The worker's own output may not reach a redirected console, so the failures are printed again here.
            # [comment:10](/docs/references/automation/catzc-base-qualitygates/Invoke-TestFile.ps1.md#comment10)
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
