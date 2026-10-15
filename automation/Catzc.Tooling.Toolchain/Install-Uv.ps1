<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Install-Uv.ps1
    kind: public-function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Installs or upgrades uv, Astral's Python handler.
.DESCRIPTION
    Only a uv installed by Astral's own script can self-update; every other source upgrades through its installer.
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

    # Linux takes Astral's standalone release into ~/.local/bin, because there is no uv apt package.
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

    # A blanket self update is refused on the Linux tarball, winget and brew installs, which carry no update receipt.
    # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment3)
    if ($IsLinux) {
        # The re-download also replaces an off-config uv, such as a leftover pip install, that sits in the tool bin.
        # [comment:4](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment4)
        Install-UvStandalone -Version $Version
        return
    }

    if ($IsMacOS) {
        # brew-managed — upgrade through brew (Install-Tool); brew cannot self-update either.
        Install-Tool -Tool 'uv' -Version $Version -Force:$Force
        return
    }

    # A uv outside the winget package root came from Astral's script, so it has a receipt and updates in place.
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
