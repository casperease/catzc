function Get-TestAutomationTestPaths {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [string[]] $Modules = @()
    )

    $codeTrack = @(Get-Track).Where({ $_.type -ceq 'modules' })[0]
    $codePlace = $codeTrack.places[0]
    $modulesRoot = Join-Path (Get-RepositoryRoot) $codePlace
    # Every module folder, the dot folders too: their tests run as the infrastructure tests.
    $allDirs = @(Get-ChildPath $modulesRoot -Depth 1 -Directory -Exclude @() -PruneVendor $false)

    $testFolderName = (Get-Config -Config languages).FolderOf('test')

    $moduleTestsByName = [ordered]@{}
    $infraTestPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in $allDirs) {
        $dirName = [System.IO.Path]::GetFileName($dir)
        $isInfra = $dirName.StartsWith('.')
        # The track declares the namespace the folder drops: the module's full name is what the order and the filter hold.
        $moduleName = $isInfra ? $dirName : $codeTrack.FullNameOf($dirName)

        if ($Modules -and ($isInfra -or $moduleName -notin $Modules)) {
            continue
        }

        $testsPath = [System.IO.Path]::Combine($dir, $testFolderName)
        if (-not [System.IO.Directory]::Exists($testsPath)) {
            continue
        }

        if ($isInfra) {
            $infraTestPaths.Add($testsPath)
        }
        else {
            $moduleTestsByName[$moduleName] = [System.Collections.Generic.List[string]]::new()
            $moduleTestsByName[$moduleName].Add($testsPath)
        }
    }

    # Each language test folder runs after its module's tests folder.
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
