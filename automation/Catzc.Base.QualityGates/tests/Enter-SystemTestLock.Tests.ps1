<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
    kind: test
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The lock-holding helper''s Name parameter is consumed via $using: inside its Start-ThreadJob scriptblock, which this rule does not trace')]
param()

# L1: real named mutexes, held and abandoned from thread jobs. Every test passes its own unique lock name and
# record path, so no test ever touches the real per-user system-test lock.
Describe 'Enter-SystemTestLock' -Tag 'L1', 'logic', 'ADR-AUTO-TEST#33' {
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

        function script:Invoke-Enter {
            $parameters = @{ N = $script:name; P = $script:lockPath }
            InModuleScope Catzc.Base.QualityGates -Parameters $parameters {
                param($N, $P)
                Enter-SystemTestLock -EntryPoint 'Test-Automation' -RunDirectory 'C:\widget\out\20261013-194500' -RepositoryRoot 'C:\widget' -Name $N -LockPath $P
            }
        }
    }

    BeforeEach {
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        $script:name = 'Global\catzc-widget-system-' + [guid]::NewGuid().ToString('N')
        $script:lockPath = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N'))/system-test-lock.json"
        $script:lock = $null
        $script:holder = $null
    }

    AfterEach {
        if ($script:lock -and $script:lock.Mutex) {
            $script:lock.Mutex.ReleaseMutex()
            $script:lock.Mutex.Dispose()
        }
        if ($script:holder) {
            $script:holder.Release.Set()
            $script:holder.Job | Wait-Job | Remove-Job
        }
    }

    It 'takes a free lock and writes its record, naming the checkout' {
        $script:lock = Invoke-Enter
        $script:lock.Acquired | Should -BeTrue
        $script:lock.Mutex | Should -Not -BeNullOrEmpty
        $script:lock.LockPath | Should -Be $script:lockPath

        $record = [System.IO.File]::ReadAllText($script:lockPath) | ConvertFrom-Json
        $record.pid | Should -Be $PID
        $record.entryPoint | Should -Be 'Test-Automation'
        $record.repositoryRoot | Should -Be 'C:\widget'
    }

    It 'does not wait for a held lock, and names its holder and the holder''s checkout' {
        $script:holder = & $script:holdLock $script:name
        $record = [ordered]@{
            pid              = $PID
            processStartedAt = [System.Diagnostics.Process]::GetCurrentProcess().StartTime.ToUniversalTime().ToString('o')
            entryPoint       = 'Invoke-TestFile'
            startedAt        = [DateTimeOffset]::Now.ToString('o')
            runDirectory     = 'C:\gadget\out\test-file\20261013-194400-abc123'
            repositoryRoot   = 'C:\gadget'
        }
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($script:lockPath)) | Out-Null
        [System.IO.File]::WriteAllText($script:lockPath, (ConvertTo-Json -InputObject $record))

        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $script:lock = Invoke-Enter
        $stopwatch.Elapsed.TotalSeconds | Should -BeLessThan 2

        $script:lock.Acquired | Should -BeFalse
        $script:lock.Mutex | Should -BeNullOrEmpty
        $script:lock.Holder.Known | Should -BeTrue
        $script:lock.Holder.Description | Should -BeLike 'Invoke-TestFile (*in C:\gadget)'
    }

    It 'takes over an abandoned lock' {
        $name = $script:name
        Start-ThreadJob {
            $mutex = [System.Threading.Mutex]::new($false, $using:name)
            [void]$mutex.WaitOne()   # acquire and exit without releasing -> abandoned
        } | Wait-Job | Remove-Job

        $script:lock = Invoke-Enter
        $script:lock.Acquired | Should -BeTrue
    }
}
