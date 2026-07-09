<#
.SYNOPSIS
    Saves a PowerShell module into the automation/.vendor directory from the configured source.
.DESCRIPTION
    Downloads with Save-PSResource from the vendor source (configs/vendor.yml — PSGallery by default, or a
    custom feed) into automation/.vendor/<Name>/<Version>/, then removes legacy .NET Framework folders not
    needed on PowerShell 7+. The only supported way to add a vendor module (ADR-AUTO-VENDOR); commit the result.
    Must be run in a fresh session — a loaded module may lock its files.
.PARAMETER Name
    The module name to install from the vendor source.
.PARAMETER RequiredVersion
    An optional specific version to install. Installs the latest if omitted.
.EXAMPLE
    Install-VendorModule 'Pester'
.EXAMPLE
    Install-VendorModule 'Pester' -RequiredVersion '5.5.0'
#>
function Install-VendorModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [string] $RequiredVersion
    )

    # Warn if the module is currently loaded — Save-PSResource may fail on locked files.
    $loaded = Get-Module $Name -ErrorAction Ignore
    if ($loaded) {
        throw "Module '$Name' is currently loaded. Please run Install-VendorModule in a fresh PowerShell session."
    }

    $vendorRoot = Join-Path (Get-RepositoryRoot) 'automation/.vendor'
    if (-not (Test-Path $vendorRoot)) {
        Write-Verbose "Creating vendor directory: $vendorRoot"
        New-Item -Path $vendorRoot -ItemType Directory -Force | Out-Null
    }

    $saveParams = @{
        Name            = $Name
        Repository      = (Resolve-VendorRepository)
        Path            = $vendorRoot
        TrustRepository = $true
    }
    if ($RequiredVersion) {
        $saveParams.Version = $RequiredVersion
    }

    Write-Verbose "Downloading $Name from the vendor source$(if ($RequiredVersion) { " (v$RequiredVersion)" })"
    Save-PSResource @saveParams

    # Clean up legacy .NET Framework folders — we only target PS 7+ / .NET 6+
    $moduleDir = Join-Path $vendorRoot $Name
    $junkPatterns = @('net20', 'net35', 'net40', 'net45', 'net451', 'net452',
        'net46', 'net461', 'net462', 'net47', 'net471', 'net472', 'net48')
    Get-ChildItem -Path $moduleDir -Directory -Recurse |
        Where-Object { $_.Name -in $junkPatterns } |
        ForEach-Object {
            Remove-Item $_.FullName -Recurse -Force
            Write-Message "Removed legacy folder: $($_.FullName.Substring($vendorRoot.Length + 1))"
        }

    Write-Message "Installed vendor module: $Name$(if ($RequiredVersion) { " v$RequiredVersion" })"
}
