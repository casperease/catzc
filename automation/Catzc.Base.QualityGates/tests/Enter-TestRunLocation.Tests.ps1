<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Enter-TestRunLocation.Tests.ps1
    kind: pester-test
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The lock-holding helper''s Name parameter is consumed via $using: inside its Start-ThreadJob scriptblock, which this rule does not trace')]
param()

# L1: real named mutexes, held and abandoned from thread jobs — the snapshot itself is mocked.
Describe 'Enter-TestRunLocation' -Tag 'L1', 'logic' {
    BeforeAll {
        # A lock held by another thread: a mutex is re-entrant on its owning thread, so a held lock is only...
        # [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/Enter-TestRunLocation.Tests.ps1.md#comment1)
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
        # The user's system-test lock is its own unit (Enter-SystemTestLock.Tests); here it is a seam, so no test...
        # [comment:2](/docs/references/automation/catzc-base-qualitygates/tests/Enter-TestRunLocation.Tests.ps1.md#comment2)
        Mock Enter-SystemTestLock {
            [pscustomobject]@{ Acquired = $false; Mutex = $null; LockPath = $null; Holder = [pscustomobject]@{ Description = 'Test-Automation (pid 4343)' } }
        } -ModuleName Catzc.Base.QualityGates
        $script:location = $null
        $script:holder = $null
        # These tests run inside a harness worker, which carries the parent run's location marker; each test starts...
        # [comment:3](/docs/references/automation/catzc-base-qualitygates/tests/Enter-TestRunLocation.Tests.ps1.md#comment3)
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
        $systemMutex = [System.Threading.Mutex]::new($false, 'Global\catzc-widget-system-' + [guid]::NewGuid().ToString('N'))
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
        [System.IO.File]::WriteAllText((Join-Path $script:outRoot '.test-run-lock.json'), (ConvertTo-Json -InputObject $record))

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

        [System.IO.File]::ReadAllText((Join-Path $snapshotPath 'out/cache/format-code.json')) | Should -Be '{"widget.ps1":"key"}'
    }

    It 'starts the snapshot without caches when the working folder has none' {
        $snapshotPath = Join-Path $TestDrive ('catzc-run-' + [guid]::NewGuid().ToString('N'))
        Mock New-RepositorySnapshot {
            [pscustomobject]@{ Path = $snapshotPath; SourceRoot = $SourceRoot; Commit = 'abc1234def'; Modified = 0; Untracked = 0; Deleted = 0 }
        } -ModuleName Catzc.Base.QualityGates

        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -Isolated }

        [System.IO.Directory]::Exists((Join-Path $snapshotPath 'out/cache')) | Should -BeFalse
    }

    It 'removes the snapshot and fails when priming it fails' {
        Mock Invoke-Executable { throw 'import failed' } -ModuleName Catzc.Base.QualityGates
        { InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Test-Automation' -Isolated } } |
            Should -Throw '*went to a snapshot, but priming the snapshot failed: import failed*'
        Should -Invoke Remove-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Path -like '*catzc-run-*' }
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
        [System.IO.File]::WriteAllText((Join-Path $script:outRoot '.test-run-lock.json'), (ConvertTo-Json -InputObject $record))
        $script:location = InModuleScope Catzc.Base.QualityGates { Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' }
        $script:location.Holder.Known | Should -BeFalse
        $script:location.Holder.Description | Should -BeLike '*stale*'
    }

    It 'takes over an abandoned lock and runs in place' {
        # A child process acquires and exits without releasing -> abandoned.
        # [comment:4](/docs/references/automation/catzc-base-qualitygates/tests/Enter-TestRunLocation.Tests.ps1.md#comment4)
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
