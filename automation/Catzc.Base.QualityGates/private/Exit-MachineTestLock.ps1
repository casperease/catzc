<#
.SYNOPSIS
    Releases the machine-wide test lock acquired by Enter-MachineTestLock.
.DESCRIPTION
    Releases and disposes the lock. A $null lock — a worker covered by its parent's ownership — releases
    nothing.
.PARAMETER Lock
    Enter-MachineTestLock's result.
.OUTPUTS
    None.
#>
function Exit-MachineTestLock {
    [CmdletBinding()]
    param(
        [AllowNull()]
        [System.Threading.Mutex] $Lock
    )

    if ($Lock) {
        $Lock.ReleaseMutex()
        $Lock.Dispose()
    }
}
