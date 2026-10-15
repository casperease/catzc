<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-CatsAdrIndex.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
---
#>

<#
.SYNOPSIS
    Parses the ADR index ([index](/docs/adr/index.md)) into the code -> ADR entries that Show-Cats presents.
.DESCRIPTION
    Memoized per index path for the session, so an edited index shows only after the importer reruns.
    [ADR-AUTO-CACHE](/docs/adr/automation/caching.md)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-CatsAdrIndex.ps1.md#comment1)
.PARAMETER IndexPath
    A test points this at a fixture index; the cache keys on the path, so fixture and real index never collide.
    [comment:2](/docs/references/automation/catzc-base-docs/private/Get-CatsAdrIndex.ps1.md#comment2)
.OUTPUTS
    [object[]] One { Code; Title; Path } per ADR row in the index.
#>
function Get-CatsAdrIndex {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Resolve-RepoPath 'docs/adr/index.md')
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:catsAdrIndexCache')) {
        # strict-clean probe of the lazy cache entry
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:3](/docs/references/automation/catzc-base-docs/private/Get-CatsAdrIndex.ps1.md#comment3)
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
