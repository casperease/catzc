# The shared run-lock fixture: the waiter dot-sourced, and the in-process waiters and lock holders the run-lock tests start and stop.
$script:waiter = Join-Path $PSScriptRoot '../assets/Wait-CatzcRunLock.ps1'
. $script:waiter
function script:Start-Waiter {
    param([string] $Name, [string] $Waiter, [System.Collections.Concurrent.ConcurrentQueue[string]] $Order)
    $shell = [powershell]::Create().AddScript({
            param($Path, $Name, $Waiter, $Order)
            . $Path
            $taken = [ref] $null
            $null = Wait-CatzcRunLock -LockName $Name -LockSeconds 5 -BudgetSeconds 60 -StaleSeconds 720 -Holding $Waiter -Caller $Waiter -Busy 'nothing ran' -Lock $taken
            if ($taken.Value) {
                $Order.Enqueue($Waiter)
                Start-Sleep -Milliseconds 50
                # As every caller does: the holder record goes before the lock is let go.
                Remove-CatzcRunLockHolder -LockName $Name
                $taken.Value.ReleaseMutex()
                $taken.Value.Dispose()
            }
        }).AddArgument($script:waiter).AddArgument($Name).AddArgument($Waiter).AddArgument($Order)
    [pscustomobject]@{ Shell = $shell; Handle = $shell.BeginInvoke() }
}
function script:Stop-Waiter {
    param($Waiter)
    $null = $Waiter.Shell.EndInvoke($Waiter.Handle)
    $Waiter.Shell.Dispose()
}
function script:Start-LockHolder {
    param([string] $Name, [int] $Milliseconds, [System.Threading.EventWaitHandle] $Burst, [int] $RecordSeconds)
    $taken = [System.Threading.ManualResetEventSlim]::new($false)
    # Set by Stop-LockHolder: the holder keeps the lock its full time while the test waits, never past the test's verdict.
    $release = [System.Threading.ManualResetEventSlim]::new($false)
    $shell = [powershell]::Create().AddScript({
            param($Name, $Milliseconds, $Taken, $Burst, $RecordSeconds, $Path, $Release)
            . $Path
            $held = [System.Threading.Mutex]::new($false, $Name)
            $null = $held.WaitOne()
            if ($RecordSeconds -gt 0) {
                Set-CatzcRunLockHolder -LockName $Name -Seconds $RecordSeconds -Holding 'Get-Gadget'
            }
            $Taken.Set()
            $null = $Release.Wait($Milliseconds)
            if ($Burst) {
                $Burst.Dispose()
            }
            Remove-CatzcRunLockHolder -LockName $Name
            $held.ReleaseMutex()
            $held.Dispose()
        }).AddArgument($Name).AddArgument($Milliseconds).AddArgument($taken).AddArgument($Burst).AddArgument($RecordSeconds).AddArgument($script:waiter).AddArgument($release)
    $handle = $shell.BeginInvoke()
    [pscustomobject]@{ Shell = $shell; Handle = $handle; Taken = $taken.Wait(2000); Release = $release }
}
function script:Stop-LockHolder {
    param($Holder)
    $Holder.Release.Set()
    $null = $Holder.Shell.EndInvoke($Holder.Handle)
    $Holder.Shell.Dispose()
    $Holder.Release.Dispose()
}
function script:Get-QueueFolder {
    param([string] $Name)
    Join-Path ([System.IO.Path]::GetTempPath()) "catzc-run-queue/$($Name -replace '[\\/:*?"<>|]', '_')"
}
