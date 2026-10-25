<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Invoke-TestFile.ps1.md"
  header: "generated"
---
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

    $reportBase = Join-Path (Get-OutputRoot -EnsureExists) 'test-file'
    Set-AbandonedTestRun -OutputFolder $reportBase | Out-Null
    $runDirectory = Join-Path $reportBase ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
    New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null

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
        $files = @(if ([System.IO.File]::Exists($shard.FilesPath)) {
                @([System.IO.File]::ReadAllText($shard.FilesPath) | ConvertFrom-Json)
            }
            else {
                @()
            })
        if ($exitCode -ne 0) {
            $failedShardLabels = @($shard.Label)
            Write-TestRunFailures -Rows $rows -Files $files
        }
        $outcome = @(foreach ($file in $files) {
                $failedTests = @($rows | Where-Object { $_.Result -eq 'Failed' -and $_.File -eq $file.File }).Count
                [pscustomobject]@{
                    Path        = Convert-TestRunLocationPath -Location $location -Path $file.File -ToSource
                    Failed      = $file.Result -eq 'Failed' -or $failedTests -gt 0
                    FailedCount = $failedTests
                }
            })
        Write-TestResultMarker -Outcome $outcome -RunDirectory $runDirectory -KeepPassing:(-not [string]::IsNullOrEmpty($FullNameFilter)) | Out-Null
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
