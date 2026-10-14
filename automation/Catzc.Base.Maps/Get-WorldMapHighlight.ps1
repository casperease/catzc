<#
.SYNOPSIS
    Returns the world-map cells that ADR codes or a drawing's files light.
.DESCRIPTION
    Builds the world map (Get-WorldMap) and lights its cells with Catzc.Base.Maps.WorldMapHighlight.

    -Adr lights, for each code (ADR-<CODE>, or one rule as ADR-<CODE>#n or ADR-<CODE>:n): the ADR files of the code's
    domain, and every file whose citations name it, in the fixed order per artifact kind the map derives (module code by
    its own citations, a repository-root file by its files.yml owner, a pipeline by its citations or else its globset).
    The reviewed exceptions and pins of configs/maps.yml then apply: an exception keeps its cell dark and a pin lights
    its cell. -Path lights the cells the given tracked files sit in
    ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)).

    With neither, it answers "where does my change sit on the map": the files the working tree changes against HEAD
    and the index (modified, added, deleted or untracked; Get-GitChangedPath) light the cells they sit in, as
    with -Path. The map holds the files git tracks, so a changed file it does not hold (an untracked file, or one
    whose removal is staged) lights nothing and is named in the verbose stream. With no change, no cell is lit.
.PARAMETER Adr
    The ADR codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.
.PARAMETER Path
    The repository-relative paths of tracked files. A path the map does not hold throws.
.PARAMETER AsJson
    Return the highlight as JSON (the request, and the lit cells with their files and each file's reason: the basis,
    the covering request and the citation sites with their lines and kinds) instead of the object
    ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
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
