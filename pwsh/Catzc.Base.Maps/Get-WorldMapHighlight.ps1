<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md"
  warning: "Generated Header"
---
#>

function Get-WorldMapHighlight {
    [CmdletBinding(DefaultParameterSetName = 'Changes')]
    [OutputType([Catzc.Base.Maps.WorldMapHighlight], [string])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Adr')]
        [ArgumentCompleter({ (Get-Config -Config drs).RuleSets.External })]
        [string[]] $Adr,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string[]] $Path,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [switch] $AsJson
    )

    $map = if ($WorldMap) {
        $WorldMap
    }
    else {
        Get-WorldMap
    }
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
