<#
.SYNOPSIS
    Lists the run's test paths — tests folders and language test folders — foundation-first: modules by dependency
    order, infrastructure last.
.DESCRIPTION
    Discovers every automation/<dir>/tests folder in a single.NET directory scan — one enumeration instead of two...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md#comment1)
.PARAMETER Modules
    Narrow to the named automation modules' tests folders and language test folders.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md#comment2)
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

    # The language test folders (Go, then Python), each after its module's tests folder (Get-LanguageTestFolders...
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md#comment3)
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
