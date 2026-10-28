function Export-WorldMapPdf {
    [CmdletBinding(DefaultParameterSetName = 'Plain')]
    [OutputType([string])]
    param(
        [ValidateSet('Grid', 'Tree')]
        [string[]] $View = @('Grid', 'Tree'),

        [Parameter(Mandatory, ParameterSetName = 'Rule')]
        [ArgumentCompleter({ (Get-Config -Config drs).RuleSets.External })]
        [string[]] $Rule,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string[]] $Path
    )

    $config = Get-Config -Config maps
    $map = Get-WorldMap
    $highlight = $null
    $suffix = ''
    if ($PSCmdlet.ParameterSetName -eq 'Rule') {
        $highlight = Get-WorldMapHighlight -Rule $Rule
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
