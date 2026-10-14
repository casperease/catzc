<#
.SYNOPSIS
    Lists the run's test paths — tests folders and Go test folders — foundation-first: modules by dependency order,
    infrastructure last.
.DESCRIPTION
    Discovers every automation/<dir>/tests folder in a single .NET directory scan — one enumeration instead
    of two Get-ChildItem passes, with no pipeline/object overhead (and fewer filesystem round trips on
    network-backed repos, see effective-in-enterprises). A module's Go test folder (<goRoot>/tests/<module in
    kebab case>/, Get-GoTestFolders) belongs to that module and follows its tests folder; a module with Go tests
    only is included by them. A Go test folder that matches no catzc module throws, naming the folder. Module tests
    come FOUNDATION-FIRST (Get-ModuleTestOrder — a topological sort of the declared dependency graph), so a broken
    base module's failures surface before the dependents that cascade from it; dot-prefixed infrastructure
    (.internal, .scriptanalyzer) follows, ordinally. Best-effort on the order: if the graph cannot be sorted (a
    malformed or cyclic dependencies.yml, which its OWN tests then report), it falls back to the ordinal
    order so the test run still proceeds rather than the runner crashing on the config it is testing.
.PARAMETER Modules
    Narrow to the named automation modules' tests folders and Go test folders. Dot-prefixed infrastructure is
    never a named module, so it is included only in the unfiltered case. Empty (the default) includes everything.
.OUTPUTS
    [string[]] the test paths, foundation-first, infrastructure last. Empty when nothing matches.
#>
function Get-TestAutomationTestPaths {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [string[]] $Modules = @()
    )

    $automationRoot = Join-Path (Get-RepositoryRoot) 'automation'
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
            $moduleTestsByName[$dirName] = [System.Collections.Generic.List[string]]::new()
            $moduleTestsByName[$dirName].Add($testsPath)
        }
    }

    # The Go test folders, each after its module's tests folder (Get-GoTestFolders throws on an unmatched folder).
    foreach ($goFolder in @(Get-GoTestFolders)) {
        if ($Modules -and $goFolder.Module -notin $Modules) {
            continue
        }
        if (-not $moduleTestsByName.Contains($goFolder.Module)) {
            $moduleTestsByName[$goFolder.Module] = [System.Collections.Generic.List[string]]::new()
        }
        $moduleTestsByName[$goFolder.Module].Add($goFolder.Folder)
    }

    $moduleOrder = try {
        Get-ModuleTestOrder
    }
    catch {
        Write-Verbose "Get-ModuleTestOrder failed ($_); falling back to ordinal module order."
        $ordinal = [string[]]@($moduleTestsByName.Keys)
        [Array]::Sort($ordinal, [System.StringComparer]::Ordinal)
        $ordinal
    }

    $moduleTestPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $moduleOrder) {
        if ($moduleTestsByName.Contains($name)) {
            $moduleTestPaths.AddRange($moduleTestsByName[$name])
            $moduleTestsByName.Remove($name)
        }
    }
    # Any discovered module the order did not name (safety) — append in the order already scanned.
    foreach ($name in @($moduleTestsByName.Keys)) {
        $moduleTestPaths.AddRange($moduleTestsByName[$name])
    }

    [string[]] (@($moduleTestPaths) + @($infraTestPaths))
}
