function Test-FolderConventions {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    # The conventional module folders are the layout's; the modules are the resolver's.
    $allowedModuleSubdirs = @((Get-Config -Config languages).LayoutFolders())
    $allowedText = $allowedModuleSubdirs -join ', '
    $kebabYml = '^[a-z0-9]+(-[a-z0-9]+)*\.yml$'

    $issues = [System.Collections.Generic.List[string]]::new()
    $moduleCount = 0
    $functionOwners = @{}

    $repositoryRoot = Get-RepositoryRoot
    foreach ($resolved in Get-CatzcModule -TrackType modules -RepositoryRoot $repositoryRoot) {
        $module = $resolved.name
        $moduleDirectory = Join-Path $repositoryRoot $resolved.root
        $moduleCount++

        foreach ($subdirectory in ([System.IO.Directory]::EnumerateDirectories($moduleDirectory) | Sort-Object)) {
            $name = [System.IO.Path]::GetFileName($subdirectory)
            if ($name -notin $allowedModuleSubdirs) {
                $issues.Add("$module/${name}: not a conventional module folder ($allowedText)")
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
