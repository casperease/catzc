<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Overlay/Get-CatzcOverlay.ps1
    name: get-catzc-overlay
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Overlay
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Overlay/tests/Get-CatzcOverlay.Tests.ps1
    docs: "[Get-CatzcOverlay.ps1.md](docs/references/pwsh/catzc-base-overlay/Get-CatzcOverlay.ps1.md)"
    cites:
      - ADR-AUTO-OVERLAY
      - ADR-PRIN-CATS-FOLDERSUSECATZC
      - ADR-PWSH-ENUM-ALWAYSBOUNDED
---
#>

function Get-CatzcOverlay {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $overlayRoot = Get-CatzcOverlayRoot
    if (-not $overlayRoot) {
        return
    }
    $modulesRoot = Get-CatzcModulesRoot
    $prefix = ".catzc/$([System.IO.Path]::GetFileName($overlayRoot.TrimEnd('\', '/')))"
    $folders = [string[]] @([System.IO.Directory]::GetDirectories($overlayRoot))
    [System.Array]::Sort($folders, [System.StringComparer]::Ordinal)
    foreach ($folder in $folders) {
        $moduleName = [System.IO.Path]::GetFileName($folder)
        $isBundled = -not $moduleName.StartsWith('.') -and [System.IO.Directory]::Exists([System.IO.Path]::Combine($modulesRoot, $moduleName))
        if (-not $isBundled) {
            [pscustomobject]@{
                Kind         = 'LocalModule'
                Module       = $moduleName
                Target       = $moduleName
                Visibility   = $null
                File         = $folder
                RelativePath = "$prefix/$moduleName"
            }
            continue
        }

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
            elseif ($segments.Count -eq 2 -and $segments[0] -ceq 'private' -and $relative.EndsWith('.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                $kind = 'FunctionOverride'
                $target = [System.IO.Path]::GetFileNameWithoutExtension($relative)
                $visibility = 'private'
            }
            elseif ($segments.Count -eq 2 -and $segments[0] -ceq 'configs' -and $relative.EndsWith('.yml', [System.StringComparison]::Ordinal)) {
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
                Target       = $target
                Visibility   = $visibility
                File         = $file
                RelativePath = "$prefix/$moduleName/$relative"
            }
        }
    }
}
