<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
  config:
    synopsis: |-
      Lists the run's test paths — tests folders and language test folders — foundation-first: modules by dependency
      order, infrastructure last.
    description: |-
      Discovers every automation/<dir>/tests folder in a single .NET directory scan — one enumeration instead
      of two Get-ChildItem passes, with no pipeline/object overhead (and fewer filesystem round trips on
      network-backed repos, see effective-in-enterprises). A module's Go and Python test folders (<root>/tests/<module
      in kebab case>/, Get-LanguageTestFolders) belong to that module and follow its tests folder; a module with only
      such tests is included by them. A test folder that matches no catzc module throws, naming the folder. Module tests
      come FOUNDATION-FIRST (Get-ModuleTestOrder — a topological sort of the declared dependency graph), so a broken
      base module's failures surface before the dependents that cascade from it; dot-prefixed infrastructure
      (.internal, .scriptanalyzer) follows, ordinally. Best-effort on the order: if the graph cannot be sorted (a
      malformed or cyclic dependencies.yml, which its OWN tests then report), it falls back to the ordinal
      order so the test run still proceeds rather than the runner crashing on the config it is testing.
    parameters:
      Modules: |-
        Narrow to the named automation modules' tests folders and language test folders. Dot-prefixed infrastructure is
        never a named module, so it is included only in the unfiltered case. Empty (the default) includes everything.
    outputs: '[string[]] the test paths, foundation-first, infrastructure last. Empty when nothing matches.'
---
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

    # The language test folders (Go, then Python), each after its module's tests folder (Get-LanguageTestFolders...
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md#comment4)
    foreach ($testFolder in @(Get-LanguageTestFolders)) {
        if ($Modules -and $testFolder.Module -notin $Modules) {
            continue
        }
        if (-not $moduleTestsByName.Contains($testFolder.Module)) {
            $moduleTestsByName[$testFolder.Module] = [System.Collections.Generic.List[string]]::new()
        }
        $moduleTestsByName[$testFolder.Module].Add($testFolder.Folder)
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
