function Test-TypesHeld {
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $Hash,

        [string] $ShadowRoot = (Get-TypesShadowRoot)
    )

    # A hold is live while its process runs and started before the hold was written, so a reused process id never keeps a build.
    $held = $false
    foreach ($hold in [System.IO.Directory]::EnumerateFiles($ShadowRoot, "Catzc.Types.$Hash.*.hold")) {
        $holder = 0
        if (-not [int]::TryParse([System.IO.Path]::GetFileNameWithoutExtension($hold).Split('.')[-1], [ref] $holder)) {
            continue
        }
        $process = Get-Process -Id $holder -ErrorAction SilentlyContinue
        # A holder is always this user's own process; one that hides its StartTime reused a dead holder's id.
        if ($process -and $null -ne $process.StartTime -and $process.StartTime.ToUniversalTime() -le [System.IO.File]::GetLastWriteTimeUtc($hold)) {
            $held = $true
            continue
        }
        try {
            [System.IO.File]::Delete($hold)
        }
        catch {
            Write-Verbose "Could not delete a dead holder's hold: $hold"
        }
    }
    $held
}
