<#
.SYNOPSIS
    Builds the ADR citation map: every citation code to its ADR's path and declared rule numbers.
.DESCRIPTION
    Reads the rule-citation registry in `<root>/docs/adr/index.md` (Get-CatsAdrIndex) and each listed ADR's `### Rule...
    [ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3),
    [ADR-AUTO-CACHE](/docs/adr/automation/caching.md)
    [comment:1](/docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root whose [index](/docs/adr/index.md) is read. Defaults to the loaded repository root.
.OUTPUTS
    [Catzc.Base.Docs.AdrCitationMap]
.EXAMPLE
    (Get-AdrCitationMap).Destination('ADR-PWSH-ERROR', 3)   # /docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error3
#>
function Get-AdrCitationMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Docs.AdrCitationMap])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:adrCitationMapCache')) {
        # strict-clean probe of the lazy cache entry
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:2](/docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md#comment2)
        $script:adrCitationMapCache = @{}
    }
    if ($script:adrCitationMapCache.ContainsKey($root)) {
        return $script:adrCitationMapCache[$root]
    }

    $adrRoot = Join-Path $root 'docs/adr'
    $indexPath = Join-Path $adrRoot 'index.md'
    Assert-PathExist $indexPath -PathType Leaf

    $entries = @{}
    foreach ($row in (Get-CatsAdrIndex -IndexPath $indexPath)) {
        $adrFile = Join-Path $adrRoot $row.Path
        $rules = foreach ($rule in (Get-CatsAdrRules -AdrPath $adrFile)) {
            [int] ($rule.Id -split ':')[-1]
        }
        $entries[$row.Code] = @{
            path  = 'docs/adr/' + ($row.Path -replace '\\', '/')
            rules = @($rules)
        }
    }

    $documents = foreach ($file in [System.IO.Directory]::EnumerateFiles($adrRoot, '*.md', [System.IO.SearchOption]::AllDirectories)) {
        [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
    }

    $map = [Catzc.Base.Docs.AdrCitationMap]::new($entries, @($documents))
    $script:adrCitationMapCache[$root] = $map
    $map
}
