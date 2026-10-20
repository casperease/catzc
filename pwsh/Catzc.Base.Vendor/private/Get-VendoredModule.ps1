<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Vendor/private/Get-VendoredModule.ps1
    folder: private
    name: get-vendored-module
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Vendor
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-VendoredModule.ps1.md](docs/references/pwsh/catzc-base-vendor/private/Get-VendoredModule.ps1.md)"
---
#>

function Get-VendoredModule {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $vendorRoot = Join-Path (Get-CatzcModulesRoot) '.vendor'
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
