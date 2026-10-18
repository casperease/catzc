<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
    folder: private
    name: enter-test-run-location
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Enter-TestRunLocation.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Enter-TestRunLocation.Tests.ps1
    cites:
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-ENGINE#2
      - ADR-AUTO-TEST#32
---
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

    $sourceCache = Join-Path (Get-OutputRoot) 'cache'
    if ([System.IO.Directory]::Exists($sourceCache)) {
        Copy-Directory $sourceCache (Join-Path $location.Snapshot.Path 'out/cache')
    }

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
