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

    # The snapshot starts with the working folder's result caches, keyed on content and input stamps.
    $sourceCache = Join-Path (Get-OutputRoot) 'cache'
    if ([System.IO.Directory]::Exists($sourceCache)) {
        Copy-Directory $sourceCache (Join-Path $location.Snapshot.Path 'out/cache')
    }

    # One full import, as a fresh clone's, materialises the gitignored generated files.
    Write-Message 'Priming the snapshot: one import materialises its generated files...'
    $pwshEngine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh
    $start = $pwshEngine.NonInteractiveArguments -join ' '
    $priming = Invoke-Executable "pwsh $start -File `"$(Join-Path $location.Snapshot.Path $pwshEngine.ImporterEntry)`"" `
        -WorkingDirectory $location.Snapshot.Path -PassThru -Silent -NoAssert
    if ($priming.ExitCode -ne 0) {
        # The failed import's output is kept as a log, the snapshot left for a look, and its tail thrown.
        $logFolder = Join-Path (Get-OutputRoot) 'test-snapshot-priming'
        [void] [System.IO.Directory]::CreateDirectory($logFolder)
        $log = Join-Path $logFolder "$([System.IO.Path]::GetFileName($location.Snapshot.Path)).log"
        [System.IO.File]::WriteAllText($log, "$($priming.Full)")
        $tail = @("$($priming.Full)".TrimEnd() -split '\r?\n' | Select-Object -Last 10) -join "`n"
        throw ("The working folder was held, so this run went to a snapshot, but priming the snapshot failed (exit $($priming.ExitCode)); " +
            "the import's output is in $log and the snapshot is kept at $($location.Snapshot.Path). Last lines:`n$tail")
    }
    $location.Mode = 'snapshot'
    $location.Root = $location.Snapshot.Path
    $location.SystemTests = $false
    $location
}
