function Remove-OffConfigInstall {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config,

        # The tool's name in messages: '.NET', 'Go'.
        [Parameter(Mandatory)]
        [string] $Label,

        # The tool's command suffix: Remove-<Tool> and Uninstall-<Tool>.
        [Parameter(Mandatory)]
        [string] $Tool,

        [Parameter(Mandatory)]
        [string] $InstallDir,

        # The machine-wide folders a registered installer may own.
        [string[]] $MachineFolders = @(),

        # The DisplayName pattern of the tool's Windows-registered products.
        [string] $ProductPattern,

        [string[]] $ExtraPathDirs = @(),

        [string[]] $EnvironmentVariables = @(),

        [switch] $Force
    )

    # An off-config install is evicted by its own mechanism with no admin assert here; the one on PATH is the off-config one, so the managed check asks about PATH.
    if ($IsLinux -or $IsMacOS) {
        if (Test-ExpectedPackageManager -Config $Config) {
            throw "$Label is managed by the tooling system. Use Uninstall-$Tool instead."
        }
        if (-not $Force) {
            Write-Message "Would evict an off-config $Label (native package / uv-Python pip / stray binary). Run with -Force to execute."
            return
        }
        $removed = if ($IsLinux) {
            Remove-LinuxToolInstall -Config $Config
        }
        else {
            Remove-MacToolInstall -Config $Config
        }
        if (-not $removed) {
            Write-Message "No off-config $Label found — nothing to remove."
        }
        return
    }

    $resolvedDir = [System.IO.Path]::GetFullPath($InstallDir).TrimEnd('\', '/')

    # A managed install is Uninstall-<Tool>'s, judged for this folder.
    if (Test-ExpectedPackageManager -Config $Config -Path $resolvedDir) {
        throw "'$resolvedDir' is the managed $Label install. Use Uninstall-$Tool instead."
    }

    # Products before the folder, so a registration whose files are gone is still reported; assigned in branches, as `if` turns @() to $null.
    [object[]] $products = @()
    if ($ProductPattern -and $resolvedDir -in $MachineFolders) {
        $products = @(Get-RegisteredInstallProduct $ProductPattern)
    }
    if ($products.Count -gt 0) {
        # Removing a bundle's MSI product directly reports success and removes nothing, so only bundles are named while any is registered.
        [object[]] $bundles = @($products | Where-Object Kind -EQ 'Bundle')
        $toRemove = $bundles.Count -gt 0 ? $bundles : $products
        Write-Message ("'$resolvedDir' is owned by $($products.Count) Windows-registered $Label product(s); deleting it by hand would " +
            'orphan them. Remove them by their own installer, from an elevated shell:') -ForegroundColor Yellow
        if ($bundles.Count -gt 0) {
            Write-Message "  $($bundles.Count) of them are installer bundles, which remove the products they installed:"
        }
        foreach ($product in $toRemove) {
            Write-Message "  $($product.UninstallCommand)   # $($product.DisplayName) $($product.DisplayVersion) [$($product.Kind)]"
        }
        Write-Message "Then re-run Remove-${Tool}: it names any product still registered, then removes what is left."
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

    # Elevation is asserted for this step only: deleting the folder and the machine PATH entry.
    Assert-IsAdministrator
    Write-Message "Removing: $resolvedDir"
    $pathChanged = Remove-SystemInstallation -InstallDir $resolvedDir -ExtraPathDirs $ExtraPathDirs -EnvironmentVariables $EnvironmentVariables
    Write-Message "Deleted: $resolvedDir"
    if ($pathChanged) {
        Write-Message 'Removed from system PATH'
    }
    Write-Message 'Restart your terminal for PATH changes to take effect'
}
