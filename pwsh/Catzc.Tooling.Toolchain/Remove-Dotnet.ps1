<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/Remove-Dotnet.ps1
    name: remove-dotnet
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Remove-Dotnet.Tests.ps1
    docs: "[Remove-Dotnet.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Remove-Dotnet.ps1.md)"
    cites:
      - ADR-AUTO-REMOVE
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
