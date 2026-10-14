<#
.SYNOPSIS
    Claims where a test run executes — its location: in place in the working folder, or in an isolated snapshot of it.
.DESCRIPTION
    A test run never waits for another
    ([ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)). Concurrent runs share real state
    in a checkout —
    the out/ build folders, the .compiled assembly, the git index and working tree — so only one run at a
    time may use the working folder itself. This is the one claim path both entry points use:

    - The working folder's lock — a named [System.Threading.Mutex] keyed on the repository root, machine-wide
      through the Global\ namespace — is tried without waiting. Free (or abandoned: the previous holder died
      mid-run): the run owns the working folder and runs in place. The holder writes a lock record
      (out/.test-run-lock.json: pid, entry point, start time, run folder) so a concurrent run can say who
      holds the folder.
    - Held: the run announces who holds the folder (from the lock record, or plainly that the record is
      missing or stale) and runs in a verified snapshot of the working folder instead
      (New-RepositorySnapshot) — HEAD plus every uncommitted change, frozen at this moment — primed by one
      full import that materialises its generated files.
    - -Isolated: the run takes the snapshot path without touching the lock, for a deterministic run that is
      immune to edits made in the working folder while it runs.
    - Inside a worker of a run that already holds its location (CATZC_TEST_RUN_LOCATION_HELD): the parent's
      location covers this process and its repository root — the claim returns in place without a lock
      (claiming would only ever find our own parent's lock). An explicit -Isolated still gets its snapshot.

    A run that takes the working folder also tries the user's system-test lock (Enter-SystemTestLock), without
    waiting: L3 changes state that belongs to the user, not to this checkout, so a second clone's in-place run
    must not run L3 at the same time. SystemTests on the location says whether this run may run L3; a run that
    owns the working folder but not the system-test lock names its holder (SystemTestHolder), and
    Resolve-TestRunMaxLevel skips L3 for it.

    The location is the one record of where the run executes: the run's context (Get-TestRunContext), its
    worker run (Invoke-TestAutomationWorkers), and its report and run.json entries (Get-TestRunLocationSummary)
    all read this object. The caller MUST pass it to Exit-TestRunLocation in a finally.
.PARAMETER EntryPoint
    The entry point claiming the location ('Test-Automation', 'Invoke-TestFile', …) — written to the lock record
    and named in the announcements.
.PARAMETER RunDirectory
    The run's report folder — written to the lock record so a concurrent run can name it.
.PARAMETER Isolated
    Run in a snapshot even when the working folder is free.
.PARAMETER KeepSandbox
    Keep a snapshot after the run instead of deleting it — recorded on the location as KeepSandbox, which
    Exit-TestRunLocation honours and the run's report states.
.OUTPUTS
    [pscustomobject] the location: Mode ('in-place'|'snapshot'), SourceRoot (the working folder), Root (where
    the run executes — the working folder, or the snapshot), Mutex (owned, or $null), LockPath (the lock record
    this run wrote, or $null), Holder (who held the folder when this run went to a snapshot, or $null),
    Snapshot (New-RepositorySnapshot's result, or $null), KeepSandbox (whether a snapshot is kept after the run),
    SystemTests (whether this run may run L3), SystemTestLock (Enter-SystemTestLock's result when this run took
    it, or $null), and SystemTestHolder (who holds the system-test lock when this run owns the working folder
    but not that lock, or $null).
#>
function Enter-TestRunLocation {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $EntryPoint,

        [string] $RunDirectory,

        [switch] $Isolated,

        [switch] $KeepSandbox
    )

    $sourceRoot = Get-RepositoryRoot
    $location = [pscustomobject]@{
        Mode             = 'in-place'
        SourceRoot       = $sourceRoot
        Root             = $sourceRoot
        Mutex            = $null
        LockPath         = $null
        Holder           = $null
        Snapshot         = $null
        KeepSandbox      = [bool] $KeepSandbox
        # A worker's in-place location inherits its parent's right to run L3; every other path decides below.
        SystemTests      = $true
        SystemTestLock   = $null
        SystemTestHolder = $null
    }

    if ($env:CATZC_TEST_RUN_LOCATION_HELD -eq '1' -and -not $Isolated) {
        return $location
    }

    if ($Isolated) {
        Write-Message "Running in an isolated snapshot of '$sourceRoot' (-Isolated)."
    }
    else {
        $lockPath = Join-Path (Get-OutputRoot -EnsureExists) '.test-run-lock.json'
        $mutexKey = [Convert]::ToHexString(
            [System.Security.Cryptography.SHA256]::HashData(
                [System.Text.Encoding]::UTF8.GetBytes($sourceRoot.ToLowerInvariant())))
        $mutex = [System.Threading.Mutex]::new($false, "Global\catzc-test-automation-$mutexKey")
        $acquired = try {
            $mutex.WaitOne(0)
        }
        catch [System.Threading.AbandonedMutexException] {
            # The previous holder died owning the lock; the wait handle grants us ownership.
            Write-Message 'The previous test-run lock holder died owning it; ownership transferred.' -Verbose:($VerbosePreference -eq 'Continue')
            $true
        }

        if ($acquired) {
            Write-TestRunLockRecord -Path $lockPath -EntryPoint $EntryPoint -RunDirectory $RunDirectory -RepositoryRoot $sourceRoot
            $location.Mutex = $mutex
            $location.LockPath = $lockPath

            $systemTestLock = Enter-SystemTestLock -EntryPoint $EntryPoint -RunDirectory $RunDirectory -RepositoryRoot $sourceRoot
            $location.SystemTests = $systemTestLock.Acquired
            if ($systemTestLock.Acquired) {
                $location.SystemTestLock = $systemTestLock
            }
            else {
                $location.SystemTestHolder = $systemTestLock.Holder
            }
            return $location
        }

        $mutex.Dispose()
        $location.Holder = Get-TestRunLockHolder -Path $lockPath
        Write-Message "The repository is busy: $($location.Holder.Description) holds the test-run lock." -ForegroundColor Yellow
    }

    $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-run-' + [guid]::NewGuid().ToString('N'))
    Write-Message "Running in an isolated snapshot instead: $destination" -ForegroundColor Yellow
    $location.Snapshot = New-RepositorySnapshot -SourceRoot $sourceRoot -Destination $destination

    # Prime the snapshot with one full import, as a fresh clone's first import does: the janitors materialise
    # the generated, gitignored files the snapshot does not carry (module manifests, READMEs, root configs,
    # cspell dictionaries), once, before any worker starts — workers import with -SkipJanitors and would
    # otherwise find them missing, or race each other generating manifests. The snapshot is never committed to:
    # Sync-GeneratedFile recognises it by its provenance marker (Test-RepositorySnapshot).
    Write-Message 'Priming the snapshot: one import materialises its generated files...'
    try {
        Invoke-Executable "pwsh -NoProfile -File `"$(Join-Path $location.Snapshot.Path 'importer.ps1')`"" `
            -WorkingDirectory $location.Snapshot.Path -PassThru -Silent | Out-Null
    }
    catch {
        Remove-RepositorySnapshot $location.Snapshot.Path
        throw
    }
    $location.Mode = 'snapshot'
    $location.Root = $location.Snapshot.Path
    $location.SystemTests = $false
    $location
}
