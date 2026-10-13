# L1: a real named mutex, checked from a thread job — the snapshot removal itself is mocked.
Describe 'Exit-TestRunSlot' -Tag 'L1', 'logic' {
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
        $slot = [pscustomobject]@{ Mode = 'InPlace'; Mutex = $mutex; LockPath = $script:lockPath; Snapshot = $null }

        InModuleScope Catzc.Base.QualityGates -Parameters @{ S = $slot } { param($S) Exit-TestRunSlot -Slot $S }

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
        $slot = [pscustomobject]@{ Mode = 'InPlace'; Mutex = $mutex; LockPath = $script:lockPath; Snapshot = $null }

        InModuleScope Catzc.Base.QualityGates -Parameters @{ S = $slot } { param($S) Exit-TestRunSlot -Slot $S }

        [System.IO.File]::Exists($script:lockPath) | Should -BeTrue
    }

    It 'removes a snapshot' {
        $slot = [pscustomobject]@{ Mode = 'Snapshot'; Mutex = $null; LockPath = $null; Snapshot = [pscustomobject]@{ Path = 'C:\tmp\catzc-run-widget' } }
        InModuleScope Catzc.Base.QualityGates -Parameters @{ S = $slot } { param($S) Exit-TestRunSlot -Slot $S }
        Should -Invoke Remove-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Path -eq 'C:\tmp\catzc-run-widget' }
    }

    It 'keeps a snapshot under -KeepSandbox and names it' {
        $slot = [pscustomobject]@{ Mode = 'Snapshot'; Mutex = $null; LockPath = $null; Snapshot = [pscustomobject]@{ Path = 'C:\tmp\catzc-run-widget' } }
        InModuleScope Catzc.Base.QualityGates -Parameters @{ S = $slot } { param($S) Exit-TestRunSlot -Slot $S -KeepSandbox }
        Should -Invoke Remove-RepositorySnapshot -ModuleName Catzc.Base.QualityGates -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -like '*C:\tmp\catzc-run-widget*' }
    }
}
