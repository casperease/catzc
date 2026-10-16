<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Vendor/private/Get-VendoredModule.ps1
    folder: private
    name: get-vendored-module
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Vendor
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  config:
    synopsis: Enumerates the vendored modules on disk under automation/.vendor.
    description: |-
      One record per vendored module folder (automation/.vendor/<Name>/<Version>/), reading its name, the
      committed version, and its folder path. The single reader behind Remove-VendorModules' target list and its
      availability validation. Returns an empty array when the vendor folder is absent.
    outputs: '[pscustomobject] with Name, Version, and Path (the module folder to remove).'
---
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
