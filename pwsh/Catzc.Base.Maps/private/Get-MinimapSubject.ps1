<#
---
catzc:
  immutable:
    with_body_sha: "9175b823b057"
---
#>

function Get-MinimapSubject {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string[]] $Adr,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [System.Collections.IDictionary] $Facts
    )

    $map = if ($WorldMap) {
        $WorldMap
    }
    else {
        Get-WorldMap
    }
    $reasons = @(foreach ($cell in (Get-WorldMapHighlight -Adr $Adr -WorldMap $map).Cells) {
            foreach ($reason in $cell.Reasons) {
                if ($reason.Path) {
                    $reason
                }
            }
        })
    # Facts read once for every folder of a call are handed in; a path they lack has no facts.
    if ($null -eq $Facts) {
        $Facts = Get-MinimapFact -Path @($reasons | ForEach-Object Path)
    }
    foreach ($reason in $reasons) {
        $placement = $map.Placement($reason.Path)
        [pscustomobject]@{
            Path      = $reason.Path
            Requested = $reason.Requested
            Citations = [string[]] @(if ($placement) {
                    $placement.Citations
                })
            Facts     = $Facts[$reason.Path]
        }
    }
}
