<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vendor/Install-VendorModule.ps1.md"
  header: "generated"
---
#>

function Install-VendorModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [string] $RequiredVersion
    )

    Assert-SourceTree

    # Warn if the module is currently loaded — Save-PSResource may fail on locked files.
    $loaded = Get-Module $Name -ErrorAction Ignore
    if ($loaded) {
        throw "Module '$Name' is currently loaded. Please run Install-VendorModule in a fresh PowerShell session."
    }

    $vendorRoot = Join-Path (Get-CatzcModulesRoot) '.vendor'
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

    # Only what loads is kept: .NET Framework builds and the analyzer's compatibility profiles are never read on PowerShell 7.
    $moduleDir = Join-Path $vendorRoot $Name
    $prunedFolders = @('net20', 'net35', 'net40', 'net45', 'net451', 'net452',
        'net46', 'net461', 'net462', 'net47', 'net471', 'net472', 'net48', 'compatibility_profiles')
    # A vendored module's folders reach three levels below the module folder; the walk must enter every one, vendor included.
    $unusedFolders = @(Get-ChildPath $moduleDir -Directory -Depth 5 -Exclude @() -PruneVendor $false |
            Where-Object { [System.IO.Path]::GetFileName($_) -in $prunedFolders })
    foreach ($unusedFolder in $unusedFolders) {
        # A folder inside an already removed one is gone with it.
        if ([System.IO.Directory]::Exists($unusedFolder)) {
            Remove-Item $unusedFolder -Recurse -Force
            Write-Message "Removed unused folder: $($unusedFolder.Substring($vendorRoot.Length + 1))"
        }
    }

    Write-Message "Installed vendor module: $Name$(if ($RequiredVersion) { " v$RequiredVersion" })"
}
