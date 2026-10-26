# An import that starts while a burst swaps the files every import reads would load a half-applied change, so it waits until the burst ends;
# imports never wait for each other, since only a burst's event marks the swap window.
function Wait-ImportBurst {
    [CmdletBinding()]
    param(
        [string] $LockName = 'Local\catzc-run',

        # The most seconds to wait. Default: run_lock.wait_seconds of timeouts.yml, read only once a burst is seen.
        [int] $Seconds,

        [int] $PollMilliseconds = 250
    )

    # A burst's own runs, and every process they start, import inside the swap on purpose.
    if ($env:CATZC_IN_BURST) {
        return
    }
    $burst = $null
    if (-not [System.Threading.EventWaitHandle]::TryOpenExisting("$LockName-burst", [ref] $burst)) {
        return
    }
    $burst.Dispose()

    . (Join-Path $PSScriptRoot '../Wait-CatzcRunLock.ps1')
    if (-not $PSBoundParameters.ContainsKey('Seconds')) {
        $Seconds = (Get-CatzcRunLockSetting).wait_seconds
    }
    # The importer's own chokepoint, which a test run silences; dot-sourced alone, outside an import, the wait says nothing.
    if (Get-Command -Name Write-ImporterMessage -ErrorAction Ignore) {
        Write-ImporterMessage "a burst holds $LockName and is swapping files: waiting up to $Seconds s before importing"
    }
    $deadline = [datetime]::UtcNow.AddSeconds($Seconds)
    while ([System.Threading.EventWaitHandle]::TryOpenExisting("$LockName-burst", [ref] $burst)) {
        $burst.Dispose()
        if ([datetime]::UtcNow -ge $deadline) {
            $path = Get-CatzcRunLockHolderPath -LockName $LockName
            $holder = if ([System.IO.File]::Exists($path)) {
                ([System.IO.File]::ReadAllText($path)).Trim()
            }
            else {
                'no holder record'
            }
            throw "The import waited $Seconds s for a burst on $LockName that is still swapping files (holder: $holder); import again once it ends."
        }
        Start-Sleep -Milliseconds $PollMilliseconds
    }
}
