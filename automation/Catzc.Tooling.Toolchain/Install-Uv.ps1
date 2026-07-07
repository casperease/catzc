<#
.SYNOPSIS
    Installs or upgrades uv, Astral's Python handler.
.DESCRIPTION
    uv is user-space on every platform. A fresh machine bootstraps it via winget on Windows and brew on macOS
    (both hash-verified, user-scope, no admin), and from Astral's standalone GitHub release on Linux
    (Install-UvStandalone — verified download into ~/.local/bin; there is no uv apt package). An
    already-present uv is upgraded through its install source: Linux re-runs the standalone install
    (Install-UvStandalone — the extracted tarball carries no `uv self update` receipt), macOS re-runs brew and
    a winget-managed uv re-runs winget (both via Install-Tool); only a Windows uv installed by Astral's own
    script (receipt-backed) upgrades with `uv self update`. Idempotent — skips if the correct version is already
    on PATH.
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

    # Upgrade through the configured install source, not a blanket `uv self update`. The Linux bootstrap
    # extracts the standalone tarball into ~/.local/bin (no self-update receipt) and winget/brew are
    # package-manager-managed, so `uv self update` refuses all three ("installed via pip/brew/another package
    # manager"). Re-asserting the configured install upgrades in place.
    if ($IsLinux) {
        # Re-download the pinned, verified standalone build over ~/.local/bin — this also replaces an off-config
        # uv (e.g. a leftover pip-installed one) that happens to sit in the tool-bin.
        Install-UvStandalone -Version $Version
        return
    }

    if ($IsMacOS) {
        # brew-managed — upgrade through brew (Install-Tool); brew cannot self-update either.
        Install-Tool -Tool 'uv' -Version $Version -Force:$Force
        return
    }

    # Windows: a winget-managed uv upgrades through winget; a uv installed by Astral's own script (on PATH
    # outside the winget package root) carries a self-update receipt and upgrades in place.
    $wingetRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
    if ((Get-Command uv).Source.StartsWith($wingetRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        Install-Tool -Tool 'uv' -Version $Version -Force:$Force
        return
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
