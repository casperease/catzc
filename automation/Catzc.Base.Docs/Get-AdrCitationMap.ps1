<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: public
    adrs:
      - ADR-AUTO-CACHE
      - ADR-PWSH-CACHE#4
      - ADR-PWSH-ERROR
      - ADR-REPO-LINK#3
---
#>

<#
.SYNOPSIS
    Builds the ADR citation map: every citation code to its ADR's path and declared rule numbers.
.DESCRIPTION
    The map is memoized per root for the session, so a changed ADR file shows only after the importer reruns.
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
        # GetValue gives null for an unset script variable, where a plain read would throw under strict mode.
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

    # An ADR sits at most three levels below docs/adr (domain, subfolder, file); the fourth level is headroom.
    $documents = foreach ($file in Get-ChildPath $adrRoot -File -Filter '*.md' -Depth 4) {
        [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
    }

    $map = [Catzc.Base.Docs.AdrCitationMap]::new($entries, @($documents))
    $script:adrCitationMapCache[$root] = $map
    $map
}
