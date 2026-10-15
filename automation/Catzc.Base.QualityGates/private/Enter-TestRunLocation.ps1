<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-ENGINE#2
      - ADR-AUTO-TEST#32
---
#>

<#
.SYNOPSIS
    Claims where a test run executes — its location: in place in the working folder, or in an isolated snapshot of it.
.DESCRIPTION
    Runs share a checkout's real state, so only one may use the working folder; a busy folder gets a snapshot.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md#comment1)
.PARAMETER EntryPoint
    Written to the lock record, so a concurrent run that finds the folder busy can name who holds it.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md#comment2)
.PARAMETER RunDirectory
    The run's report folder — written to the lock record so a concurrent run can name it.
.PARAMETER Isolated
    Run in a snapshot even when the working folder is free.
.PARAMETER KeepSandbox
    Only a snapshot is kept: an in-place run has nothing to delete, so the switch changes nothing for it.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md#comment3)
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

    # Cache keys are content-based, so they hold in the copy; without them every snapshot run starts from cold.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md#comment4)
    $sourceCache = Join-Path (Get-OutputRoot) 'cache'
    if ([System.IO.Directory]::Exists($sourceCache)) {
        Copy-Directory $sourceCache (Join-Path $location.Snapshot.Path 'out/cache')
    }

    # Import once before any worker starts: workers skip the janitors and would find the generated files missing.
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md#comment5)
    Write-Message 'Priming the snapshot: one import materialises its generated files...'
    $start = ([Catzc.Base.Engines.ExecutionEngines]::Pwsh.NonInteractiveArguments) -join ' '
    try {
        Invoke-Executable "pwsh $start -File `"$(Join-Path $location.Snapshot.Path 'importer.ps1')`"" `
            -WorkingDirectory $location.Snapshot.Path -PassThru -Silent | Out-Null
    }
    catch {
        Remove-RepositorySnapshot $location.Snapshot.Path
        throw "The working folder was held, so this run went to a snapshot, but priming the snapshot failed: $($_.Exception.Message)"
    }
    $location.Mode = 'snapshot'
    $location.Root = $location.Snapshot.Path
    $location.SystemTests = $false
    $location
}
