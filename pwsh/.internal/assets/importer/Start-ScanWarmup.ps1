function Start-ScanWarmup {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $Signature,

        [Parameter(Mandatory)]
        [string] $OutputRoot
    )

    # One warmup per signature on the machine: the marker is created exclusively, so a second console, or one racing this one, starts nothing.
    $markerFolder = [System.IO.Path]::Combine($OutputRoot, 'scan-warmup')
    $markerPath = [System.IO.Path]::Combine($markerFolder, [string]::Join('_', $Signature.Split([System.IO.Path]::GetInvalidFileNameChars())) + '.json')
    if ([System.IO.File]::Exists($markerPath)) {
        return $null
    }
    $null = [System.IO.Directory]::CreateDirectory($markerFolder)
    $record = [ordered]@{ signature = $Signature; started = [datetime]::UtcNow.ToString('o'); files = $null } | ConvertTo-Json -Compress
    $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes($record)
    try {
        $stream = [System.IO.FileStream]::new($markerPath, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write)
    }
    catch {
        return $null
    }
    try {
        $stream.Write($bytes, 0, $bytes.Length)
    }
    finally {
        $stream.Dispose()
    }

    $quote = { param($text) "'" + $text.Replace("'", "''") + "'" }
    $warmupScript = [System.IO.Path]::Combine($PSScriptRoot, 'Invoke-ScanWarmup.ps1')
    $command = ". $(& $quote $warmupScript); Invoke-ScanWarmup -RepositoryRoot $(& $quote $RepositoryRoot) -MarkerPath $(& $quote $markerPath) -Signature $(& $quote $Signature) *> `$null"
    $executable = [System.IO.Path]::Combine($PSHOME, ($IsWindows ? 'pwsh.exe' : 'pwsh'))
    $startInfo = [System.Diagnostics.ProcessStartInfo]::new($executable)
    foreach ($argument in @('-NoProfile', '-NonInteractive', '-WindowStyle', 'Hidden', '-Command', $command)) {
        $startInfo.ArgumentList.Add($argument)
    }
    # Detached and silent: no console of its own, every stream redirected and never read, since the child writes nothing.
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    try {
        $process = [System.Diagnostics.Process]::Start($startInfo)
    }
    catch {
        # A warmup that never started leaves no marker, so the next console import tries again.
        [System.IO.File]::Delete($markerPath)
        throw
    }
    try {
        $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle
    }
    catch {
        $null = $_
    }
    $process.StandardInput.Close()
    $process.Dispose()
    [pscustomobject]@{ Started = $true; Marker = $markerPath }
}
