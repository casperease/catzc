function Get-Overlay {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $overlayRoot = Get-OverlayRoot
    if (-not $overlayRoot) {
        return
    }
    $modulesRoot = Get-CatzcModulesRoot
    $privateFolderName = (Get-Config -Config languages).FolderOf('private-function')
    # The overlay root names its own track folder, so the records carry one and never spell a track folder of their own.
    $prefix = ".catzc/$([System.IO.Path]::GetFileName($overlayRoot.TrimEnd('\', '/')))"
    # The overlay's own folders, every one: an overlay is listed whole, nothing pruned.
    $folders = [string[]] @(Get-ChildPath $overlayRoot -Directory -Depth 1 -Exclude @() -PruneVendor $false)
    [System.Array]::Sort($folders, [System.StringComparer]::Ordinal)
    # An overlay folder mirrors a bundled module's folder, without the namespace; a local module's name is its folder's.
    $namespace = (Get-Track -Name pwsh).namespace
    foreach ($folder in $folders) {
        $folderName = [System.IO.Path]::GetFileName($folder)
        $isBundled = -not $folderName.StartsWith('.') -and [System.IO.Directory]::Exists([System.IO.Path]::Combine($modulesRoot, $folderName))
        if (-not $isBundled) {
            [pscustomobject]@{
                Kind         = 'LocalModule'
                Module       = $folderName
                Folder       = $folderName
                Target       = $folderName
                Visibility   = $null
                File         = $folder
                RelativePath = "$prefix/$folderName"
            }
            continue
        }
        $moduleName = [Catzc.Base.Variants.VariantTrack]::FullNameIn($namespace, $folderName)

        # Every file of a consumer module is classified, so the walk prunes nothing: a skipped file would be an override nobody sees.
        $files = [string[]] @(Get-ChildPath $folder -File -Depth 64 -Exclude @() -PruneVendor $false)
        [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
        foreach ($file in $files) {
            $relative = [System.IO.Path]::GetRelativePath($folder, $file).Replace('\', '/')
            $segments = $relative.Split('/')
            $kind = 'Unknown'
            $target = $relative
            $visibility = $null
            if ($segments.Count -eq 1 -and $relative.EndsWith('.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                $kind = 'FunctionOverride'
                $target = [System.IO.Path]::GetFileNameWithoutExtension($relative)
                $visibility = 'public'
            }
            elseif ($segments.Count -eq 2 -and $segments[0] -ceq $privateFolderName -and $relative.EndsWith('.ps1',
                    [System.StringComparison]::OrdinalIgnoreCase)) {
                $kind = 'FunctionOverride'
                $target = [System.IO.Path]::GetFileNameWithoutExtension($relative)
                $visibility = 'private'
            }
            elseif ($segments.Count -eq 2 -and $segments[0] -ceq 'configs' -and $relative.EndsWith('.yml',
                    [System.StringComparison]::Ordinal)) {
                $kind = 'ConfigFragment'
                $target = [System.IO.Path]::GetFileNameWithoutExtension($relative)
            }
            elseif ($segments.Count -ge 2 -and $segments[0] -ceq 'assets') {
                $kind = 'AssetOverride'
            }
            elseif ($segments.Count -ge 2 -and $segments[0] -ceq 'tests') {
                $kind = 'LocalTest'
            }
            [pscustomobject]@{
                Kind         = $kind
                Module       = $moduleName
                Folder       = $folderName
                Target       = $target
                Visibility   = $visibility
                File         = $file
                RelativePath = "$prefix/$folderName/$relative"
            }
        }
    }
}
