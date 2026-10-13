<#
.SYNOPSIS
    Evicts an off-config .NET install — one the tooling's managed user-space install does not own.
.DESCRIPTION
    The destructive escape hatch beside Install-/Uninstall-Dotnet
    ([ADR-AUTO-REMOVE](/docs/adr/automation/tool-removal-lifecycle.md)). It refuses the managed install —
    Uninstall-Dotnet
    owns that — and decides "managed" for the folder it is about to remove, not for whatever `dotnet` resolves to on
    PATH: in a catzc session PATH always leads to the managed install, so asking about PATH would refuse every stray one.

    Windows: the target folder defaults to the `dotnet` on PATH, or, when that is the managed install, the machine-wide
    C:\Program Files\dotnet. A folder that Windows-registered products own (the .NET SDK / runtime installers, listed in
    Apps & features) is not deleted by hand — that would orphan every entry — so each product is listed with the winget
    command that removes it by its own mechanism, and nothing is touched. Only an unregistered folder is deleted, with
    its machine PATH entry and DOTNET_ROOT (needs Administrator,
    [ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).

    Linux / macOS: evicts an off-config install by the mechanism that placed it (native package / uv-Python pip /
    stray binary).
.PARAMETER InstallDir
    The .NET installation folder to evict (Windows). Default: the `dotnet` on PATH, or the machine-wide
    C:\Program Files\dotnet when the one on PATH is the managed install.
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

    # Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
    # / stray binary); elevation is scoped to the mechanism
    # ([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
    # here. The off-config install there is the one on PATH, so the managed check asks about PATH.
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

    # Gate: the managed install is Uninstall-Dotnet's, judged for this folder
    # ([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
    if (Test-ExpectedPackageManager -Config $config -Path $resolvedDir) {
        throw "'$resolvedDir' is the managed .NET install. Use Uninstall-Dotnet instead."
    }

    if (-not [System.IO.Directory]::Exists($resolvedDir)) {
        Write-Message "Directory not found: $resolvedDir — nothing to remove"
        return
    }

    # A folder registered products own is removed by their mechanism, never by deleting it
    # ([ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)).
    # The .NET installers place their products in the machine-wide folders; a stray copy elsewhere is nobody's.
    $machineFolders = @('C:\Program Files\dotnet', 'C:\Program Files (x86)\dotnet')
    # Assigned in the branch: an `if` expression would turn an empty @() into $null.
    [object[]] $products = @()
    if ($resolvedDir -in $machineFolders) {
        $products = @(Get-RegisteredInstallProduct '^Microsoft (ASP\.NET Core|\.NET|Windows Desktop Runtime)\b|^Microsoft\.NET\.')
    }
    if ($products.Count -gt 0) {
        Write-Message "'$resolvedDir' is owned by $($products.Count) Windows-registered .NET product(s); deleting it by hand would orphan them. Remove them by their own installer:" -ForegroundColor Yellow
        foreach ($product in $products) {
            Write-Message "  winget uninstall --product-code `"$($product.ProductCode)`"   # $($product.DisplayName) $($product.DisplayVersion)"
        }
        Write-Message 'Then re-run Remove-Dotnet to clean up anything they leave behind.'
        return
    }

    if (-not $Force) {
        Write-Message "Would remove: $resolvedDir"
        Write-Message 'Run with -Force to execute'
        return
    }

    # Deleting the folder and the machine PATH entry needs Administrator — asserted for this step only
    # ([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).
    Assert-IsAdministrator
    Write-Message "Removing: $resolvedDir"
    $pathChanged = Remove-SystemInstallation -InstallDir $resolvedDir -EnvironmentVariables 'DOTNET_ROOT'
    Write-Message "Deleted: $resolvedDir"
    if ($pathChanged) {
        Write-Message 'Removed from system PATH'
    }
    Write-Message 'Restart your terminal for PATH changes to take effect'
}
