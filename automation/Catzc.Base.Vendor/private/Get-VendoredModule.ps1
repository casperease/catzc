<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Vendor/private/Get-VendoredModule.ps1
    kind: function
    module: Catzc.Base.Vendor
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Enumerates the vendored modules on disk under automation/.vendor.
.DESCRIPTION
    Returns an empty array when the vendor folder is absent, so a caller can loop without a null check.
.OUTPUTS
    [pscustomobject] with Name, Version, and Path (the module folder to remove).
#>
function Get-VendoredModule {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $vendorRoot = Join-Path (Get-RepositoryRoot) 'automation/.vendor'
    if (-not (Test-Path $vendorRoot)) {
        return @()
    }

    foreach ($moduleDir in Get-ChildPath $vendorRoot -Directory -Depth 1 -PruneVendor $false) {
        $versionDir = Get-ChildPath $moduleDir -Directory -Depth 1 -PruneVendor $false | Select-Object -First 1
        $version = if ($versionDir) {
            [System.IO.Path]::GetFileName($versionDir)
        }
        [pscustomobject]@{
            Name    = [System.IO.Path]::GetFileName($moduleDir)
            Version = $version
            Path    = $moduleDir
        }
    }
}
