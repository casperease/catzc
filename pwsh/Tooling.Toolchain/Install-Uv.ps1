function Install-Uv {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'uv').version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'uv'

    # Linux bootstraps Astral's standalone release into ~/.local/bin, since there is no uv apt package; winget and brew go through Install-Tool.
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

    # Re-assert the configured install rather than `uv self update`, which refuses a tarball, winget or brew install.
    if ($IsLinux) {
        # Re-downloading the pinned build also replaces an off-config uv, such as a leftover pip one, in the tool-bin.
        Install-UvStandalone -Version $Version
        return
    }

    if ($IsMacOS) {
        # brew-managed — upgrade through brew (Install-Tool); brew cannot self-update either.
        Install-Tool -Tool 'uv' -Version $Version -Force:$Force
        return
    }

    # A uv on PATH outside the winget root came from Astral's script and carries a self-update receipt; a winget one upgrades through winget.
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
