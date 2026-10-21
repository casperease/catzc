<#
---
catzc:
  immutable:
    with_body_sha: "67552d3e98fc"
  edges:
    test: pwsh/Catzc.Base.Drs/tests/Get-DrsCitationMap.Tests.ps1
    docs: "[Get-DrsCitationMap.ps1.md](../../docs/references/pwsh/catzc-base-drs/Get-DrsCitationMap.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-PWSH-ERROR
      - ADR-REPO-LINK-CODELINKS
---
#>

function Get-DrsCitationMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Drs.DrsCitationMap])]
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

    $records = (Get-Config -Config drs).Root
    $adrRoot = Join-Path $root $records
    $indexPath = Join-Path $adrRoot 'index.md'
    Assert-PathExist $indexPath -PathType Leaf

    $entries = @{}
    foreach ($row in (Get-CatsDrsIndex -IndexPath $indexPath)) {
        $adrFile = Join-Path $adrRoot $row.Path
        $entries[$row.Code] = @{
            path  = "$records/" + ($row.Path -replace '\\', '/')
            rules = [string[]] @(Get-CatsDrsRules -DrsPath $adrFile | ForEach-Object Id)
        }
    }

    # An ADR sits at most three levels below docs/drs (domain, subfolder, file); the fourth level is headroom.
    $documents = foreach ($file in Get-ChildPath $adrRoot -File -Filter '*.md' -Depth 4) {
        [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
    }

    $map = [Catzc.Base.Drs.DrsCitationMap]::new($entries, @($documents))
    $script:adrCitationMapCache[$root] = $map
    $map
}
