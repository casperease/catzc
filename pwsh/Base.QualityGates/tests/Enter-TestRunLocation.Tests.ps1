[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
    Justification = 'The lock-holding helper''s Name parameter is consumed via $using: inside its Start-ThreadJob scriptblock, which this rule does not trace')]
param()

# L1: real named mutexes, held and abandoned from thread jobs — the snapshot itself is mocked.
Describe 'Enter-TestRunLocation' -Tag 'L1', 'logic' {
    BeforeAll {
        # A mutex is re-entrant on its owning thread, so only another thread can observe it held.
        $script:holdLock = {
            param([string] $Name)
            $acquired = [System.Threading.ManualResetEventSlim]::new($false)
            $release = [System.Threading.ManualResetEventSlim]::new($false)
            $job = Start-ThreadJob {
                $mutex = [System.Threading.Mutex]::new($false, $using:Name)
                [void]$mutex.WaitOne()
                ($using:acquired).Set()
                [void]($using:release).Wait(30000)
                $mutex.ReleaseMutex()
                $mutex.Dispose()
            }
            [void]$acquired.Wait(10000)
            @{ Job = $job; Release = $release }
        }
        $script:mutexName = {
            param([string] $Root)
            'Global\catzc-test-automation-' + [Convert]::ToHexString(
                [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($Root.ToLowerInvariant())))
        }
    }

    BeforeEach {
        # A unique fake root per test keys a unique mutex, so no test ever touches the real repository's lock.
        $script:root = 'C:\widget-' + [guid]::NewGuid().ToString('N')
        $script:outRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:outRoot) | Out-Null
        $root = $script:root
        $outRoot = $script:outRoot
        Mock Get-RepositoryRoot { $root } -ModuleName Catzc.Base.QualityGates
        Mock Get-OutputRoot { $outRoot } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock New-RepositorySnapshot {
            [pscustomobject]@{ Path = $Destination; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 1; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates
        Mock Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '' } } -ModuleName Catzc.Base.QualityGates
        Mock Remove-RepositorySnapshot { } -ModuleName Catzc.Base.QualityGates
        # A seam, so no test takes the real per-user lock.
        Mock Enter-SystemTestLock {
            [pscustomobject]@{ Acquired = $false; Mutex = $null; LockPath = $null; Holder = [pscustomobject]@{ Description = 'Test-Automation (pid 4343)' } }
        } -ModuleName Catzc.Base.QualityGates
        $script:location = $null
        $script:holder = $null
        # The harness worker carries the parent run's location marker, so each test starts clear of it.
        $script:savedLocationHeld = $env:CATZC_TEST_RUN_LOCATION_HELD
        $env:CATZC_TEST_RUN_LOCATION_HELD = $null
    }

    AfterEach {
        $env:CATZC_TEST_RUN_LOCATION_HELD = $script:savedLocationHeld
        if ($script:location) {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $script:location } { param($L) Exit-TestRunLocation -Location $L }
        }
        if ($script:holder) {
            $script:holder.Release.Set()
            $script:holder.Job | Wait-Job | Remove-Job
        }
    }

    It 'runs in place and owns the lock when the working folder is free, and writes the lock record' {
        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Test-Automation' -RunDirectory 'C:\out\20261013-174616' }
        $script:location.Mode | Should -Be 'in-place'
        $script:location.Root | Should -Be $script:root
        $script:location.Mutex | Should -Not -BeNullOrEmpty
        $script:location.KeepSandbox | Should -BeFalse
        Should -Invoke New-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 0

        $record = [System.IO.File]::ReadAllText((Join-Path $script:outRoot '.test-run-lock.json')) | ConvertFrom-Json
        $record.pid | Should -Be $PID
        $record.entryPoint | Should -Be 'Test-Automation'
        $record.runDirectory | Should -Be 'C:\out\20261013-174616'
        $record.repositoryRoot | Should -Be $script:root
    }

    It 'may run L3 in place when it also takes the user''s system-test lock' {
        $systemMutex = [System.Threading.Mutex]::new($false,
            'Global\catzc-widget-system-' + [guid]::NewGuid().ToString('N'))
        [void]$systemMutex.WaitOne(0)
        $lock = [pscustomobject]@{ Acquired = $true; Mutex = $systemMutex; LockPath = $null; Holder = $null }
        Mock Enter-SystemTestLock { $lock } -ModuleName Catzc.Base.QualityGates

        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Test-Automation' }
        $script:location.Mode | Should -Be 'in-place'
        $script:location.SystemTests | Should -BeTrue
        $script:location.SystemTestLock | Should -Be $lock
        $script:location.SystemTestHolder | Should -BeNullOrEmpty
        Should -Invoke Enter-SystemTestLock -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $RepositoryRoot -eq $script:root }
    }

    It 'runs in place without L3 when another checkout holds the system-test lock, and names it' {
        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Test-Automation' }
        $script:location.Mode | Should -Be 'in-place'
        $script:location.Mutex | Should -Not -BeNullOrEmpty
        $script:location.SystemTests | Should -BeFalse
        $script:location.SystemTestLock | Should -BeNullOrEmpty
        $script:location.SystemTestHolder.Description | Should -Be 'Test-Automation (pid 4343)'
    }

    It 'runs in a snapshot without waiting when another run holds the lock, and names the holder' {
        $script:holder = & $script:holdLock (& $script:mutexName $script:root)
        $record = [ordered]@{
            pid              = $PID
            processStartedAt = [System.Diagnostics.Process]::GetCurrentProcess().StartTime.ToUniversalTime().ToString('o')
            entryPoint       = 'Test-Automation'
            startedAt        = [DateTimeOffset]::Now.ToString('o')
            runDirectory     = 'C:\out\20261013-174616'
        }
        [System.IO.File]::WriteAllText((Join-Path $script:outRoot '.test-run-lock.json'),
            (ConvertTo-Json -InputObject $record))

        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' }
        $script:location.Mode | Should -Be 'snapshot'
        $script:location.Mutex | Should -BeNullOrEmpty
        $script:location.Root | Should -BeLike '*catzc-run-*'
        $script:location.SourceRoot | Should -Be $script:root
        $script:location.Holder.Known | Should -BeTrue
        Should -Invoke New-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $SourceRoot -eq $script:root }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -like 'pwsh -NoProfile -NonInteractive -File *catzc-run-*importer.ps1"'
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -like 'pwsh -NoProfile -NonInteractive -Command ". *catzc-run-*importer.ps1'' -SkipJanitors; Build-Readme -Silent*'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $Message -like "The repository is busy: Test-Automation (pid $PID, started *, run 20261013-174616) holds the test-run lock."
        }
    }

    It 'starts the snapshot with the working folder''s result caches' {
        $cache = Join-Path $script:outRoot 'cache'
        [System.IO.Directory]::CreateDirectory($cache) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $cache 'format-code.json'), '{"widget.ps1":"key"}')
        $snapshotPath = Join-Path $TestDrive ('catzc-run-' + [guid]::NewGuid().ToString('N'))
        Mock New-RepositorySnapshot {
            [pscustomobject]@{ Path = $snapshotPath; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 0; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates

        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated }

        [System.IO.File]::ReadAllText((Join-Path $snapshotPath 'out/cache/format-code.json')) |
            Should -Be '{"widget.ps1":"key"}'
    }

    It 'starts the snapshot without caches when the working folder has none' {
        $snapshotPath = Join-Path $TestDrive ('catzc-run-' + [guid]::NewGuid().ToString('N'))
        Mock New-RepositorySnapshot {
            [pscustomobject]@{ Path = $snapshotPath; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 0; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates

        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated }

        [System.IO.Directory]::Exists((Join-Path $snapshotPath 'out/cache')) | Should -BeFalse
    }

    It 'starts the snapshot with the published agent hooks and their source stamps, and without them when there are none' {
        $hooks = Join-Path $script:root '.claude/hooks/bin'
        [System.IO.Directory]::CreateDirectory($hooks) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $hooks 'Widget.source.sha256'), 'gadget-hash')
        $snapshotPath = Join-Path $TestDrive ('catzc-run-' + [guid]::NewGuid().ToString('N'))
        Mock New-RepositorySnapshot {
            [pscustomobject]@{ Path = $snapshotPath; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 0; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates

        try {
            $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated }
            [System.IO.File]::ReadAllText((Join-Path $snapshotPath '.claude/hooks/bin/Widget.source.sha256')) | Should -Be 'gadget-hash'
        }
        finally {
            [System.IO.Directory]::Delete((Join-Path $script:root '.claude'), $true)
        }

        $bareSnapshot = Join-Path $TestDrive ('catzc-run-' + [guid]::NewGuid().ToString('N'))
        Mock New-RepositorySnapshot {
            [pscustomobject]@{ Path = $bareSnapshot; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 0; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates
        InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $script:location } { param($L) Exit-TestRunLocation -Location $L }
        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated }
        [System.IO.Directory]::Exists((Join-Path $bareSnapshot '.claude/hooks/bin')) | Should -BeFalse
    }

    It 'syncs the snapshot''s own Python environment offline from the working folder''s lock, and stops uv syncing until the run exits' {
        $widgetRoot = Join-Path $TestDrive ('widget-' + [guid]::NewGuid().ToString('N'))
        $venv = Join-Path $widgetRoot 'python/.venv'
        [System.IO.Directory]::CreateDirectory($venv) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $venv 'pyvenv.cfg'), 'prompt = widget')
        [System.IO.File]::WriteAllText((Join-Path $widgetRoot 'python/uv.lock'), 'widget-lock')
        Mock Get-RepositoryRoot { $widgetRoot } -ModuleName Catzc.Base.QualityGates
        $snapshotPath = Join-Path $TestDrive ('catzc-run-' + [guid]::NewGuid().ToString('N'))
        Mock New-RepositorySnapshot {
            [System.IO.Directory]::CreateDirectory((Join-Path $snapshotPath 'python')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $snapshotPath 'python/pyproject.toml'), '[tool.uv.workspace]')
            [pscustomobject]@{ Path = $snapshotPath; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 0; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates
        Mock Resolve-ToolExecutable { [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\gadget\uv.exe' } } -ModuleName Catzc.Base.QualityGates
        $seen = @{}
        Mock Invoke-Executable {
            $seen.Offline = $env:UV_OFFLINE
            $seen.Project = $env:UV_PROJECT_ENVIRONMENT
            $seen.Lock = [System.IO.File]::ReadAllText((Join-Path $snapshotPath 'python/uv.lock'))
            [pscustomobject]@{ ExitCode = 0; Output = ''; Full = '' }
        } -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like '*sync --all-packages*' }
        $savedNoSync = $env:UV_NO_SYNC
        $savedOffline = $env:UV_OFFLINE
        $savedProject = $env:UV_PROJECT_ENVIRONMENT
        $env:UV_NO_SYNC = $null
        $env:UV_OFFLINE = $null
        $env:UV_PROJECT_ENVIRONMENT = 'C:\gadget\.venv'
        try {
            $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated }

            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
                $Command -eq '"C:\gadget\uv.exe" sync --all-packages --quiet --offline' -and
                $WorkingDirectory -eq (Join-Path $snapshotPath 'python')
            }
            $seen.Offline | Should -Be '1'
            $seen.Project | Should -Be (Join-Path $snapshotPath 'python/.venv')
            $seen.Lock | Should -Be 'widget-lock'
            Test-Path -LiteralPath (Join-Path $snapshotPath 'out/python-packages') | Should -BeFalse
            $env:UV_NO_SYNC | Should -Be '1'
            $env:UV_OFFLINE | Should -BeNullOrEmpty
            $env:UV_PROJECT_ENVIRONMENT | Should -Be 'C:\gadget\.venv'

            InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $script:location } { param($L) Exit-TestRunLocation -Location $L }
            $script:location = $null
            $env:UV_NO_SYNC | Should -BeNullOrEmpty
        }
        finally {
            $env:UV_NO_SYNC = $savedNoSync
            $env:UV_OFFLINE = $savedOffline
            $env:UV_PROJECT_ENVIRONMENT = $savedProject
        }
    }

    It 'syncs no Python environment when the working folder has none synced' {
        $widgetRoot = Join-Path $TestDrive ('widget-' + [guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $widgetRoot 'python')) | Out-Null
        Mock Get-RepositoryRoot { $widgetRoot } -ModuleName Catzc.Base.QualityGates
        $snapshotPath = Join-Path $TestDrive ('catzc-run-' + [guid]::NewGuid().ToString('N'))
        Mock New-RepositorySnapshot {
            [System.IO.Directory]::CreateDirectory((Join-Path $snapshotPath 'python')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $snapshotPath 'python/pyproject.toml'), '[tool.uv.workspace]')
            [pscustomobject]@{ Path = $snapshotPath; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 0; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates

        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated }

        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Command -like '*sync --all-packages*' }
        Test-Path -LiteralPath (Join-Path $snapshotPath 'python/.venv') | Should -BeFalse
        $script:location.PythonEnvironment | Should -BeNullOrEmpty
    }

    It 'fails the isolated run, naming the online Install-PythonWorkspace, when the offline sync misses the cache' {
        $widgetRoot = Join-Path $TestDrive ('widget-' + [guid]::NewGuid().ToString('N'))
        $venv = Join-Path $widgetRoot 'python/.venv'
        [System.IO.Directory]::CreateDirectory($venv) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $venv 'pyvenv.cfg'), 'prompt = widget')
        Mock Get-RepositoryRoot { $widgetRoot } -ModuleName Catzc.Base.QualityGates
        $snapshotPath = Join-Path $TestDrive ('catzc-run-' + [guid]::NewGuid().ToString('N'))
        Mock New-RepositorySnapshot {
            [System.IO.Directory]::CreateDirectory((Join-Path $snapshotPath 'python')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $snapshotPath 'python/pyproject.toml'), '[tool.uv.workspace]')
            [pscustomobject]@{ Path = $snapshotPath; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 0; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates
        Mock Resolve-ToolExecutable { [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\gadget\uv.exe' } } -ModuleName Catzc.Base.QualityGates
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 2; Output = ''; Full = 'widget-sprockets was not found in the cache' }
        } -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like '*sync --all-packages*' }
        $savedNoSync = $env:UV_NO_SYNC
        $env:UV_NO_SYNC = $null
        try {
            { InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated } } |
                Should -Throw '*could not be synced offline (exit 2)*Run Install-PythonWorkspace once online*widget-sprockets was not found*'
            $env:UV_NO_SYNC | Should -BeNullOrEmpty
            Test-Path -LiteralPath (Join-Path $snapshotPath 'python/.venv') | Should -BeFalse
        }
        finally {
            $env:UV_NO_SYNC = $savedNoSync
        }
    }

    It 'keeps the snapshot and the import''s output when priming fails, and throws the cause' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 1; Output = ''; Full = "loading widgets`nthe gadget type failed to compile" }
        } -ModuleName Catzc.Base.QualityGates
        $thrown = $null
        try {
            InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Test-Automation' -Isolated }
        }
        catch {
            $thrown = $_.Exception.Message
        }
        $thrown |
            Should -BeLike '*went to a snapshot, but priming the snapshot failed (exit 1)*the gadget type failed to compile*'
        Should -Invoke Remove-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 0
        $log = @([System.IO.Directory]::GetFiles((Join-Path $script:outRoot 'test-snapshot-priming'),
                'catzc-run-*.log'))
        $log | Should -HaveCount 1
        [System.IO.File]::ReadAllText($log[0]) | Should -BeExactly "loading widgets`nthe gadget type failed to compile"
        $thrown | Should -BeLike "*$($log[0])*"
    }

    It 'says plainly when the holder left no lock record' {
        $script:holder = & $script:holdLock (& $script:mutexName $script:root)
        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' }
        $script:location.Holder.Known | Should -BeFalse
        $script:location.Holder.Description | Should -BeLike '*left no lock record*'
    }

    It 'calls a record stale when its pid no longer belongs to the process that wrote it' {
        $script:holder = & $script:holdLock (& $script:mutexName $script:root)
        $record = [ordered]@{ pid = $PID; processStartedAt = '2001-01-01T00:00:00Z'; entryPoint = 'Test-Automation' }
        [System.IO.File]::WriteAllText((Join-Path $script:outRoot '.test-run-lock.json'),
            (ConvertTo-Json -InputObject $record))
        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' }
        $script:location.Holder.Known | Should -BeFalse
        $script:location.Holder.Description | Should -BeLike '*stale*'
    }

    It 'takes over an abandoned lock and runs in place' {
        # A child process, not a thread job: only a process exit abandons the mutex.
        $name = & $script:mutexName $script:root
        $acquireAndExit = "[void][System.Threading.Mutex]::new(`$false, '$name').WaitOne()"
        $holder = Start-Process pwsh -ArgumentList '-NoProfile', '-NonInteractive', '-Command', $acquireAndExit -NoNewWindow -PassThru
        $holder.WaitForExit()

        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Test-Automation' }
        $script:location.Mode | Should -Be 'in-place'
        $script:location.Mutex | Should -Not -BeNullOrEmpty
    }

    It 'runs in a snapshot under -Isolated without taking the free lock, and records -KeepSandbox' {
        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Test-Automation' -Isolated -KeepSandbox }
        $script:location.Mode | Should -Be 'snapshot'
        $script:location.Mutex | Should -BeNullOrEmpty
        $script:location.Holder | Should -BeNullOrEmpty
        $script:location.SystemTests | Should -BeFalse
        $script:location.KeepSandbox | Should -BeTrue
        Should -Invoke Enter-SystemTestLock -ModuleName Catzc.Base.QualityGates -Times 0
        [System.IO.File]::Exists((Join-Path $script:outRoot '.test-run-lock.json')) | Should -BeFalse
    }

    It 'runs in place without a lock inside a worker of a run that holds its location' {
        $saved = $env:CATZC_TEST_RUN_LOCATION_HELD
        $env:CATZC_TEST_RUN_LOCATION_HELD = '1'
        try {
            $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' }
        }
        finally {
            $env:CATZC_TEST_RUN_LOCATION_HELD = $saved
        }
        $script:location.Mode | Should -Be 'in-place'
        $script:location.Mutex | Should -BeNullOrEmpty
        $script:location.LockPath | Should -BeNullOrEmpty
        # The parent run's location decided L3 for the whole run; the worker inherits it and takes no lock itself.
        $script:location.SystemTests | Should -BeTrue
        Should -Invoke Enter-SystemTestLock -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'still runs in a snapshot when -Isolated is asked for inside such a worker' {
        $saved = $env:CATZC_TEST_RUN_LOCATION_HELD
        $env:CATZC_TEST_RUN_LOCATION_HELD = '1'
        try {
            $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated }
        }
        finally {
            $env:CATZC_TEST_RUN_LOCATION_HELD = $saved
        }
        $script:location.Mode | Should -Be 'snapshot'
        $script:location.Mutex | Should -BeNullOrEmpty
    }
}
