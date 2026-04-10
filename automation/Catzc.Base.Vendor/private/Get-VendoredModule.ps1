<#
.SYNOPSIS
    Enumerates the vendored modules on disk under automation/.vendor.
.DESCRIPTION
    One record per vendored module folder (automation/.vendor/<Name>/<Version>/), reading its name, the
    committed version, and its folder path. The single reader behind Remove-VendorModules' target list and its
    availability validation. Returns an empty array when the vendor folder is absent.
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
