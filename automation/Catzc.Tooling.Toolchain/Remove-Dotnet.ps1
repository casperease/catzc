<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Remove-Dotnet.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md
      test: automation/Catzc.Tooling.Toolchain/tests/Remove-Dotnet.Tests.ps1
    adrs:
      - ADR-AUTO-REMOVE
  config:
    synopsis: Evicts an off-config .NET install — one the tooling's managed user-space install does not own.
    description: |-
      The destructive escape hatch beside Install-/Uninstall-Dotnet
      ([ADR-AUTO-REMOVE](/docs/adr/automation/tool-removal-lifecycle.md)). It refuses the managed install —
      Uninstall-Dotnet
      owns that — and decides "managed" for the folder it is about to remove, not for whatever `dotnet` resolves to on
      PATH: in a catzc session PATH always leads to the managed install, so asking about PATH would refuse every stray one.

      Windows: the target folder defaults to the `dotnet` on PATH, or, when that is the managed install, the machine-wide
      C:\Program Files\dotnet. A folder that Windows-registered products own (the .NET SDK / runtime installers, listed in
      Apps & features) is not deleted by hand — that would orphan every entry — so the products are listed with the
      command that removes each by its own installer, and nothing is touched. Installer bundles come first and alone: a
      bundle holds the MSI products it installed, which go only with it, so the next run names whatever is left. Only an
      unregistered folder is deleted, with
      its machine PATH entry and DOTNET_ROOT (needs Administrator,
      [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).

      Linux / macOS: evicts an off-config install by the mechanism that placed it (native package / uv-Python pip /
      stray binary).
    parameters:
      InstallDir: |-
        The .NET installation folder to evict (Windows). Default: the `dotnet` on PATH, or the machine-wide
        C:\Program Files\dotnet when the one on PATH is the managed install.
      Force: Actually perform the removal. Without this, shows what would be removed.
    examples:
      - Remove-Dotnet
      - Remove-Dotnet -InstallDir 'C:\Program Files\dotnet' -Force
---
#>

function Remove-Dotnet {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string] $InstallDir = (Resolve-DotnetRemovalTarget),

        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'dotnet'

    if ($IsLinux -or $IsMacOS) {
        if (Test-ExpectedPackageManager -Config $config) {
            throw 'Dotnet is managed by the tooling system. Use Uninstall-Dotnet instead.'
        }
        if (-not $Force) {
            Write-Message 'Would evict an off-config .NET (native package / uv-Python pip / stray binary). Run with -Force to execute.'
            return
        }
        $removed = if ($IsLinux) {
            Remove-LinuxToolInstall -Config $config
        }
        else {
            Remove-MacToolInstall -Config $config
        }
        if (-not $removed) {
            Write-Message 'No off-config .NET found — nothing to remove.'
        }
        return
    }

    $resolvedDir = [System.IO.Path]::GetFullPath($InstallDir).TrimEnd('\', '/')

    if (Test-ExpectedPackageManager -Config $config -Path $resolvedDir) {
        throw "'$resolvedDir' is the managed .NET install. Use Uninstall-Dotnet instead."
    }

    $machineFolders = @('C:\Program Files\dotnet', 'C:\Program Files (x86)\dotnet')
    # Assigned in the branch: an `if` expression would turn an empty @() into $null.
    [object[]] $products = @()
    if ($resolvedDir -in $machineFolders) {
        $products = @(Get-RegisteredInstallProduct '^Microsoft (ASP\.NET Core|\.NET|Windows Desktop Runtime)\b|^Microsoft\.NET\.')
    }
    if ($products.Count -gt 0) {
        [object[]] $bundles = @($products | Where-Object Kind -EQ 'Bundle')
        $toRemove = $bundles.Count -gt 0 ? $bundles : $products
        Write-Message ("'$resolvedDir' is owned by $($products.Count) Windows-registered .NET product(s); deleting it by hand would " +
            'orphan them. Remove them by their own installer, from an elevated shell:') -ForegroundColor Yellow
        if ($bundles.Count -gt 0) {
            Write-Message "  $($bundles.Count) of them are installer bundles, which remove the products they installed:"
        }
        foreach ($product in $toRemove) {
            Write-Message "  $($product.UninstallCommand)   # $($product.DisplayName) $($product.DisplayVersion) [$($product.Kind)]"
        }
        Write-Message 'Then re-run Remove-Dotnet: it names any product still registered, then removes what is left.'
        return
    }

    if (-not [System.IO.Directory]::Exists($resolvedDir)) {
        Write-Message "Directory not found: $resolvedDir — nothing to remove"
        return
    }

    if (-not $Force) {
        Write-Message "Would remove: $resolvedDir"
        Write-Message 'Run with -Force to execute'
        return
    }

    Assert-IsAdministrator
    Write-Message "Removing: $resolvedDir"
    $pathChanged = Remove-SystemInstallation -InstallDir $resolvedDir -EnvironmentVariables 'DOTNET_ROOT'
    Write-Message "Deleted: $resolvedDir"
    if ($pathChanged) {
        Write-Message 'Removed from system PATH'
    }
    Write-Message 'Restart your terminal for PATH changes to take effect'
}
