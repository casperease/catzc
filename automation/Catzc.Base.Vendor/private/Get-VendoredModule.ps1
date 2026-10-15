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
    [comment:1](/docs/references/automation/catzc-base-vendor/private/Get-VendoredModule.ps1.md#comment1)
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

    foreach ($moduleDir in Get-ChildItem -Path $vendorRoot -Directory) {
        $version = @(Get-ChildItem -Path $moduleDir.FullName -Directory).Name | Select-Object -First 1
        [pscustomobject]@{
            Name    = $moduleDir.Name
            Version = $version
            Path    = $moduleDir.FullName
        }
    }
}
