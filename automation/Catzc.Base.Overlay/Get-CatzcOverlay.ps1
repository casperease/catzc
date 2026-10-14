<#
.SYNOPSIS
    Lists everything in the consumer overlay, each entry classified by where it sits.
.DESCRIPTION
    Under .catzc/automation/ a file's location is its meaning: it sits at the path of what it changes in the
    bundle's code root ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). A folder named for a bundled
    module changes that module, and within it:

      <Function>.ps1          FunctionOverride (public)    replaces the module's public function <Function>
      private/<Function>.ps1  FunctionOverride (private)   replaces the module's private function <Function>
      configs/<config>.yml    ConfigFragment               merges onto the bundled config (Get-Config)
      assets/<path>           AssetOverride                replaces the bundled asset (Get-CatzcModuleRoot)
      tests/<path>            LocalTest                    a local test of the module as overridden
      anything else           Unknown                      not an override point (Assert-CatzcOverlay rejects it)

    A folder that names no bundled module is a LocalModule. Nothing is loaded or checked here; the inventory is
    what Assert-CatzcOverlay checks and Import-CatzcOverlay applies, and what a reader asks to see what a session
    changed. Returns nothing when there is no overlay (source mode, or no .catzc/automation/).
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
