<#
.SYNOPSIS
    Lists the repository's Go test folders, each mapped to the catzc module it tests.
.DESCRIPTION
    A Go test folder is an immediate, non-dot-prefixed subdirectory of <goRoot>/tests/ that holds at least one .go
    file (the same folders New-GoWorkspace renders a go.mod for). The Go root comes from go.yml through
    GoConfig.ResolveRoot: the declared root, else go/ when the repository has one, else .go/. Each folder is named
    for its catzc module in kebab case — the module name lowercased, with dots replaced by hyphens
    (Catzc.Base.Repository -> catzc-base-repository) — and maps back to the module folder under
    <repository>/automation/ of that kebab name. The harness runs a mapped folder's Go tests as part of that
    module's tests (Get-TestAutomationTestPaths, the Go bridge).

    Throws, naming every such folder, when a Go test folder matches no catzc module: an unmapped folder would
    otherwise never run.
.OUTPUTS
    [pscustomobject] One record per Go test folder ({ Module; Folder; Name }), ordinal by folder name: Module is
    the catzc module name, Folder the absolute folder path, Name the folder name. Nothing when the repository has
    no Go test folder.
.EXAMPLE
    Get-GoTestFolders | Where-Object Module -EQ 'Catzc.Base.Repository'
#>
function Get-GoTestFolders {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $repositoryRoot = Get-RepositoryRoot
    $goRoot = (Get-Config -Config go).ResolveRoot($repositoryRoot)
    $testsRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $goRoot, 'tests'))
    if (-not [System.IO.Directory]::Exists($testsRoot)) {
        return
    }

    # The catzc modules of the source tree, by kebab name: the folders under <repository>/automation/, read from the
    # repository (never the code root), so a build run maps a Go folder the same way a source run does.
    $modulesByKebab = @{}
    $automationRoot = [System.IO.Path]::Combine($repositoryRoot, 'automation')
    if ([System.IO.Directory]::Exists($automationRoot)) {
        foreach ($module in (Get-AutomationModules -AutomationRoot $automationRoot)) {
            $modulesByKebab[$module.ToLowerInvariant().Replace('.', '-')] = $module
        }
    }

    $folders = @([System.IO.Directory]::GetDirectories($testsRoot))
    [System.Array]::Sort($folders, [System.StringComparer]::Ordinal)
    $unmatched = [System.Collections.Generic.List[string]]::new()
    $records = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($folder in $folders) {
        $name = [System.IO.Path]::GetFileName($folder)
        if ($name.StartsWith('.')) {
            continue
        }
        if (-not @([System.IO.Directory]::GetFiles($folder, '*.go', [System.IO.SearchOption]::AllDirectories)).Count) {
            continue
        }
        if (-not $modulesByKebab.ContainsKey($name)) {
            $unmatched.Add("$goRoot/tests/$name/")
            continue
        }
        $records.Add([pscustomobject]@{
                Module = $modulesByKebab[$name]
                Folder = $folder
                Name   = $name
            })
    }

    if ($unmatched.Count -gt 0) {
        throw "Go test folder(s) matching no catzc module: $($unmatched -join ', '). A Go test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository for Catzc.Base.Repository)."
    }
    $records
}
