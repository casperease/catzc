# L1: a real named mutex, checked from a thread job — the snapshot removal itself is mocked.
Describe 'Exit-TestRunLocation' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Remove-RepositorySnapshot { } -ModuleName Catzc.Base.QualityGates
        $script:lockPath = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '.json')
        $script:mutexName = 'Global\catzc-widget-' + [guid]::NewGuid().ToString('N')
    }

    It 'deletes its own lock record and releases the lock for the next run' {
        $mutex = [System.Threading.Mutex]::new($false, $script:mutexName)
        [void]$mutex.WaitOne(0)
        [System.IO.File]::WriteAllText($script:lockPath, (ConvertTo-Json -InputObject @{ pid = $PID }))
        $location = [pscustomobject]@{ Mode = 'in-place'; Mutex = $mutex; LockPath = $script:lockPath; Snapshot = $null; KeepSandbox = $false; SystemTestLock = $null }

        InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $location } { param($L) Exit-TestRunLocation -Location $L }

        [System.IO.File]::Exists($script:lockPath) | Should -BeFalse
        # Another thread can take the lock at once: it was released, not left for abandonment.
        $name = $script:mutexName
        $acquiredElsewhere = Start-ThreadJob {
            $other = [System.Threading.Mutex]::new($false, $using:name)
            $got = $other.WaitOne(0)
            if ($got) {
                $other.ReleaseMutex()
            }
            $other.Dispose()
            $got
        } | Wait-Job | Receive-Job
        $acquiredElsewhere | Should -BeTrue
    }

    It 'leaves a lock record that another run has since written' {
        $mutex = [System.Threading.Mutex]::new($false, $script:mutexName)
        [void]$mutex.WaitOne(0)
        [System.IO.File]::WriteAllText($script:lockPath, (ConvertTo-Json -InputObject @{ pid = $PID + 100000 }))
        $location = [pscustomobject]@{ Mode = 'in-place'; Mutex = $mutex; LockPath = $script:lockPath; Snapshot = $null; KeepSandbox = $false; SystemTestLock = $null }

        InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $location } { param($L) Exit-TestRunLocation -Location $L }

        [System.IO.File]::Exists($script:lockPath) | Should -BeTrue
    }

    It 'releases the user''s system-test lock and deletes its record, as well as the working folder''s' {
        $mutex = [System.Threading.Mutex]::new($false, $script:mutexName)
        [void]$mutex.WaitOne(0)
        $systemName = 'Global\catzc-widget-system-' + [guid]::NewGuid().ToString('N')
        $systemMutex = [System.Threading.Mutex]::new($false, $systemName)
        [void]$systemMutex.WaitOne(0)
        $systemLockPath = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '.json')
        [System.IO.File]::WriteAllText($systemLockPath, (ConvertTo-Json -InputObject @{ pid = $PID }))
        $location = [pscustomobject]@{
            Mode = 'in-place'; Mutex = $mutex; LockPath = $null; Snapshot = $null; KeepSandbox = $false
            SystemTestLock = [pscustomobject]@{ Acquired = $true; Mutex = $systemMutex; LockPath = $systemLockPath; Holder = $null }
        }

        InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $location } { param($L) Exit-TestRunLocation -Location $L }

        [System.IO.File]::Exists($systemLockPath) | Should -BeFalse
        $acquiredElsewhere = Start-ThreadJob {
            $other = [System.Threading.Mutex]::new($false, $using:systemName)
            $got = $other.WaitOne(0)
            if ($got) {
                $other.ReleaseMutex()
            }
            $other.Dispose()
            $got
        } | Wait-Job | Receive-Job
        $acquiredElsewhere | Should -BeTrue
    }

    It 'removes a snapshot' {
        $location = [pscustomobject]@{ Mode = 'snapshot'; Mutex = $null; LockPath = $null; Snapshot = [pscustomobject]@{ Path = 'C:\tmp\catzc-run-widget' }; KeepSandbox = $false; SystemTestLock = $null }
        InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $location } { param($L) Exit-TestRunLocation -Location $L }
        Should -Invoke Remove-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Path -eq 'C:\tmp\catzc-run-widget' }
    }

    It 'keeps a snapshot the location was claimed with -KeepSandbox for, and names it' {
        $location = [pscustomobject]@{ Mode = 'snapshot'; Mutex = $null; LockPath = $null; Snapshot = [pscustomobject]@{ Path = 'C:\tmp\catzc-run-widget' }; KeepSandbox = $true; SystemTestLock = $null }
        InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $location } { param($L) Exit-TestRunLocation -Location $L }
        Should -Invoke Remove-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -like '*C:\tmp\catzc-run-widget*' }
    }
}
