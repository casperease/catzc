<#
---
catzc:
  immutable:
    with_body_sha: "72cb657f87c8"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Export-WorldMapPdf.Tests.ps1
    docs: "[Export-WorldMapPdf.ps1.md](docs/references/pwsh/catzc-base-maps/Export-WorldMapPdf.ps1.md)"
    cites:
      - ADR-REPO-OUTDIR-SUBDIRECTORYPERPRODUCER
      - DDR-TRACK-ONETECHSTACK
      - DDR-TRACK-ROOTFILE
      - DDR-TRACK-UNLISTEDFILE
---
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
