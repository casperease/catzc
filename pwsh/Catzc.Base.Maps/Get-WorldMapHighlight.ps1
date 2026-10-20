<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
    name: get-world-map-highlight
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
    docs: "[Get-WorldMapHighlight.ps1.md](docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md)"
    cites:
      - ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER
      - ADR-DSGN-TRACK-ONETECHSTACK
      - ADR-FLOW-CD
      - ADR-THES-ONETRUTH-TRUTHISQUERYABLE
---
#>

function Get-WorldMapHighlight {
    [CmdletBinding(DefaultParameterSetName = 'Changes')]
    [OutputType([Catzc.Base.Maps.WorldMapHighlight], [string])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Adr')]
        [ArgumentCompleter({ (Get-Config -Config adrs).RuleSets.External })]
        [string[]] $Adr,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string[]] $Path,

        [switch] $AsJson
    )

    $map = Get-WorldMap
    $highlight = switch ($PSCmdlet.ParameterSetName) {
        'Path' {
            [Catzc.Base.Maps.WorldMapHighlight]::ForPaths($map, $Path)
        }
        'Adr' {
            $overrides = (Get-Config -Config maps).highlight
            [Catzc.Base.Maps.WorldMapHighlight]::ForAdr($map, $Adr, $overrides.pins, $overrides.exceptions)
        }
        default {
            $onMap = [System.Collections.Generic.List[string]]::new()
            foreach ($changed in @(Get-GitChangedPath)) {
                if ($null -eq $map.Placement($changed)) {
                    Write-Verbose "Get-WorldMapHighlight: '$changed' is not a tracked file of the map; it lights nothing"
                    continue
                }
                $onMap.Add($changed)
            }
            [Catzc.Base.Maps.WorldMapHighlight]::ForPaths($map, $onMap.ToArray())
        }
    }
    if ($AsJson) {
        return $highlight.ToJson()
    }
    $highlight
}
