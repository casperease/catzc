<#
.SYNOPSIS
    Builds the ADR citation map: every citation code to its ADR's path and declared rule numbers.
.DESCRIPTION
    Reads the rule-citation registry in `<root>/docs/adr/index.md` (Get-CatsAdrIndex) and each listed ADR's
    `### Rule <CODE>:<n>` headings (Get-CatsAdrRules), and returns one immutable
    [Catzc.Base.Docs.AdrCitationMap]: code -> repository-relative ADR path and rule numbers, the reverse
    path -> code map, and a unique-slug -> path map over every markdown file under docs/adr/ (so a stale path
    to a moved ADR resolves by its file name). The link engine derives every code link's destination from it
    ([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)).

    A pure function of the files on disk, memoized per resolved repository root for the session (re-run the
    importer to refresh — see
    [ADR-AUTO-CACHE](/docs/adr/automation/caching.md)); a test passes a fixture root, so the fixture
    map and the real one never collide.
.PARAMETER RepositoryRoot
    The repository root whose [index](/docs/adr/index.md) is read. Defaults to the loaded repository root.
.OUTPUTS
    [Catzc.Base.Docs.AdrCitationMap]
.EXAMPLE
    (Get-AdrCitationMap).Destination('ADR-AUTO-ERROR', 3)   # /docs/adr/automation/powershell/error-handling.md#rule-adr-auto-error3
#>
function Get-AdrCitationMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Docs.AdrCitationMap])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:adrCitationMapCache')) {
        # strict-clean probe of the lazy slot
        # ([ADR-AUTO-PSCACHE#4](/docs/adr/automation/powershell/script-scope-caching.md#rule-adr-auto-pscache4))
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
