<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.RootConfig/private/Get-RootConfigInputStamp.ps1
    folder: private
    name: get-root-config-input-stamp
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.RootConfig/tests/Get-RootConfigInputStamp.Tests.ps1
    cites:
      - ADR-AUTO-CACHE#10
      - ADR-PWSH-ENUM#1
---
#>

function Get-RootConfigInputStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Entries
    )

    $repositoryRoot = Get-RepositoryRoot
    $paths = [System.Collections.Generic.List[string]]::new()
    $salt = [System.Collections.Generic.List[string]]::new()

    # The generators' code is read from the loaded modules, so a fixture tree hashes the same code the run uses.
    foreach ($module in 'Catzc.Base.RootConfig', 'Catzc.Base.VSCode', 'Catzc.Base.Git') {
        $loaded = Get-Module -Name $module
        if ($loaded) {
            $paths.Add($loaded.ModuleBase)
        }
    }
    $languages = Get-Module -Name Catzc.Base.Languages
    if ($languages) {
        foreach ($generator in 'New-GoWorkspace.ps1', 'New-PythonProject.ps1') {
            $paths.Add((Join-Path $languages.ModuleBase $generator))
        }
    }

    foreach ($entry in $Entries) {
        foreach ($listed in @(@($entry.source) + @($entry.sources) | Where-Object { $_ })) {
            $paths.Add((Resolve-RepoPath $listed))
        }
        $target = [string] $entry.target
        if ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($target)) {
            $slash = $target.LastIndexOf('/')
            $folderPattern = $target.Substring(0, $slash)
            $leaf = $target.Substring($slash + 1)
            $depth = @($folderPattern -split '/').Count
            foreach ($folder in Get-ChildPath $repositoryRoot -Depth $depth -Directory -Exclude @('.git', '.vendor', 'out', 'node_modules') -PruneVendor $true) {
                $relative = [System.IO.Path]::GetRelativePath($repositoryRoot, $folder).Replace('\', '/')
                if ($relative -cnotlike $folderPattern) {
                    continue
                }
                $salt.Add("folder:$relative")
                $candidate = [System.IO.Path]::Combine($folder, $leaf)
                if ([System.IO.File]::Exists($candidate)) {
                    $paths.Add($candidate)
                }
            }
        }
        elseif ($entry.copyAsLink) {
            $item = Get-Item -LiteralPath (Resolve-RepoPath $target) -Force -ErrorAction Ignore
            $salt.Add("link:${target}:$([bool] ($item -and $item.LinkType))")
        }
        else {
            $full = Resolve-RepoPath $target
            if ([System.IO.File]::Exists($full)) {
                $paths.Add($full)
            }
            else {
                $salt.Add("missing:$target")
            }
        }
    }

    $salt.Sort([System.StringComparer]::Ordinal)
    Get-InputStamp -Path $paths.ToArray() -Exclude @('*/tests/*', '*/README.md') -Root $repositoryRoot -Salt ($salt -join ';')
}
