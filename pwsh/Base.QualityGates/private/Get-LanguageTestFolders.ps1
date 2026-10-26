<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-LanguageTestFolders.ps1.md"
  header: "generated"
---
#>

function Get-LanguageTestFolders {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $repositoryRoot = Get-RepositoryRoot
    $languagesConfig = Get-Config -Config languages
    $testFolderName = $languagesConfig.FolderOf('test')
    $engineModules = @(Get-CatzcModule -EngineTrack)
    $moduleNames = @($engineModules.name.Where({ [Catzc.Base.Objects.NameCase]::IsInCase('pascal-dotted', $_) }))
    # A test folder is named for its module's folder, which drops the track's namespace (DDR-TRACK-MODULENAMESPACE).
    $engineTrack = $engineModules.Count -gt 0 ? (Get-Track -Name $engineModules[0].track) : $null
    $languages = @(foreach ($entry in $languagesConfig.languages) {
            if ($entry.tests) {
                $modulesByFolder = @{}
                foreach ($module in $moduleNames) {
                    $folderName = $null -ne $engineTrack ? $engineTrack.FolderNameOf($module) : $module
                    $modulesByFolder[$languagesConfig.TestFolderOf($entry.name, $folderName)] = $module
                }
                [pscustomobject]@{
                    Language = $entry.name
                    Root     = (Get-Config -Config $entry.name).ResolveRoot($repositoryRoot)
                    Pattern  = $entry.tests.pattern
                    Case     = $entry.naming.folder[0]
                    Modules  = $modulesByFolder
                }
            }
        })

    $unmatched = [System.Collections.Generic.List[string]]::new()
    $records = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($language in $languages) {
        $testsRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $language.Root,
                $testFolderName))
        if ([System.IO.Directory]::Exists($testsRoot)) {
            foreach ($folder in Get-ChildPath $testsRoot -Depth 1 -Directory -Exclude @() -PruneVendor $false) {
                $name = [System.IO.Path]::GetFileName($folder)
                if ($name.StartsWith('.')) {
                    continue
                }
                if (-not @(Get-ChildPath $folder -File -Filter $language.Pattern -Depth 3).Count) {
                    continue
                }
                if (-not $language.Modules.ContainsKey($name)) {
                    $unmatched.Add("$($language.Root)/$testFolderName/$name/ ($($language.Case) case)")
                    continue
                }
                $records.Add([pscustomobject]@{
                        Language = $language.Language
                        Module   = $language.Modules[$name]
                        Folder   = $folder
                        Name     = $name
                    })
            }
        }

        # A module of the language's own track runs its own tests/ folder, the shared layout row every module has.
        $track = Get-Track -Path $language.Root
        if ($null -eq $track) {
            continue
        }
        foreach ($module in Get-CatzcModule -Track $track.name -RepositoryRoot $repositoryRoot) {
            if ($module.shape -cne 'folder') {
                continue
            }
            $own = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $module.root,
                    $testFolderName))
            if (-not [System.IO.Directory]::Exists($own) -or
                -not @(Get-ChildPath $own -File -Filter $language.Pattern -Depth 3).Count) {
                continue
            }
            $records.Add([pscustomobject]@{
                    Language = $language.Language
                    Module   = $module.name
                    Folder   = $own
                    Name     = $module.name
                })
        }
    }

    if ($unmatched.Count -gt 0) {
        throw "Test folder(s) matching no catzc module: $($unmatched -join ', '). A test folder is named for its catzc module's folder in its language's folder case (Catzc.Base.Repository, folder Base.Repository, is base_repository in snake, baserepository in flat, base-repository in kebab)."
    }
    $records
}
