function Get-LanguageTestFolders {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $repositoryRoot = Get-RepositoryRoot
    # Each language's root and the file pattern that makes a folder under its tests/ a test folder.
    $languages = @(
        [pscustomobject]@{ Language = 'go'; Root = (Get-Config -Config go).ResolveRoot($repositoryRoot); Pattern = '*.go' }
        [pscustomobject]@{ Language = 'python'; Root = (Get-Config -Config python).ResolveRoot($repositoryRoot); Pattern = 'test_*.py' }
        [pscustomobject]@{ Language = 'bash'; Root = (Get-Config -Config bash).ResolveRoot($repositoryRoot); Pattern = '*.bats' }
    )

    $modulesByKebab = @{}
    foreach ($module in (Get-CatzcModule -TrackType modules).name) {
        $modulesByKebab[$module.ToLowerInvariant().Replace('.', '-')] = $module
    }

    $unmatched = [System.Collections.Generic.List[string]]::new()
    $records = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($language in $languages) {
        $testsRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $language.Root, 'tests'))
        if (-not [System.IO.Directory]::Exists($testsRoot)) {
            continue
        }
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

    if ($unmatched.Count -gt 0) {
        throw "Test folder(s) matching no catzc module: $($unmatched -join ', '). A test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository for Catzc.Base.Repository)."
    }
    $records
}
