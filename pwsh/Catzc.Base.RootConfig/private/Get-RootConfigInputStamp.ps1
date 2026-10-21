<#
---
catzc:
  immutable:
    with_body_sha: "5ebfc2db408c"
  edges:
    test: pwsh/Catzc.Base.RootConfig/tests/Get-RootConfigInputStamp.Tests.ps1
    docs: "[Get-RootConfigInputStamp.ps1.md](docs/references/pwsh/catzc-base-root-config/private/Get-RootConfigInputStamp.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
      - ADR-PWSH-ENUM-RAWDOTNETENUMERATION
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
    foreach ($module in 'Catzc.Base.RootConfig', 'Catzc.Base.VSCode', 'Catzc.Base.Git', 'Catzc.Base.Contracts') {
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
