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
    $moduleNames =@((Get-CatzcModule -EngineTrack).name.Where({ [Catzc.Base.Objects.NameCase]::IsInCase('pascal-dotted', $_) }))
    $languages = @(foreach ($entry in $languagesConfig.languages) {
            if ($entry.tests) {
                $modulesByFolder = @{}
                foreach ($module in $moduleNames) {
                    $modulesByFolder[$languagesConfig.TestFolderOf($entry.name, $module)] = $module
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
        # The track's own test holder: one folder per catzc module, named for it in the language's folder case, testing it from outside.
        $testsRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $language.Root, $testFolderName))
        if ([System.IO.Directory]::Exists($testsRoot)) {
            foreach ($folder in Get-ChildPath $testsRoot -Depth 1 -Directory -Exclude @() -PruneVendor $false) {
                $name = [System.IO.Path]::GetFileName($folder)
                if ($name.StartsWith('.')) {
                    continue
                }
                # A module folder holds its test files directly or in a package one level down; the third level is headroom.
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
            $own = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $module.root, $testFolderName))
            if (-not [System.IO.Directory]::Exists($own) -or -not @(Get-ChildPath $own -File -Filter $language.Pattern -Depth 3).Count) {
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
        throw "Test folder(s) matching no catzc module: $($unmatched -join ', '). A test folder is named for its catzc module in its language's folder case (Catzc.Base.Repository is catzc_base_repository in snake, catzcbaserepository in flat, catzc-base-repository in kebab)."
    }
    $records
}
