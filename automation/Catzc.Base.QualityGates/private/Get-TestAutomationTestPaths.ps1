<#
.SYNOPSIS
    Lists the run's tests folders, foundation-first — modules by dependency order, infrastructure last.
.DESCRIPTION
    Discovers every automation/<dir>/tests folder in a single .NET directory scan — one enumeration instead
    of two Get-ChildItem passes, with no pipeline/object overhead (and fewer filesystem round trips on
    network-backed repos, see effective-in-enterprises). Module tests come FOUNDATION-FIRST
    (Get-ModuleTestOrder — a topological sort of the declared dependency graph), so a broken base module's
    failures surface before the dependents that cascade from it; dot-prefixed infrastructure (.internal,
    .scriptanalyzer) follows, ordinally. Best-effort on the order: if the graph cannot be sorted (a
    malformed or cyclic dependencies.yml, which its OWN tests then report), it falls back to the ordinal
    order so the suite still runs rather than the runner crashing on the config it is testing.
.PARAMETER Modules
    Narrow to the named automation modules' tests folders. Dot-prefixed infrastructure is never a named
    module, so it is included only in the unfiltered case. Empty (the default) includes everything.
.OUTPUTS
    [string[]] the tests folders, foundation-first, infrastructure last. Empty when nothing matches.
#>
function Get-TestAutomationTestPaths {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [string[]] $Modules = @()
    )

    $automationRoot = Join-Path $env:RepositoryRoot 'automation'
    $allDirs = [System.IO.Directory]::GetDirectories($automationRoot)
    [Array]::Sort($allDirs)

    $moduleTestsByName = [ordered]@{}
    $infraTestPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in $allDirs) {
        $dirName = [System.IO.Path]::GetFileName($dir)
        $isInfra = $dirName.StartsWith('.')

        if ($Modules -and ($isInfra -or $dirName -notin $Modules)) {
            continue
        }

        $testsPath = [System.IO.Path]::Combine($dir, 'tests')
        if (-not [System.IO.Directory]::Exists($testsPath)) {
            continue
        }

        if ($isInfra) {
            $infraTestPaths.Add($testsPath)
        }
        else {
            $moduleTestsByName[$dirName] = $testsPath
        }
    }

    $moduleOrder = try {
        Get-ModuleTestOrder
    }
    catch {
        Write-Verbose "Get-ModuleTestOrder failed ($_); falling back to ordinal module order."
        @($moduleTestsByName.Keys)
    }

    $moduleTestPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $moduleOrder) {
        if ($moduleTestsByName.Contains($name)) {
            $moduleTestPaths.Add($moduleTestsByName[$name])
            $moduleTestsByName.Remove($name)
        }
    }
    # Any discovered module the order did not name (safety) — append in the ordinal order already scanned.
    foreach ($name in @($moduleTestsByName.Keys)) {
        $moduleTestPaths.Add($moduleTestsByName[$name])
    }

    [string[]] (@($moduleTestPaths) + @($infraTestPaths))
}
