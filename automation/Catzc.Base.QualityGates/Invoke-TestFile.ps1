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
    strict by the shard script (ADR-AUTO-TEST:25) — exactly the conditions CI runs under. A bare Invoke-Pester
    from an interactive session runs the same tests against whatever that session has accumulated; this entry
    point closes that gap.

    Use it for the manual single-check flow in docs/how-to/automation/manual-test-plan.md: pass the row's
    test file and (optionally) its FullNameFilter. No category exclusion is applied — a hand-run of a named
    check should run exactly that check. The run's artifacts (worker script, results-shard-0.xml,
    rows-shard-0.json) land in a timestamped folder under out/test-file/.

    It never waits for another test run's use of the working folder (ADR-AUTO-TEST:32, Enter-TestRunSlot):
    when the working folder is free it runs in place; when another run holds it, it runs in a verified
    snapshot of the working folder instead — the test files map to the same repository-relative paths inside
    the snapshot, a test file outside the repository runs as given, and the artifacts still land in the
    working folder's out/test-file/. Every tier runs in place; a snapshot run skips the L3 vertical system tests,
    which change state outside the repository, and says so (Resolve-TestRunMaxLevel, ADR-AUTO-TEST:33).
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
.PARAMETER Isolated
    Run in a snapshot of the working folder even when it is free — immune to edits made while it runs.
.PARAMETER KeepSandbox
    Keep the snapshot (when the run used one) after the run instead of deleting it, for a post-mortem.
.PARAMETER PassThru
    Return a result object ({ Result, ExitCode, Rows, RunDirectory, Location }) instead of nothing. Rows are
    the worker's per-test rows (the same shape Test-Automation aggregates; File paths are working-folder
    paths even for a snapshot run) — the live Pester object cannot cross the process boundary. Location is
    'in-place' or 'snapshot'.
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

    # A timestamped run folder under out/test-file/, like the harness's out/test-automation/<stamp>/.
    $runDirectory = Join-Path (Join-Path (Get-OutputRoot -EnsureExists) 'test-file') `
    ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
    New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null

    # Claim where the run executes — in place, or in a snapshot when another run holds the working folder
    # (Enter-TestRunSlot owns the why). The worker inherits CATZC_TEST_RUN_SLOT_HELD, as Test-Automation's
    # workers do, so a test that drives Invoke-TestFile for real inside this run runs in place in this run's
    # root rather than claiming a slot of its own.
    $slot = Enter-TestRunSlot -EntryPoint 'Invoke-TestFile' -RunDirectory $runDirectory -Isolated:$Isolated
    try {
        # The worker loads from the root the run executes in (Get-TestRunSlotEntry); the test files map to it alike.
        $entry = Get-TestRunSlotEntry -Slot $slot
        # Every tier the slot allows: in place that includes the L3 system tests; a snapshot skips them and says
        # so (Resolve-TestRunMaxLevel owns the why).
        $excludeTag = @()
        if ((Resolve-TestRunMaxLevel -Slot $slot) -lt 3) {
            $excludeTag = @('L3')
        }
        $shard = New-TestAutomationShardScript -ShardIndex 0 -TestPath @(Convert-TestRunSlotPath -Slot $slot -Path $resolved) `
            -RunDirectory $runDirectory -Verbosity $Output -FullNameFilter $FullNameFilter -ExcludeTag $excludeTag @entry

        $workerEnvironment = @{ CATZC_TEST_RUN_SLOT_HELD = '1' }
        $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
            [string[]] @($shard.ScriptPath), [string[]] @($shard.Label), 1, $workerEnvironment, $TimeoutSeconds, $true)
    }
    finally {
        Exit-TestRunSlot -Slot $slot -KeepSandbox:$KeepSandbox
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
    $location = if ($slot.Mode -eq 'Snapshot') {
        'snapshot'
    }
    else {
        'in-place'
    }
    Write-Message "$result ($location) — artifacts in $runDirectory" -ForegroundColor $(if ($exitCode -eq 0) {
            'Green'
        }
        else {
            'Red'
        })

    if ($PassThru) {
        $rows = @([System.IO.File]::ReadAllText($shard.RowsPath) | ConvertFrom-Json)
        foreach ($row in $rows) {
            $row.File = Convert-TestRunSlotPath -Slot $slot -Path $row.File -ToSource
        }
        [pscustomobject]@{
            Result       = $result
            ExitCode     = $exitCode
            Rows         = $rows
            RunDirectory = $runDirectory
            Location     = $location
        }
    }
}
