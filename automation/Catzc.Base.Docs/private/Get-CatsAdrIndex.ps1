<#
.SYNOPSIS
    Parses the ADR index (docs/adr/index.md) into the code -> ADR entries that Show-Cats presents.
.DESCRIPTION
    Reads the rule-citation registry tables in docs/adr/index.md and returns one entry per ADR: its citation
    code, its title slug, and its index-relative path. A pure function of the file on disk, memoized per
    resolved index path for the session (re-run the importer to refresh — see docs/adr/automation/caching.md).
    Inline code-span mentions of a code (in prose) are not table rows and are ignored.

    Private helper for Show-Cats; not exported.
.PARAMETER IndexPath
    Absolute path to the ADR index. Defaults to docs/adr/index.md under the repository root. A test points this
    at a fixture index; the cache keys on the path, so a fixture path and the real path never collide.
.OUTPUTS
    [object[]] One { Code; Title; Path } per ADR row in the index.
#>
function Get-CatsAdrIndex {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Resolve-RepoPath 'docs/adr/index.md')
    )

    if (-not $script:catsAdrIndexCache) {
        $script:catsAdrIndexCache = @{}
    }
    if ($script:catsAdrIndexCache.ContainsKey($IndexPath)) {
        return , $script:catsAdrIndexCache[$IndexPath]
    }

    Assert-PathExist $IndexPath

    $lines = [System.IO.File]::ReadAllLines($IndexPath)
    $ret = foreach ($line in $lines) {
        if ($line -notmatch '^\|\s*`(?<code>ADR-[A-Z]+(?:-[A-Z]+)*)`\s*\|\s*\[(?<title>[^\]]+)\]\((?<path>[^)]+)\)') {
            continue
        }
        [pscustomobject]@{
            Code  = $Matches['code']
            Title = $Matches['title']
            Path  = $Matches['path']
        }
    }

    $ret = @($ret)
    $script:catsAdrIndexCache[$IndexPath] = $ret
    , $ret
}
