<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
    kind: function
    subkind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md
      test: automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-FOLDERS
  config:
    synopsis: 'Quality gate: every module folder under automation/ follows the folder and file conventions.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the module
      folders of <RepositoryRoot>/automation (dot-prefixed folders are infrastructure, not modules). It scans the tree
      once with [System.IO] and collects every issue
      ([ADR-REPO-FOLDERS](/docs/adr/repository/conventional-folders.md)):

        - every module subdirectory is a conventional folder: private, tests, assets, types, configs;
        - no test file (*.Tests.ps1) sits at the module root or in private/ — tests belong in tests/;
        - no public function (a module-root .ps1, named for its function) is exported by more than one module — the
          last-loaded module would win silently;
        - configs/ is flat and holds only kebab-case .yml files (dot-prefixed entries are tooling and are skipped);
        - no module keeps internal config in assets/config/ (it belongs in configs/) or test fixtures in assets/test/
          (they belong in tests/assets/).

      The folder convention is the module system's own contract (folder = module, location = visibility), so the
      gate lives with the module system rather than in .internal, which is the loader and not a module.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-folder-conventions/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; Modules }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-FolderConventions
      - (Test-FolderConventions -PassThru).Issues
---
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
