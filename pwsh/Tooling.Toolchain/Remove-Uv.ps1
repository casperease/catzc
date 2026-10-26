function Remove-Uv {
    [CmdletBinding()]
    param(
        # The folder of the uv on PATH, else Astral's standalone folder ~/.local/bin.
        [Parameter(Position = 0)]
        [string] $InstallDir = (@(Get-Command uv -CommandType Application -ErrorAction Ignore | ForEach-Object { Split-Path $_.Source -Parent }) +
            (Join-Path $HOME '.local/bin'))[0],

        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'uv'

    # Off Windows the shared eviction runs, by the mechanism that placed the off-config uv.
    if (-not $IsWindows) {
        Remove-OffConfigInstall -Config $config -Label 'uv' -Tool 'Uv' -InstallDir $InstallDir -Force:$Force
        return
    }

    $resolvedDir = [System.IO.Path]::GetFullPath($InstallDir).TrimEnd('\', '/')

    if (Test-ExpectedPackageManager -Config $config -Path $resolvedDir) {
        throw "'$resolvedDir' is the managed uv install. Use Install-Uv -Force to repair it."
    }

    # A plain binary in a shared folder: only uv's own executables go, never the folder, which other tools share.
    $binaries = @('uv.exe', 'uvx.exe', 'uvw.exe' | ForEach-Object { Join-Path $resolvedDir $_ } |
            Where-Object { [System.IO.File]::Exists($_) })
    if ($binaries.Count -eq 0) {
        Write-Message "No uv binary in $resolvedDir — nothing to remove"
        return
    }

    if (-not $Force) {
        foreach ($binary in $binaries) {
            Write-Message "Would remove: $binary"
        }
        Write-Message 'Run with -Force to execute'
        return
    }

    foreach ($binary in $binaries) {
        [System.IO.File]::Delete($binary)
        Write-Message "Deleted: $binary"
    }
    Write-Message 'Run Install-Uv to install the managed uv'
}
