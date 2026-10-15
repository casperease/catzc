<#
.SYNOPSIS
    Installs or upgrades uv, Astral's Python handler.
.DESCRIPTION
    uv is user-space on every platform.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment1)
.PARAMETER Version
    uv version to install. Defaults to the locked version in Get-ToolConfig.
.PARAMETER Force
    Upgrade even when a build is already present.
#>
function Install-Uv {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'uv').version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'uv'

    # Fresh machine: bootstrap per platform — winget on Windows and brew on macOS (both via Install-Tool); Astral's...
    # [comment:2](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment2)
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

    # Upgrade through the configured install source, not a blanket `uv self update`.
    # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment3)
    if ($IsLinux) {
        # Re-download the pinned, verified standalone build over ~/.local/bin — this also replaces an off-config uv...
        # [comment:4](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment4)
        Install-UvStandalone -Version $Version
        return
    }

    if ($IsMacOS) {
        # brew-managed — upgrade through brew (Install-Tool); brew cannot self-update either.
        Install-Tool -Tool 'uv' -Version $Version -Force:$Force
        return
    }

    # Windows: a winget-managed uv upgrades through winget; a uv installed by Astral's own script (on PATH outside...
    # [comment:5](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment5)
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
