<#
.SYNOPSIS
    Runs one or more test files by hand as a single worker shard — the blessed single-check entry point.
.DESCRIPTION
    The manual counterpart of a Test-Automation worker: it generates a one-shard runner through the SAME
    generator the parallel harness uses (New-TestAutomationShardScript, which builds its Pester
    configuration through the one shared New-PesterRunConfiguration) and executes it as a child pwsh worker
    (PesterRunner, live output). Parity is by construction, not imitation — the manual path cannot drift
    from the harness path because it IS the harness path, one shard wide.

    Why a child process and not an in-session Invoke-Pester: the suite runs WITHOUT strict mode
    (ADR-TEST:25), but the importer's dot-sourced shim sets strict mode in the session's top scope, and
    Pester's test scopes chain to that top scope — no function-scope Set-StrictMode -Off can shield them. In
    a worker process the importer loads into the WORKER SCRIPT's scope, so the process top scope never goes
    strict and the shard's own Set-StrictMode -Off governs. A bare Invoke-Pester from an importer session
    therefore runs the same tests under different semantics than CI; this entry point closes that gap.

    Use it for the manual single-check flow in docs/how-to/automation/manual-test-plan.md: pass the row's
    test file and (optionally) its FullNameFilter. No tier/category exclusion is applied — a hand-run of a
    named check should run exactly that check. The run's artifacts (worker script, results-shard-0.xml,
    rows-shard-0.json) land in a timestamped folder under out/test-file/.
.PARAMETER Path
    The test file(s) to run — absolute, or repository-root-relative (never resolved against $PWD; see
    docs/adr/automation/never-depend-on-pwd.md).
.PARAMETER FullNameFilter
    Filter to tests whose full name contains this text (wrapped in wildcards) — the manual-test-plan row's
    FullNameFilter column, verbatim.
.PARAMETER Output
    Pester output verbosity inside the worker. Defaults to 'Detailed' — a hand-run wants one line per test.
.PARAMETER TimeoutSeconds
    Hard ceiling for the worker; on expiry it is killed and this throws. Defaults to 600.
.PARAMETER PassThru
    Return a result object ({ Result, ExitCode, Rows, RunDirectory }) instead of nothing. Rows are the
    worker's per-test rows (the same shape Test-Automation aggregates) — the live Pester object cannot cross
    the process boundary.
.OUTPUTS
    None by default; the result object with -PassThru. The worker's Pester output streams either way.
.EXAMPLE
    Invoke-TestFile automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
.EXAMPLE
    Invoke-TestFile automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1 -FullNameFilter 'Generated README copy-ins'
#>
function Invoke-TestFile {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [Parameter(Position = 1)]
        [string] $FullNameFilter,

        [ValidateSet('Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Output = 'Detailed',

        [ValidateRange(60, 86400)]
        [int] $TimeoutSeconds = 600,

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
            $full
        })

    # A timestamped run folder under out/test-file/, like the harness's out/test-automation/<stamp>/.
    $runDirectory = Join-Path (Join-Path (Get-OutputRoot -EnsureExists) 'test-file') `
    ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
    New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null

    $shard = New-TestAutomationShardScript -ShardIndex 0 -TestPath $resolved -RunDirectory $runDirectory `
        -Verbosity $Output -FullNameFilter $FullNameFilter

    # One worker, live output — the same runner the harness pools, behind the same machine-wide run lock
    # (a file run launched mid-suite would race the suite's shared build folders; Wait-TestRunMutex owns
    # the why).
    $runMutex = Wait-TestRunMutex -Reason 'test file run'
    try {
        $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
            [string[]] @($shard.ScriptPath), [string[]] @($shard.Label), 1, $null, $TimeoutSeconds, $true)
    }
    finally {
        if ($runMutex) {
            $runMutex.ReleaseMutex()
            $runMutex.Dispose()
        }
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

    $result = if ($exitCode -eq 0) {
        'Passed'
    }
    else {
        'Failed'
    }
    Write-Message "$result — artifacts in $runDirectory" -ForegroundColor $(if ($exitCode -eq 0) {
            'Green'
        }
        else {
            'Red'
        })

    if ($PassThru) {
        [pscustomobject]@{
            Result       = $result
            ExitCode     = $exitCode
            Rows         = @([System.IO.File]::ReadAllText($shard.RowsPath) | ConvertFrom-Json)
            RunDirectory = $runDirectory
        }
    }
}
