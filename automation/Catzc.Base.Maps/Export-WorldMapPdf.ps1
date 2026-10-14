<#
.SYNOPSIS
    Writes the world map as PDFs: the grid view, the tree view, or both, optionally with a highlight.
.DESCRIPTION
    Builds the world map (Get-WorldMap) and draws it with Catzc.Base.Maps.WorldMapPdf, one file per view under the
    world-map output folder (Get-WorldMapOutputRoot,
    [ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)):
      world-map.grid.pdf   rows are the tracks, columns the file languages, each cell shaded by its file count; the
                           catch-all row holds the root files and the catch-all column the unlisted files
                           ([ADR-DSGN-TRACK#7](/docs/adr/design/tracks.md#rule-adr-dsgn-track7),
                           [ADR-DSGN-TRACK#8](/docs/adr/design/tracks.md#rule-adr-dsgn-track8)), and a cell that
                           breaks its track's tech-stack is marked
                           ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3));
      world-map.tree.pdf   the tracks as a treemap by file count, each holding its non-empty cells.
    One file per view, not one two-page file: each view is a document of its own that a reader opens, links or
    replaces alone, and -View Grid rewrites the grid without touching the tree.

    With -Adr or -Path the lit cells (Get-WorldMapHighlight) are outlined on every page, and the files are named
    world-map.<view>.highlight.pdf, so a highlight never overwrites the plain map. The colours, titles, legend entries,
    label limits and page size come from configs/maps.yml (Get-Config -Config maps). The bytes depend only on the map,
    the config and the highlight, so an unchanged repository writes identical files.
.PARAMETER View
    The views to write: Grid, Tree, or both (the default).
.PARAMETER Adr
    Outline the cells these ADR codes light (each optionally narrowed to one rule, #n or :n).
.PARAMETER Path
    Outline the cells these tracked files sit in.
.OUTPUTS
    [string] the absolute path of every written file, grid first.
.EXAMPLE
    Export-WorldMapPdf
.EXAMPLE
    Export-WorldMapPdf -View Grid -Adr 'ADR-DSGN-TRACK#3'
.EXAMPLE
    Export-WorldMapPdf -Path 'pipelines/ci-automation.yaml'
#>
function Export-WorldMapPdf {
    [CmdletBinding(DefaultParameterSetName = 'Plain')]
    [OutputType([string])]
    param(
        [ValidateSet('Grid', 'Tree')]
        [string[]] $View = @('Grid', 'Tree'),

        [Parameter(Mandatory, ParameterSetName = 'Adr')]
        [ArgumentCompleter({ (Get-Config -Config adrs).RuleSets.External })]
        [string[]] $Adr,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string[]] $Path
    )

    $config = Get-Config -Config maps
    $map = Get-WorldMap
    $highlight = $null
    $suffix = ''
    if ($PSCmdlet.ParameterSetName -eq 'Adr') {
        $highlight = Get-WorldMapHighlight -Adr $Adr
        $suffix = '.highlight'
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'Path') {
        $highlight = Get-WorldMapHighlight -Path $Path
        $suffix = '.highlight'
    }

    $folder = Get-WorldMapOutputRoot -EnsureExists
    foreach ($name in @('Grid', 'Tree')) {
        if ($View -notcontains $name) {
            continue
        }
        $document = [Catzc.Base.Maps.WorldMapPdf]::Render($map, $config, $highlight, $name -eq 'Grid', $name -eq 'Tree')
        $file = Join-Path $folder "world-map.$($name.ToLowerInvariant())$suffix.pdf"
        [System.IO.File]::WriteAllBytes($file, $document.ToBytes())
        $file
    }
}
