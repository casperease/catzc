<#
.SYNOPSIS
    Enumerates the vendored modules on disk under automation/.vendor.
.DESCRIPTION
    One record per vendored module folder (automation/.vendor/<Name>/<Version>/), reading its name, the committed...
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
