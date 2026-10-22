<#
---
catzc:
  immutable:
    with_body_sha: "417af5ce24e6"
  edges:
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---
#>

<#
.SYNOPSIS
    Holds the machine's run lock for a session's import-path burst, until Exit-CatzcBurst ends it or its limit passes.

.DESCRIPTION
    A burst is a change every session's next import reads (an importer-path script, a type, a config the Bash hook validates), made and
    checked while no other run imports ([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](/docs/drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)).
    This takes the run lock Invoke-CatzcCommand runs under, in turn with every other waiter and up to -LockSeconds for the run that holds
    it (Wait-CatzcRunLock.ps1), and says it holds it in one line. Every other run then waits for as long as the burst lasts; the burst's
    own checks pass Invoke-CatzcCommand -InBurst. It holds until
    Exit-CatzcBurst.ps1 ends the burst or -Seconds pass, then releases the lock and says which. It imports nothing, so it runs in the
    background beside the burst, and the burst starts once its holding line is printed.

    timeout 360 pwsh -NoProfile -File pwsh/.internal/assets/Enter-CatzcBurst.ps1 -Seconds 300

.PARAMETER Seconds
    The most seconds the burst holds the lock. Default: 300, inside the 360 s background roof of the time safeguard.

.PARAMETER LockName
    The named mutex every run takes. Default: Local\catzc-run, the lock of Invoke-CatzcCommand.

.PARAMETER LockSeconds
    The most seconds the burst waits for the run that holds the lock. Default: 120.
#>
param(
    [ValidateRange(1, 360)]
    [int] $Seconds = 300,

    [string] $LockName = 'Local\catzc-run',

    [ValidateRange(1, 360)]
    [int] $LockSeconds = 120
)

Set-StrictMode -Version Latest

# A burst queues for the lock like any run; the waiting lines pass through as they happen.
. (Join-Path $PSScriptRoot 'Wait-CatzcRunLock.ps1')
$taken = [ref] $null
Wait-CatzcRunLock -LockName $LockName -LockSeconds $LockSeconds -Caller 'Enter-CatzcBurst' -Busy 'no burst started' -Lock $taken
$lock = $taken.Value
if ($null -eq $lock) {
    exit 1
}

# The burst event exists only while the lock is held: Exit-CatzcBurst sets it, and Invoke-CatzcCommand -InBurst looks for it.
$burst = [System.Threading.EventWaitHandle]::new($false, [System.Threading.EventResetMode]::ManualReset, "$LockName-burst")
try {
    "[Enter-CatzcBurst] holding the run lock for up to $Seconds s; end the burst with Exit-CatzcBurst.ps1"
    if ($burst.WaitOne([timespan]::FromSeconds($Seconds))) {
        '[Enter-CatzcBurst] released the run lock: Exit-CatzcBurst ended the burst'
    }
    else {
        "[Enter-CatzcBurst] released the run lock: the $Seconds s limit passed"
    }
}
finally {
    $burst.Dispose()
    $lock.ReleaseMutex()
    $lock.Dispose()
}
