[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The lock-holding helper''s Name parameter is consumed via $using: inside its Start-ThreadJob scriptblock, which this rule does not trace')]
param()

# L1: real named mutexes, held and abandoned from thread jobs — the snapshot itself is mocked.
Describe 'Enter-TestRunSlot' -Tag 'L1', 'logic' {
    BeforeAll {
        # A lock held by another thread: a mutex is re-entrant on its owning thread, so a held lock is only
        # observable from a different thread. The thread job owns the named mutex until $release is set.
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
        # The user's system-test lock is its own unit (Enter-SystemTestLock.Tests); here it is a seam, so no test
        # takes the real per-user lock. By default another run holds it; the cases below override.
        Mock Enter-SystemTestLock {
            [pscustomobject]@{ Acquired = $false; Mutex = $null; LockPath = $null; Holder = [pscustomobject]@{ Description = 'Test-Automation (pid 4343)' } }
        } -ModuleName Catzc.Base.QualityGates
        $script:slot = $null
        $script:holder = $null
        # These tests run inside a harness worker, which carries the parent run's slot marker; each test starts
        # from a process that holds no slot, and the worker case sets the marker itself.
        $script:savedSlotHeld = $env:CATZC_TEST_RUN_SLOT_HELD
        $env:CATZC_TEST_RUN_SLOT_HELD = $null
    }

    AfterEach {
        $env:CATZC_TEST_RUN_SLOT_HELD = $script:savedSlotHeld
        if ($script:slot) {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ S = $script:slot } { param($S) Exit-TestRunSlot -Slot $S -KeepSandbox }
        }
        if ($script:holder) {
            $script:holder.Release.Set()
            $script:holder.Job | Wait-Job | Remove-Job
        }
    }

    It 'runs in place and owns the lock when the working folder is free, and writes the lock record' {
        $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Test-Automation' -RunDirectory 'C:\out\20261013-174616' }
        $script:slot.Mode | Should -Be 'InPlace'
        $script:slot.Root | Should -Be $script:root
        $script:slot.Mutex | Should -Not -BeNullOrEmpty
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

        $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Test-Automation' }
        $script:slot.Mode | Should -Be 'InPlace'
        $script:slot.SystemTests | Should -BeTrue
        $script:slot.SystemTestLock | Should -Be $lock
        $script:slot.SystemTestHolder | Should -BeNullOrEmpty
        Should -Invoke Enter-SystemTestLock -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $RepositoryRoot -eq $script:root }
    }

    It 'runs in place without L3 when another checkout holds the system-test lock, and names it' {
        $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Test-Automation' }
        $script:slot.Mode | Should -Be 'InPlace'
        $script:slot.Mutex | Should -Not -BeNullOrEmpty
        $script:slot.SystemTests | Should -BeFalse
        $script:slot.SystemTestLock | Should -BeNullOrEmpty
        $script:slot.SystemTestHolder.Description | Should -Be 'Test-Automation (pid 4343)'
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

        $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Invoke-TestFile' }
        $script:slot.Mode | Should -Be 'Snapshot'
        $script:slot.Mutex | Should -BeNullOrEmpty
        $script:slot.Root | Should -BeLike '*catzc-run-*'
        $script:slot.SourceRoot | Should -Be $script:root
        $script:slot.Holder.Known | Should -BeTrue
        Should -Invoke New-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $SourceRoot -eq $script:root }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -like 'pwsh -NoProfile -File *catzc-run-*importer.ps1"'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
            $Message -like "The repository is busy: Test-Automation (pid $PID, started *, run 20261013-174616) holds the test-run lock."
        }
    }

    It 'removes the snapshot and fails when priming it fails' {
        Mock Invoke-Executable { throw 'import failed' } -ModuleName Catzc.Base.QualityGates
        { InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Test-Automation' -Isolated } } | Should -Throw '*import failed*'
        Should -Invoke Remove-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Path -like '*catzc-run-*' }
    }

    It 'says plainly when the holder left no lock record' {
        $script:holder = & $script:holdLock (& $script:mutexName $script:root)
        $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Invoke-TestFile' }
        $script:slot.Holder.Known | Should -BeFalse
        $script:slot.Holder.Description | Should -BeLike '*left no lock record*'
    }

    It 'calls a record stale when its pid no longer belongs to the process that wrote it' {
        $script:holder = & $script:holdLock (& $script:mutexName $script:root)
        $record = [ordered]@{ pid = $PID; processStartedAt = '2001-01-01T00:00:00Z'; entryPoint = 'Test-Automation' }
        [System.IO.File]::WriteAllText((Join-Path $script:outRoot '.test-run-lock.json'), (ConvertTo-Json -InputObject $record))
        $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Invoke-TestFile' }
        $script:slot.Holder.Known | Should -BeFalse
        $script:slot.Holder.Description | Should -BeLike '*stale*'
    }

    It 'takes over an abandoned lock and runs in place' {
        # A child process acquires and exits without releasing -> abandoned. Not a thread job: Wait-Job returns
        # when the job turns Completed, which can be before its thread has exited, and only the exit abandons.
        $name = & $script:mutexName $script:root
        $acquireAndExit = "[void][System.Threading.Mutex]::new(`$false, '$name').WaitOne()"
        $holder = Start-Process pwsh -ArgumentList '-NoProfile', '-NonInteractive', '-Command', $acquireAndExit -NoNewWindow -PassThru
        $holder.WaitForExit()

        $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Test-Automation' }
        $script:slot.Mode | Should -Be 'InPlace'
        $script:slot.Mutex | Should -Not -BeNullOrEmpty
    }

    It 'runs in a snapshot under -Isolated without taking the free lock' {
        $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Test-Automation' -Isolated }
        $script:slot.Mode | Should -Be 'Snapshot'
        $script:slot.Mutex | Should -BeNullOrEmpty
        $script:slot.Holder | Should -BeNullOrEmpty
        $script:slot.SystemTests | Should -BeFalse
        Should -Invoke Enter-SystemTestLock -ModuleName Catzc.Base.QualityGates -Times 0
        [System.IO.File]::Exists((Join-Path $script:outRoot '.test-run-lock.json')) | Should -BeFalse
    }

    It 'runs in place without a lock inside a worker of a run that holds a slot' {
        $saved = $env:CATZC_TEST_RUN_SLOT_HELD
        $env:CATZC_TEST_RUN_SLOT_HELD = '1'
        try {
            $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Invoke-TestFile' }
        }
        finally {
            $env:CATZC_TEST_RUN_SLOT_HELD = $saved
        }
        $script:slot.Mode | Should -Be 'InPlace'
        $script:slot.Mutex | Should -BeNullOrEmpty
        $script:slot.LockPath | Should -BeNullOrEmpty
        # The parent run's slot decided L3 for the whole run; the worker inherits it and takes no lock itself.
        $script:slot.SystemTests | Should -BeTrue
        Should -Invoke Enter-SystemTestLock -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'still runs in a snapshot when -Isolated is asked for inside such a worker' {
        $saved = $env:CATZC_TEST_RUN_SLOT_HELD
        $env:CATZC_TEST_RUN_SLOT_HELD = '1'
        try {
            $script:slot = InModuleScope Catzc.Base.QualityGates { Enter-TestRunSlot -EntryPoint 'Invoke-TestFile' -Isolated }
        }
        finally {
            $env:CATZC_TEST_RUN_SLOT_HELD = $saved
        }
        $script:slot.Mode | Should -Be 'Snapshot'
        $script:slot.Mutex | Should -BeNullOrEmpty
    }
}
