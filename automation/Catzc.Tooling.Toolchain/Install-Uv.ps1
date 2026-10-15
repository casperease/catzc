<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Install-Uv.ps1
    kind: automation-function
    module: Catzc.Tooling.Toolchain
    visibility: public
  config:
    synopsis: Installs or upgrades uv, Astral's Python handler.
    description: |-
      uv is user-space on every platform. A fresh machine bootstraps it via winget on Windows and brew on macOS
      (both hash-verified, user-scope, no admin), and from Astral's standalone GitHub release on Linux
      (Install-UvStandalone — verified download into ~/.local/bin; there is no uv apt package). An
      already-present uv is upgraded through its install source: Linux re-runs the standalone install
      (Install-UvStandalone — the extracted tarball carries no `uv self update` receipt), macOS re-runs brew and
      a winget-managed uv re-runs winget (both via Install-Tool); only a Windows uv installed by Astral's own
      script (receipt-backed) upgrades with `uv self update`. Idempotent — skips if the correct version is already
      on PATH.
    parameters:
      Version: uv version to install. Defaults to the locked version in Get-ToolConfig.
      Force: Upgrade even when a build is already present.
---
#>

function Install-Uv {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'uv').version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'uv'

    # Fresh machine: bootstrap per platform — winget on Windows and brew on macOS (both via Install-Tool); Astral's...
    # [comment:6](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment6)
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
    # [comment:7](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment7)
    if ($IsLinux) {
        # Re-download the pinned, verified standalone build over ~/.local/bin — this also replaces an off-config uv...
        # [comment:8](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment8)
        Install-UvStandalone -Version $Version
        return
    }

    if ($IsMacOS) {
        # brew-managed — upgrade through brew (Install-Tool); brew cannot self-update either.
        Install-Tool -Tool 'uv' -Version $Version -Force:$Force
        return
    }

    # Windows: a winget-managed uv upgrades through winget; a uv installed by Astral's own script (on PATH outside...
    # [comment:9](/docs/references/automation/catzc-tooling-toolchain/Install-Uv.ps1.md#comment9)
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
