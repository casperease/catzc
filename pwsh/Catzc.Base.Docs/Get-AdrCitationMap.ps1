<#
---
catzc:
  immutable:
    with_body_sha: ea753bc9f0ed
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1
    docs: "[Get-AdrCitationMap.ps1.md](docs/references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-PWSH-ERROR
      - ADR-REPO-LINK-CODELINKS
---
#>

function Get-AdrCitationMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Docs.AdrCitationMap])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:adrCitationMapCache')) {
        $script:adrCitationMapCache = @{}
    }
    if ($script:adrCitationMapCache.ContainsKey($root)) {
        return $script:adrCitationMapCache[$root]
    }

    $records = (Get-Config -Config adrs).Root
    $adrRoot = Join-Path $root $records
    $indexPath = Join-Path $adrRoot 'index.md'
    Assert-PathExist $indexPath -PathType Leaf

    $entries = @{}
    foreach ($row in (Get-CatsAdrIndex -IndexPath $indexPath)) {
        $adrFile = Join-Path $adrRoot $row.Path
        $entries[$row.Code] = @{
            path  = "$records/" + ($row.Path -replace '\\', '/')
            rules = [string[]] @(Get-CatsAdrRules -AdrPath $adrFile | ForEach-Object Id)
        }
    }

    # An ADR sits at most three levels below docs/drs (domain, subfolder, file); the fourth level is headroom.
    $documents = foreach ($file in Get-ChildPath $adrRoot -File -Filter '*.md' -Depth 4) {
        [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
    }

    $map = [Catzc.Base.Docs.AdrCitationMap]::new($entries, @($documents))
    $script:adrCitationMapCache[$root] = $map
    $map
}
