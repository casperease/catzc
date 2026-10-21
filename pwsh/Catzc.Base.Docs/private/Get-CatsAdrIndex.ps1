<#
---
catzc:
  immutable:
    with_body_sha: "132df9dd97e2"
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
        [string] $IndexPath = (Resolve-RepoPath "$((Get-Config -Config adrs).Root)/index.md")
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:catsAdrIndexCache')) {
        $script:catsAdrIndexCache = @{}
    }
    if ($script:catsAdrIndexCache.ContainsKey($IndexPath)) {
        return , $script:catsAdrIndexCache[$IndexPath]
    }

    Assert-PathExist $IndexPath

    $row = "^\|\s*``(?<code>$((Get-Config -Config adrs).CodeForm.Cited))``\s*\|\s*\[(?<title>[^\]]+)\]\((?<path>[^)]+)\)"
    $lines = [System.IO.File]::ReadAllLines($IndexPath)
    $ret = foreach ($line in $lines) {
        if ($line -notmatch $row) {
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
