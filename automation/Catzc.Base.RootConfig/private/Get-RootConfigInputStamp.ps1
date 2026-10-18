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
  config:
    synopsis: Hashes everything that feeds the root configs and everything they write, so an unchanged tree is one short comparison.
    description: |-
      One stamp over the inputs and the outputs of Build-RootConfig
      ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)): every source an entry declares, the loaded
      modules whose code renders the targets (RootConfig with its registry, VSCode, Git, and the two Languages generators),
      and every existing target, so a target edited or deleted by hand changes the stamp too. For a wildcard entry the folders
      its pattern can match are listed through the bounded walker
      ([ADR-PWSH-ENUM#1](/docs/adr/pwsh/enumerate-bounded.md#rule-adr-pwsh-enum1)) and salt the stamp, so a new test folder that
      would gain a file changes it; a link entry salts it with whether its link exists. Tests and READMEs under the modules are
      left out: they change nothing that is rendered.
    parameters:
      Entries: The opted-in root-config entries (Get-RootConfigTargets).
    outputs: '[string] The stamp, a 64-digit hash.'
    examples:
      - Get-RootConfigInputStamp -Entries (Get-RootConfigTargets -Config (Get-Config -Config rootconfig))
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
