# L1: the real machine-wide named mutex — contended from a thread job; Wait-Mutex's own timing is its tests' concern.
Describe 'Enter-MachineTestLock' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Write-Message { } -ModuleName Catzc.Base.Execution
        $script:savedHeld = $env:CATZC_TEST_MACHINE_LOCK_HELD
        $env:CATZC_TEST_MACHINE_LOCK_HELD = $null
    }

    AfterEach {
        $env:CATZC_TEST_MACHINE_LOCK_HELD = $script:savedHeld
    }

    It 'returns the owned machine-wide lock, and Exit-MachineTestLock releases it for the next run' {
        $lock = InModuleScope Catzc.Base.QualityGates { Enter-MachineTestLock }
        try {
            $lock | Should -BeOfType [System.Threading.Mutex]
            $takenElsewhere = Start-ThreadJob {
                $other = [System.Threading.Mutex]::new($false, 'Global\catzc-test-machine')
                $got = $other.WaitOne(0)
                $other.Dispose()
                $got
            } | Wait-Job | Receive-Job
            $takenElsewhere | Should -BeFalse -Because 'the lock is held'
        }
        finally {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $lock } { param($L) Exit-MachineTestLock -Lock $L }
        }

        $takenAfterRelease = Start-ThreadJob {
            $other = [System.Threading.Mutex]::new($false, 'Global\catzc-test-machine')
            $got = $other.WaitOne(0)
            if ($got) {
                $other.ReleaseMutex()
            }
            $other.Dispose()
            $got
        } | Wait-Job | Receive-Job
        $takenAfterRelease | Should -BeTrue -Because 'Exit-MachineTestLock released it'
    }

    It 'returns nothing inside a worker whose parent phase holds the lock, and Exit-MachineTestLock accepts that' {
        $env:CATZC_TEST_MACHINE_LOCK_HELD = '1'
        $lock = InModuleScope Catzc.Base.QualityGates { Enter-MachineTestLock }
        $lock | Should -BeNullOrEmpty
        { InModuleScope Catzc.Base.QualityGates { Exit-MachineTestLock -Lock $null } } | Should -Not -Throw
    }
}
