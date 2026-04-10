<#
.SYNOPSIS
    Scans automation/ for its modules and the public functions each exports, for Show-Cats.
.DESCRIPTION
    Enumerates the non-dot-prefixed module folders under automation/ (a dot-prefix means infrastructure,
    ADR-FOLDERS:4) and, for each, the public functions it exports — the root *.ps1 files, one function per file
    (ADR-ONEFUNC). Reads the filesystem directly with [System.IO] (ADR-TEST:16, ADR-TEST:18), not the loaded
    session, and memoizes per resolved automation root for the session (docs/adr/automation/caching.md).

    Private helper for Show-Cats; not exported.
.PARAMETER AutomationRoot
    Absolute path to the automation/ folder. Defaults to automation/ under the repository root. A test points
    this at a fixture module tree; the cache keys on the path.
.OUTPUTS
    [object[]] One { Module; Functions } per module, sorted by module name.
#>
function Get-CatsModules {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $AutomationRoot = (Resolve-RepoPath 'automation')
    )

    if (-not $script:catsModulesCache) {
        $script:catsModulesCache = @{}
    }
    if ($script:catsModulesCache.ContainsKey($AutomationRoot)) {
        return , $script:catsModulesCache[$AutomationRoot]
    }

    Assert-PathExist $AutomationRoot

    $moduleDirs = [System.IO.Directory]::EnumerateDirectories($AutomationRoot) | Sort-Object
    $ret = foreach ($moduleDir in $moduleDirs) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDir)
        if ($moduleName.StartsWith('.')) {
            continue
        }

        $functionFiles = [System.IO.Directory]::EnumerateFiles($moduleDir, '*.ps1') | Sort-Object
        $functions = foreach ($functionFile in $functionFiles) {
            $functionName = [System.IO.Path]::GetFileNameWithoutExtension($functionFile)
            if ($functionName.EndsWith('.Tests')) {
                continue
            }
            $functionName
        }

        [pscustomobject]@{
            Module    = $moduleName
            Functions = @($functions)
        }
    }

    $ret = @($ret)
    $script:catsModulesCache[$AutomationRoot] = $ret
    , $ret
}
