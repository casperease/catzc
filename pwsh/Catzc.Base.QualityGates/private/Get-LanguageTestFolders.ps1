function Get-LanguageTestFolders {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $repositoryRoot = Get-RepositoryRoot
    # Each language with a test runner: its root from its own config, named for the language, and its test-file pattern from the registry.
    $languages = @(foreach ($entry in (Get-Config -Config languages).languages) {
            if ($entry.tests) {
                [pscustomobject]@{ Language = $entry.name; Root = (Get-Config -Config $entry.name).ResolveRoot($repositoryRoot); Pattern = $entry.tests.pattern }
            }
        })

    $modulesByKebab = @{}
    foreach ($module in (Get-CatzcModule -EngineTrack).name) {
        $modulesByKebab[$module.ToLowerInvariant().Replace('.', '-')] = $module
    }

    $unmatched = [System.Collections.Generic.List[string]]::new()
    $records = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($language in $languages) {
        # The track's own test holder: one folder per catzc module, named for it in kebab case, testing it from outside.
        $testsRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $language.Root, 'tests'))
        if ([System.IO.Directory]::Exists($testsRoot)) {
            $folders = @([System.IO.Directory]::GetDirectories($testsRoot))
            [System.Array]::Sort($folders, [System.StringComparer]::Ordinal)
            foreach ($folder in $folders) {
                $name = [System.IO.Path]::GetFileName($folder)
                if ($name.StartsWith('.')) {
                    continue
                }
                # A module folder holds its test files directly or in a package one level down; the third level is headroom.
                if (-not @(Get-ChildPath $folder -File -Filter $language.Pattern -Depth 3).Count) {
                    continue
                }
                if (-not $modulesByKebab.ContainsKey($name)) {
                    $unmatched.Add("$($language.Root)/tests/$name/")
                    continue
                }
                $records.Add([pscustomobject]@{
                        Language = $language.Language
                        Module   = $modulesByKebab[$name]
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
            $own = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $module.root, 'tests'))
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
        throw "Test folder(s) matching no catzc module: $($unmatched -join ', '). A test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository for Catzc.Base.Repository)."
    }
    $records
}
