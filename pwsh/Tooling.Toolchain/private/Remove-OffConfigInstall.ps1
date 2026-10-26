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
    if ($products.Count -gt 0 -and -not $Force) {
        # Removing a bundle's MSI product directly reports success and removes nothing, so only bundles are named while any is registered.
        [object[]] $bundles = @($products | Where-Object Kind -EQ 'Bundle')
        $toRemove = $bundles.Count -gt 0 ? $bundles : $products
        Write-Message ("'$resolvedDir' is owned by $($products.Count) Windows-registered $Label product(s); deleting it by hand would " +
            "orphan them. From an elevated shell, Remove-$Tool -Force runs their own uninstallers:") -ForegroundColor Yellow
        if ($bundles.Count -gt 0) {
            Write-Message "  $($bundles.Count) of them are installer bundles, which remove the products they installed:"
        }
        # Printed pwsh-safe, as the user pastes it into pwsh: a bare {GUID} would parse as a script block, a leading quoted path as a string.
        foreach ($product in $toRemove) {
            $line = $product.UninstallCommand -replace '(?<![''"])(\{[^\s{}''"]+\})', '''$1'''
            if ($line.StartsWith('"')) {
                $line = "& $line"
            }
            Write-Message "  $line   # $($product.DisplayName) $($product.DisplayVersion) [$($product.Kind)]"
        }
        Write-Message "It runs them one at a time, re-reads the registrations, then removes what is left."
        return
    }

    if ($products.Count -gt 0) {
        # A machine installer's uninstall needs Administrator, asserted for this step.
        Assert-IsAdministrator
        $seconds = Get-TimeoutSeconds -Executable 'msiexec'
        $transcript = Join-Path (Get-OutputRoot) "remove-$($Tool.ToLowerInvariant())/$((Get-Date).ToString('yyyyMMdd-HHmmss')).log"
        [System.IO.Directory]::CreateDirectory((Split-Path $transcript -Parent)) | Out-Null
        # Each uninstaller is a child process with its output in the transcript, bundles first; 1605 is gone already, 1641 and 3010 want a reboot.
        for ($round = 1; $products.Count -gt 0; $round++) {
            if ($round -gt 3) {
                throw ("Remove-${Tool}: still registered after 3 rounds: $(($products | ForEach-Object { $_.DisplayName }) -join '; '). " +
                    "Transcript: $transcript")
            }
            [object[]] $bundles = @($products | Where-Object Kind -EQ 'Bundle')
            foreach ($product in ($bundles.Count -gt 0 ? $bundles : $products)) {
                Write-Message "Uninstalling $($product.DisplayName) $($product.DisplayVersion) [$($product.Kind)]: $($product.UninstallCommand)"
                $result = Invoke-Executable $product.UninstallCommand -PassThru -NoAssert -Silent -TimeoutSeconds $seconds
                [System.IO.File]::AppendAllText($transcript, "> $($product.UninstallCommand)`n$($result.Full)`nexit $($result.ExitCode)`n")
                if ($result.ExitCode -notin 0, 1605, 1641, 3010) {
                    throw "Remove-${Tool}: the uninstaller of $($product.DisplayName) exited $($result.ExitCode). Transcript: $transcript"
                }
                if ($result.ExitCode -in 1641, 3010) {
                    Write-Message "$($product.DisplayName) is removed; Windows wants a restart to finish." -ForegroundColor Yellow
                }
            }
            $products = @(Get-RegisteredInstallProduct $ProductPattern)
        }
        Write-Message "Registered $Label products removed. Transcript: $transcript"
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
