# cspell:ignore PYTHONPATH
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
        Mode              = 'in-place'
        SourceRoot        = $sourceRoot
        Root              = $sourceRoot
        Mutex             = $null
        LockPath          = $null
        Holder            = $null
        Snapshot          = $null
        KeepSandbox       = [bool] $KeepSandbox
        # A worker's in-place location inherits its parent's right to run L3; every other path decides below.
        SystemTests       = $true
        SystemTestLock    = $null
        SystemTestHolder  = $null
        # A snapshot's Python variables as they were before it set them, for Exit-TestRunLocation to put back.
        PythonEnvironment = $null
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

    # The snapshot's Python runs use the working folder's synced environment, read-only, through a junction.
    $pythonRelative = (Get-Config -Config python).ResolveRoot($sourceRoot)
    $sourceVenv = [System.IO.Path]::GetFullPath((Join-Path $sourceRoot "$pythonRelative/.venv"))
    $snapshotPython = Join-Path $location.Snapshot.Path $pythonRelative
    $pythonEnvironment = $null
    if ([System.IO.File]::Exists((Join-Path $sourceVenv 'pyvenv.cfg')) -and [System.IO.Directory]::Exists($snapshotPython)) {
        [void] (New-Item -ItemType Junction -Path (Join-Path $snapshotPython '.venv') -Target $sourceVenv)
        $packageRoot = Join-Path $location.Snapshot.Path 'out/python-packages'
        foreach ($project in @(Get-ChildPath $snapshotPython -File -Filter 'pyproject.toml' -Depth 2)) {
            $package = [regex]::Match([System.IO.File]::ReadAllText($project), '(?m)^packages\s*=\s*\["([^"]+)"\]').Groups[1].Value
            if ($package) {
                $link = Join-Path $packageRoot $package.Replace('.', '/')
                [void] [System.IO.Directory]::CreateDirectory((Split-Path -Parent $link))
                [void] (New-Item -ItemType Junction -Path $link -Target (Split-Path -Parent $project))
            }
        }
        $pythonPath = [System.Environment]::GetEnvironmentVariable('PYTHONPATH')
        $pythonEnvironment = [ordered]@{
            PYTHONPATH = if ($pythonPath) {
                $packageRoot + [System.IO.Path]::PathSeparator + $pythonPath
            }
            else {
                $packageRoot
            }
            UV_NO_SYNC = '1'
        }
    }

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
    Build-SnapshotReadme -SnapshotRoot $location.Snapshot.Path
    # The run's Python variables hold for this process and its workers until Exit-TestRunLocation puts the saved values back.
    if ($pythonEnvironment) {
        $location.PythonEnvironment = [ordered]@{}
        foreach ($name in $pythonEnvironment.Keys) {
            $location.PythonEnvironment[$name] = [System.Environment]::GetEnvironmentVariable($name)
            [System.Environment]::SetEnvironmentVariable($name, $pythonEnvironment[$name])
        }
    }
    $location.Mode = 'snapshot'
    $location.Root = $location.Snapshot.Path
    $location.SystemTests = $false
    $location
}
