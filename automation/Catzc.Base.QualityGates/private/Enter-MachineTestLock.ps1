<#
.SYNOPSIS
    Acquires the machine-wide test lock for machine-tagged tests and returns it, owned.
.DESCRIPTION
    A repository snapshot isolates a test run from the working folder, not from the machine (ADR-AUTO-TEST:32).
    A 'machine'-tagged test changes state that belongs to the machine or the user — the user PATH or another
    user-level environment variable, installed tools — so two runs executing such tests at once, from any
    checkout, change the same state underneath each other. This lock serialises exactly those tests: one
    named [System.Threading.Mutex], Global\catzc-test-machine, the same for every checkout on the machine.

    It is the one place a test run waits for another, and the wait is narrow: only the phase holding
    machine-tagged files takes it. The wait goes through Wait-Mutex — silent when brief, announced with
    liveness dots when noticeable (ADR-AUTO-CONSOLE:10) — and an abandoned lock (its holder died) transfers.

    Inside a worker whose parent phase already holds the lock (CATZC_TEST_MACHINE_LOCK_HELD) it returns $null:
    the parent's ownership covers the worker, and waiting would deadlock on our own parent. The caller passes
    the result to Exit-MachineTestLock in a finally.
.OUTPUTS
    [System.Threading.Mutex] the owned lock, or $null inside a worker of a lock-holding phase.
#>
function Enter-MachineTestLock {
    [CmdletBinding()]
    [OutputType([System.Threading.Mutex])]
    param()

    if ($env:CATZC_TEST_MACHINE_LOCK_HELD -eq '1') {
        return $null
    }

    $lock = [System.Threading.Mutex]::new($false, 'Global\catzc-test-machine')
    Wait-Mutex $lock -Name 'machine test lock' `
        -AnnounceText 'Another test run is executing machine-tagged tests (user-level state) — waiting for it to finish them'
    $lock
}
