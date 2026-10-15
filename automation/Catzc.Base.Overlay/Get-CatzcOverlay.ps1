# catzc:
#   path: automation/Catzc.Base.Overlay/Get-CatzcOverlay.ps1
#   module: Catzc.Base.Overlay
#   visibility: public

<#
.SYNOPSIS
    Lists everything in the consumer overlay, each entry classified by where it sits.
.DESCRIPTION
    Only classifies: nothing is loaded or checked here, and no overlay (source mode) returns nothing.
    [ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)
    [comment:1](/docs/references/automation/catzc-base-overlay/Get-CatzcOverlay.ps1.md#comment1)
.OUTPUTS
    [pscustomobject] Kind, Module, Target, Visibility, File, RelativePath — in ordinal path order.
.EXAMPLE
    Get-CatzcOverlay | Format-Table Kind, Module, Target
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
                RelativePath = ".catzc/automation/$moduleName"
            }
            continue
        }

        $files = [string[]] @([System.IO.Directory]::GetFiles($folder, '*', [System.IO.SearchOption]::AllDirectories))
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
                RelativePath = ".catzc/automation/$moduleName/$relative"
            }
        }
    }
}
