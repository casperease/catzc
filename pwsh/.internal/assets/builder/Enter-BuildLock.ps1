function Enter-BuildLock {
    [CmdletBinding()]
    [OutputType([System.Threading.Mutex])]
    param(
        [Parameter(Mandatory)]
        [string] $BuildRoot
    )

    # The name is the first 16 hex of the SHA-256 of the lower-case build root, so each root has its own lock on the machine.
    $hash = [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($BuildRoot.ToLowerInvariant()))
    $mutex = [System.Threading.Mutex]::new($false, 'Local\catzc-build-' + [System.Convert]::ToHexString($hash).Substring(0, 16).ToLowerInvariant())
    $seconds = Get-TimeoutSeconds -Command Build-Modules
    $held = $false
    try {
        $held = $mutex.WaitOne([System.TimeSpan]::FromSeconds($seconds))
    }
    catch [System.Threading.AbandonedMutexException] {
        # The holder died; the mutex is ours now.
        $held = $true
    }
    if (-not $held) {
        Write-Verbose "Enter-BuildLock: no lock on $BuildRoot after $seconds s; building anyway."
        $mutex.Dispose()
        return $null
    }
    $mutex
}
