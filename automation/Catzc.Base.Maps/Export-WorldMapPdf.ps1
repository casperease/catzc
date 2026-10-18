<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
    name: export-world-map-pdf
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Maps/tests/Export-WorldMapPdf.Tests.ps1
    cites:
      - ADR-DSGN-TRACK#{3,7,8}
      - ADR-REPO-OUTDIR#2
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
