<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-BASH#2
      - ADR-AUTO-GO#2
      - ADR-AUTO-PY#2
      - ADR-DSGN-TRACK#2
---
#>

<#
.SYNOPSIS
    Lists the repository's test folders in every test language beside PowerShell, each mapped to the catzc module
    it tests.
.DESCRIPTION
    A folder matching no catzc module throws and is named, since an unmapped test folder would otherwise never run.
.OUTPUTS
    [pscustomobject] One record per test folder ({ Language; Module; Folder; Name }), by language (go, python, then
    bash) and ordinal by folder name within it: Language is go, python or bash, Module the catzc module name, Folder the
    absolute folder path, Name the folder name. Nothing when the repository has no such folder.
.EXAMPLE
    Get-LanguageTestFolders | Where-Object Module -EQ 'Catzc.Base.Repository'
#>
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

    # Read from the repository, not the code root, so a build run maps a test folder as a source run does.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md#comment2)
    $modulesByKebab = @{}
    $automationRoot = [System.IO.Path]::Combine($repositoryRoot, 'automation')
    if ([System.IO.Directory]::Exists($automationRoot)) {
        foreach ($module in (Get-AutomationModules -AutomationRoot $automationRoot)) {
            $modulesByKebab[$module.ToLowerInvariant().Replace('.', '-')] = $module
        }
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
