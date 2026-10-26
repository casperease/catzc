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
