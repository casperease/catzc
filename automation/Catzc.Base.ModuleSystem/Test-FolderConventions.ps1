<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
    kind: function
    module: Catzc.Base.ModuleSystem
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-FOLDERS
      - ADR-REPO-FOLDERS#4
---
#>

<#
.SYNOPSIS
    Quality gate: every module folder under automation/ follows the folder and file conventions.
.DESCRIPTION
    Lives with the module system, not in .internal: the folder convention is its contract, and .internal is no module.
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-folder-conventions/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Modules }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-FolderConventions
.EXAMPLE
    (Test-FolderConventions -PassThru).Issues
#>
function Test-FolderConventions {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $automationRoot = Join-Path (Get-RepositoryRoot) 'automation'
    $allowedModuleSubdirs = @('private', 'tests', 'assets', 'types', 'configs')
    $kebabYml = '^[a-z0-9]+(-[a-z0-9]+)*\.yml$'

    $issues = [System.Collections.Generic.List[string]]::new()
    $moduleCount = 0
    $functionOwners = @{}

    foreach ($moduleDirectory in ([System.IO.Directory]::EnumerateDirectories($automationRoot) | Sort-Object)) {
        $module = [System.IO.Path]::GetFileName($moduleDirectory)
        if ($module -match '^\.') {
            continue
        }
        $moduleCount++

        foreach ($subdirectory in ([System.IO.Directory]::EnumerateDirectories($moduleDirectory) | Sort-Object)) {
            $name = [System.IO.Path]::GetFileName($subdirectory)
            if ($name -notin $allowedModuleSubdirs) {
                $issues.Add("$module/${name}: not a conventional module folder (private, tests, assets, types, configs)")
            }
        }

        # File names are kept for the duplicate-export check: one name exported by two modules is last-loaded-wins.
        # [comment:2](/docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md#comment2)
        foreach ($path in ([System.IO.Directory]::EnumerateFiles($moduleDirectory, '*.ps1') | Sort-Object)) {
            $name = [System.IO.Path]::GetFileName($path)
            if ($name -like '*.Tests.ps1') {
                $issues.Add("$module/${name}: a test file at the module root — tests belong in tests/")
                continue
            }
            $base = [System.IO.Path]::GetFileNameWithoutExtension($path)
            if (-not $functionOwners.ContainsKey($base)) {
                $functionOwners[$base] = [System.Collections.Generic.List[string]]::new()
            }
            $functionOwners[$base].Add($module)
        }

        $privateDirectory = Join-Path $moduleDirectory 'private'
        if ([System.IO.Directory]::Exists($privateDirectory)) {
            foreach ($path in ([System.IO.Directory]::EnumerateFiles($privateDirectory, '*.Tests.ps1') | Sort-Object)) {
                $issues.Add("$module/private/$([System.IO.Path]::GetFileName($path)): a test file in private/ — tests belong in tests/")
            }
        }

        $configsDirectory = Join-Path $moduleDirectory 'configs'
        if ([System.IO.Directory]::Exists($configsDirectory)) {
            foreach ($entry in ([System.IO.Directory]::EnumerateFileSystemEntries($configsDirectory) | Sort-Object)) {
                $name = [System.IO.Path]::GetFileName($entry)
                # Dot-prefixed entries are tooling (a schema sidecar, an editor dotfile), not module config.
                # [comment:3](/docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md#comment3)
                if ($name -match '^\.') {
                    continue
                }
                if (-not [System.IO.File]::Exists($entry)) {
                    $issues.Add("$module/configs/${name}: not a file — configs/ is flat")
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
