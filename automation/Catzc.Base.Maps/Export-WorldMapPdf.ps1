# catzc:
#   path: automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
#   module: Catzc.Base.Maps
#   visibility: public

<#
.SYNOPSIS
    Writes the world map as PDFs: the grid view, the tree view, or both, optionally with a highlight.
.DESCRIPTION
    One file per view, so each opens or is replaced alone; an unchanged repository writes byte-identical files.
    [ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2),
    [ADR-DSGN-TRACK#7](/docs/adr/design/tracks.md#rule-adr-dsgn-track7),
    [ADR-DSGN-TRACK#8](/docs/adr/design/tracks.md#rule-adr-dsgn-track8),
    [ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)
    [comment:1](/docs/references/automation/catzc-base-maps/Export-WorldMapPdf.ps1.md#comment1)
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
