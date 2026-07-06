<#
.SYNOPSIS
    Installs or upgrades uv, Astral's Python handler.
.DESCRIPTION
    uv is user-space on every platform. A fresh machine bootstraps it via winget on Windows and brew on macOS
    (both hash-verified, user-scope, no admin), and from Astral's standalone GitHub release on Linux
    (Install-UvStandalone — verified download into ~/.local/bin; there is no uv apt package). An
    already-present uv installed by Astral's standalone installer upgrades itself in place with
    `uv self update` — the standalone build's native, admin-free upgrade path, which a winget-managed uv does
    not support. Idempotent — skips if the correct version is already on PATH.
.PARAMETER Version
    uv version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Upgrade even when a build is already present.
#>
function Install-Uv {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'uv'
    if (-not $Version) {
        $Version = $config.version
    }

    # Fresh machine: bootstrap per platform — winget on Windows and brew on macOS (both via Install-Tool);
    # Astral's standalone release on Linux (user-space, ~/.local/bin — there is no uv apt package).
    if (-not (Test-Command 'uv')) {
        if ($IsLinux) {
            Install-UvStandalone -Version $Version
        }
        else {
            Install-Tool -Tool 'uv' -Version $Version
        }
        return
    }

    $installed = Get-ToolVersion -Config $config
    if (-not $Force -and $installed -and $installed.StartsWith($Version)) {
        Write-Message "uv $Version is already installed"
        return
    }

    # A winget-installed uv cannot self-update — route it through the winget upgrade path. A standalone uv
    # (Astral installer, on PATH outside the winget package root) upgrades itself with `uv self update`.
    # Windows-only: the winget package root does not exist elsewhere ($env:LOCALAPPDATA is unset on Unix).
    if ($IsWindows) {
        $wingetRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
        if ((Get-Command uv).Source.StartsWith($wingetRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            Install-Tool -Tool 'uv' -Version $Version -Force:$Force
            return
        }
    }

    Write-Message "Upgrading uv toward $Version (self-update)"
    Invoke-Executable 'uv self update'
    Sync-SessionPath

    $actual = Get-ToolVersion -Config $config
    if ($actual -and $actual.StartsWith($Version)) {
        Write-Message "uv $actual installed successfully"
    }
    else {
        Write-Message "uv self-updated to $actual, which does not match the locked $Version.x — bump the uv pin in tools.yml."
    }
}
