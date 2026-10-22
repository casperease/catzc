<#
.SYNOPSIS
    Ends the burst Enter-CatzcBurst holds, so it releases the machine's run lock.

.DESCRIPTION
    Sets the burst event of the lock; the Enter-CatzcBurst run that holds the lock releases it and ends. Throws when no burst is held.

    pwsh -NoProfile -File pwsh/.internal/assets/Exit-CatzcBurst.ps1

.PARAMETER LockName
    The named mutex the burst holds. Default: Local\catzc-run, the lock of Invoke-CatzcCommand.
#>
param(
    [string] $LockName = 'Local\catzc-run'
)

Set-StrictMode -Version Latest

$burst = $null
if (-not [System.Threading.EventWaitHandle]::TryOpenExisting("$LockName-burst", [ref] $burst)) {
    throw "Exit-CatzcBurst: no burst holds $LockName."
}
try {
    $null = $burst.Set()
}
finally {
    $burst.Dispose()
}
"[Exit-CatzcBurst] ended the burst on $LockName"
