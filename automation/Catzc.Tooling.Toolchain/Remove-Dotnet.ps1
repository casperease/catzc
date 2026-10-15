# catzc:
#   path: automation/Catzc.Tooling.Toolchain/Remove-Dotnet.ps1
#   module: Catzc.Tooling.Toolchain
#   visibility: public

<#
.SYNOPSIS
    Evicts an off-config .NET install — one the tooling's managed user-space install does not own.
.DESCRIPTION
    Managed is judged for the target folder, not PATH: in a catzc session PATH always leads to the managed install.
    [ADR-AUTO-REMOVE](/docs/adr/automation/tool-removal-lifecycle.md),
    [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md#comment1)
.PARAMETER InstallDir
    Defaults to the dotnet on PATH, or the machine-wide Program Files folder when PATH leads to the managed install.
    [comment:2](/docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md#comment2)
.PARAMETER Force
    Actually perform the removal. Without this, shows what would be removed.
.EXAMPLE
    Remove-Dotnet
.EXAMPLE
    Remove-Dotnet -InstallDir 'C:\Program Files\dotnet' -Force
#>
function Remove-Dotnet {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string] $InstallDir = (Resolve-DotnetRemovalTarget),

        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'dotnet'

    # The off-config install here is the one on PATH, so the managed check asks about PATH.
    # [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    # [comment:3](/docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md#comment3)
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

    # Judged for this folder, since PATH always leads to the managed install and would refuse every stray one.
    # [ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)
    # [comment:4](/docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md#comment4)
    if (Test-ExpectedPackageManager -Config $config -Path $resolvedDir) {
        throw "'$resolvedDir' is the managed .NET install. Use Uninstall-Dotnet instead."
    }

    # Checked before the folder itself, so registrations whose files are already gone are still reported.
    # [ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)
    # [comment:5](/docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md#comment5)
    $machineFolders = @('C:\Program Files\dotnet', 'C:\Program Files (x86)\dotnet')
    # Assigned in the branch: an `if` expression would turn an empty @() into $null.
    [object[]] $products = @()
    if ($resolvedDir -in $machineFolders) {
        $products = @(Get-RegisteredInstallProduct '^Microsoft (ASP\.NET Core|\.NET|Windows Desktop Runtime)\b|^Microsoft\.NET\.')
    }
    if ($products.Count -gt 0) {
        # Uninstalling a bundle's MSI product directly reports success but removes nothing, so only bundles are named.
        # [comment:6](/docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md#comment6)
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

    # Asserted after the preview and registered-product exits, so a dry run never needs an elevated shell.
    # [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)
    # [comment:7](/docs/references/automation/catzc-tooling-toolchain/Remove-Dotnet.ps1.md#comment7)
    Assert-IsAdministrator
    Write-Message "Removing: $resolvedDir"
    $pathChanged = Remove-SystemInstallation -InstallDir $resolvedDir -EnvironmentVariables 'DOTNET_ROOT'
    Write-Message "Deleted: $resolvedDir"
    if ($pathChanged) {
        Write-Message 'Removed from system PATH'
    }
    Write-Message 'Restart your terminal for PATH changes to take effect'
}
