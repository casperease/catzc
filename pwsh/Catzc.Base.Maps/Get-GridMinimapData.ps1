<#
---
catzc:
  immutable:
    with_body_sha: ad4e31d2e7fd
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-GridMinimapData.Tests.ps1
    docs: "[Get-GridMinimapData.ps1.md](../../docs/references/pwsh/catzc-base-maps/Get-GridMinimapData.ps1.md)"
    cites:
      - ADR-AUTO-ENGINE
---
#>

function Get-GridMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [switch] $AsJson
    )

    $map = if ($WorldMap) {
        $WorldMap
    }
    else {
        Get-WorldMap
    }
    # Tracks down, file languages across: a cell is lit by the subject's files in it.
    $data = [Catzc.Base.Maps.MinimapData]::FromWorldMap($map, (Get-WorldMapHighlight -Adr $Adr -WorldMap $map))
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
