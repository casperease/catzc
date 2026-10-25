<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestAutomationTestPaths.ps1.md"
  warning: "Generated Header"
---
#>

function Get-TestAutomationTestPaths {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [string[]] $Modules = @()
    )

    $codePlace = @(Get-Track).Where({ $_.type -ceq 'modules' })[0].places[0]
    $modulesRoot = Join-Path (Get-RepositoryRoot) $codePlace
    # Every module folder, the dot folders too: their tests run as the infrastructure tests.
    $allDirs = @(Get-ChildPath $modulesRoot -Depth 1 -Directory -Exclude @() -PruneVendor $false)

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
        Get-ModuleOrder
    }
    catch {
        Write-Verbose "Get-ModuleOrder failed ($_); falling back to ordinal module order."
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
