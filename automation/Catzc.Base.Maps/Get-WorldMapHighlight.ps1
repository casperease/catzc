# catzc:
#   path: automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
#   module: Catzc.Base.Maps
#   visibility: public

<#
.SYNOPSIS
    Returns the world-map cells that ADR codes or a drawing's files light.
.DESCRIPTION
    With no -Adr or -Path, the working-tree changes light cells; a changed file the map lacks lights nothing.
    [ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)
    [comment:1](/docs/references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md#comment1)
.PARAMETER Adr
    The ADR codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.
.PARAMETER Path
    The repository-relative paths of tracked files. A path the map does not hold throws.
.PARAMETER AsJson
    JSON also carries each file's reason (basis, covering request, citation sites), which the object holds too.
    [ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)
    [comment:2](/docs/references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md#comment2)
.OUTPUTS
    [Catzc.Base.Maps.WorldMapHighlight], or [string] with -AsJson.
.EXAMPLE
    (Get-WorldMapHighlight).Cells             # the cells the working tree's changes sit in
.EXAMPLE
    (Get-WorldMapHighlight ADR-FLOW-CD).Cells
.EXAMPLE
    Get-WorldMapHighlight -Adr 'ADR-DSGN-TRACK#3' -AsJson
.EXAMPLE
    Get-WorldMapHighlight -Path 'pipelines/ci-automation.yaml', 'automation/Catzc.Base.Maps/Get-WorldMap.ps1'
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
