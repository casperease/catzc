<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-module-system/Test-FolderConventions.ps1.md"
  header: "generated"
---
#>

function Test-FolderConventions {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    # The conventional module folders are the layout's; the modules are the resolver's.
    $languages = Get-Config -Config languages
    $allowedModuleSubdirs = @($languages.LayoutFolders())
    $privateFolderName = $languages.FolderOf('private-function')
    $testFolderName = $languages.FolderOf('test')
    $allowedText = $allowedModuleSubdirs -join ', '
    $kebabYml = '^[a-z0-9]+(-[a-z0-9]+)*\.yml$'

    $issues = [System.Collections.Generic.List[string]]::new()
    $moduleCount = 0
    $functionOwners = @{}

    $repositoryRoot = Get-RepositoryRoot
    $walk = Get-Config -Config folder-walk
    foreach ($resolved in Get-CatzcModule -EngineTrack -RepositoryRoot $repositoryRoot) {
        $module = $resolved.name
        $moduleDirectory = Join-Path $repositoryRoot $resolved.root
        $moduleCount++

        # The convention check sees every folder, a pruned name included: a stray cache folder in a module is a finding.
        foreach ($subdirectory in (Get-ChildPath $moduleDirectory -Depth 1 -Directory -Exclude @() -PruneVendor $false)) {
            $name = [System.IO.Path]::GetFileName($subdirectory)
            if ($name -notin $allowedModuleSubdirs) {
                $issues.Add("$module/${name}: not a conventional module folder ($allowedText)")
            }
        }

        foreach ($path in [Catzc.Base.Folders.PathSet]::new($walk).AddPattern($moduleDirectory, '*.ps1', 1).ToArray()) {
            $name = [System.IO.Path]::GetFileName($path)
            if ($name -like '*.Tests.ps1') {
                $issues.Add("$module/${name}: a test file at the module root — tests belong in $testFolderName/")
                continue
            }
            $base = [System.IO.Path]::GetFileNameWithoutExtension($path)
            if (-not $functionOwners.ContainsKey($base)) {
                $functionOwners[$base] = [System.Collections.Generic.List[string]]::new()
            }
            $functionOwners[$base].Add($module)
        }

        $privateDirectory = Join-Path $moduleDirectory $privateFolderName
        foreach ($path in [Catzc.Base.Folders.PathSet]::new($walk).AddPattern($privateDirectory, '*.Tests.ps1',
            1).ToArray()) {
            $issues.Add("$module/$privateFolderName/$([System.IO.Path]::GetFileName($path)): a test file in $privateFolderName/ — tests belong in $testFolderName/")
        }

        $configsDirectory = Join-Path $moduleDirectory 'configs'
        if ([System.IO.Directory]::Exists($configsDirectory)) {
            foreach ($entry in (Get-ChildPath $configsDirectory -Depth 1)) {
                $name = [System.IO.Path]::GetFileName($entry)
                if ($name -match '^\.') {
                    continue
                }
                if ([System.IO.Directory]::Exists($entry)) {
                    # A split config: a kebab-case folder of kebab-case .yml parts, one level deep.
                    if ($name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
                        $issues.Add("$module/configs/${name}/: a split config folder is not kebab-case")
                    }
                    foreach ($part in (Get-ChildPath $entry -Depth 1)) {
                        $partName = [System.IO.Path]::GetFileName($part)
                        if (-not [System.IO.File]::Exists($part) -or $partName -cnotmatch $kebabYml) {
                            $issues.Add("$module/configs/${name}/${partName}: a split config holds only kebab-case .yml files")
                        }
                    }
                }
                elseif (-not [System.IO.File]::Exists($entry)) {
                    $issues.Add("$module/configs/${name}: not a file or a split config folder")
                }
                elseif ($name -cnotmatch $kebabYml) {
                    $issues.Add("$module/configs/${name}: not a kebab-case .yml file")
                }
            }
        }

        if ([System.IO.Directory]::Exists((Join-Path $moduleDirectory 'assets/config'))) {
            $issues.Add("$module/assets/config: internal config belongs in configs/")
        }
        if ([System.IO.Directory]::Exists((Join-Path $moduleDirectory 'assets/test'))) {
            $issues.Add("$module/assets/test: test fixtures belong in tests/assets/")
        }
    }

    foreach ($base in ($functionOwners.Keys | Sort-Object)) {
        if ($functionOwners[$base].Count -gt 1) {
            $issues.Add("${base}: exported by more than one module ($($functionOwners[$base] -join ', ')) — the last-loaded module wins silently")
        }
    }

    Write-QualityGateReport -Subject 'folder-conventions' -Title 'Test-FolderConventions' -Issues $issues `
        -Facts ([ordered]@{ Modules = $moduleCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
