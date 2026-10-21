<#
---
catzc:
  immutable:
    with_body_sha: df6de6fdb4a9
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-CatsAdrIndex.Tests.ps1
    docs: "[Get-CatsAdrIndex.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-CatsAdrIndex.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
---
#>

function Get-CatsAdrIndex {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Resolve-RepoPath 'docs/adr/index.md')
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:catsAdrIndexCache')) {
        $script:catsAdrIndexCache = @{}
    }
    if ($script:catsAdrIndexCache.ContainsKey($IndexPath)) {
        return , $script:catsAdrIndexCache[$IndexPath]
    }

    Assert-PathExist $IndexPath

    $lines = [System.IO.File]::ReadAllLines($IndexPath)
    $ret = foreach ($line in $lines) {
        if ($line -notmatch '^\|\s*`(?<code>ADR(?:-[A-Z][A-Z0-9]*)+)`\s*\|\s*\[(?<title>[^\]]+)\]\((?<path>[^)]+)\)') {
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
