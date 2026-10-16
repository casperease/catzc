<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/Export-WorldMapPdf.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Maps
    relatives:
      source: automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
---
#>

# cspell:ignore startxref
BeforeAll {
    # The PDF structure every written file must have: the header, an xref table where startxref points, and %%EOF.
    $script:assertPdf = {
        param([string] $file)
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $bytes.Length | Should -BeGreaterThan 0
        $pdf = [System.Text.Encoding]::Latin1.GetString($bytes)
        $pdf.StartsWith("%PDF-1.4`n") | Should -BeTrue
        $tail = [regex]::Match($pdf, "startxref`n(\d+)`n%%EOF`n$")
        $tail.Success | Should -BeTrue
        $pdf.Substring([int]$tail.Groups[1].Value, 5) | Should -Be "xref`n"
    }
}

Describe 'Export-WorldMapPdf' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:placement = { param([string] $path, [string] $track, [string] $language) [Catzc.Base.Maps.MapPlacement]::new($path, $track, $language, $true, $false, 'none', $null, @()) }
        $script:map = [Catzc.Base.Maps.WorldMap]::new(@('widgets', 'gadgets'), @('widget-script'),
            @((& $script:placement 'widgets/a.ps1' 'widgets' 'widget-script'), (& $script:placement 'gadgets/b.ps1' 'gadgets' 'widget-script')), $null)
        $script:maps = [Catzc.Base.Maps.MapsConfig]::new([ordered]@{})
        $script:lit = [Catzc.Base.Maps.WorldMapHighlight]::ForPaths($script:map, @('widgets/a.ps1'))
    }

    BeforeEach {
        $script:folder = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -Path $script:folder -ItemType Directory
        Mock Get-WorldMap -ModuleName Catzc.Base.Maps { $script:map }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } { $script:maps }
        Mock Get-WorldMapOutputRoot -ModuleName Catzc.Base.Maps { $script:folder }
        Mock Get-WorldMapHighlight -ModuleName Catzc.Base.Maps { $script:lit }
    }

    It 'writes the grid and the tree, one file each, and returns their paths grid first' {
        $paths = @(Export-WorldMapPdf)
        $paths | Should -Be @((Join-Path $script:folder 'world-map.grid.pdf'), (Join-Path $script:folder 'world-map.tree.pdf'))
        foreach ($path in $paths) {
            & $script:assertPdf $path
        }
        Should -Invoke Get-WorldMapHighlight -ModuleName Catzc.Base.Maps -Times 0 -Exactly
        Should -Invoke Get-WorldMapOutputRoot -ModuleName Catzc.Base.Maps -ParameterFilter { $EnsureExists }
    }

    It 'writes only the requested view' {
        @(Export-WorldMapPdf -View Tree) | Should -Be @((Join-Path $script:folder 'world-map.tree.pdf'))
        Test-Path (Join-Path $script:folder 'world-map.grid.pdf') | Should -BeFalse
    }

    It 'writes a highlight beside the plain map, and passes -Adr or -Path on' {
        @(Export-WorldMapPdf -View Grid -Adr 'ADR-WIDGET-GADGET#3') | Should -Be @((Join-Path $script:folder 'world-map.grid.highlight.pdf'))
        Should -Invoke Get-WorldMapHighlight -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { $Adr -eq 'ADR-WIDGET-GADGET#3' }
        @(Export-WorldMapPdf -View Grid -Path 'widgets/a.ps1') | Should -Be @((Join-Path $script:folder 'world-map.grid.highlight.pdf'))
        Should -Invoke Get-WorldMapHighlight -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { $Path -eq 'widgets/a.ps1' }
        [System.Text.Encoding]::Latin1.GetString([System.IO.File]::ReadAllBytes((Join-Path $script:folder 'world-map.grid.highlight.pdf'))) |
            Should -BeLike '*Lit cell: widgets/a.ps1*'
    }

    It 'writes the same bytes on two runs' {
        $first = [System.IO.File]::ReadAllBytes((Export-WorldMapPdf -View Grid | Select-Object -First 1))
        $second = [System.IO.File]::ReadAllBytes((Export-WorldMapPdf -View Grid | Select-Object -First 1))
        [Convert]::ToBase64String($second) | Should -Be ([Convert]::ToBase64String($first))
    }
}

Describe 'Export-WorldMapPdf — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeEach {
        $script:folder = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -Path $script:folder -ItemType Directory
        Mock Get-WorldMapOutputRoot -ModuleName Catzc.Base.Maps { $script:folder }
    }

    It 'writes non-empty grid and tree PDFs that parse' {
        $paths = @(Export-WorldMapPdf)
        $paths.Count | Should -Be 2
        foreach ($path in $paths) {
            & $script:assertPdf $path
        }
    }
}
