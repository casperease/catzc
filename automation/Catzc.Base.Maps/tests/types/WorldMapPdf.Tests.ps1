<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/types/WorldMapPdf.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Maps
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

# cspell:ignore startxref
Describe 'WorldMapPdf' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:placement = {
            param([string] $path, [string] $track, [string] $language, [bool] $violation = $false)
            [Catzc.Base.Maps.MapPlacement]::new($path, $track, $language, $true, $violation, 'none', $null, @())
        }
        $script:newMap = {
            param([string[]] $tracks = @('widgets', 'gadgets'))
            $placements = @(
                & $script:placement 'widgets/a.ps1' 'widgets' 'widget-script'
                & $script:placement 'widgets/b.ps1' 'widgets' 'widget-script'
                & $script:placement 'widgets/c.ps1' 'widgets' 'widget-script'
                & $script:placement 'widgets/d.yml' 'widgets' 'gadget-config' $true
                & $script:placement 'gadgets/e.yml' 'gadgets' 'gadget-config'
                & $script:placement 'README' '(no track)' '(other)'
            )
            $all = @($tracks + @('widgets', 'gadgets') | Select-Object -Unique)
            [Catzc.Base.Maps.WorldMap]::new($all, @('widget-script', 'gadget-config'), $placements, $null)
        }
        $script:map = & $script:newMap
        $script:config = [Catzc.Base.Maps.MapsConfig]::new([ordered]@{})
        $script:highlight = [Catzc.Base.Maps.WorldMapHighlight]::ForPaths($script:map, @('gadgets/e.yml'))
        $script:lines = { param([Catzc.Base.Maps.PdfPage] $page) @($page.Content -split "`n" | Where-Object { $_ -ne '' }) }
        $script:fill = { param([string] $hex) [Catzc.Base.Maps.PdfPage]::new(1, 1).SetFillColor($hex).Content.Trim() }
        $script:stroke = { param([string] $hex) [Catzc.Base.Maps.PdfPage]::new(1, 1).SetStrokeColor($hex).Content.Trim() }
        $script:rect = {
            param([double] $x, [double] $y, [double] $w, [double] $h, [string] $op)
            '{0} {1} {2} {3} {4}' -f ([Catzc.Base.Maps.PdfNumber]::Format($x)), ([Catzc.Base.Maps.PdfNumber]::Format($y)),
            ([Catzc.Base.Maps.PdfNumber]::Format($w)), ([Catzc.Base.Maps.PdfNumber]::Format($h)), $op
        }
        $script:text = { param([byte[]] $bytes) [System.Text.Encoding]::Latin1.GetString($bytes) }
    }

    Context 'every page' {
        It 'starts with the full-page background fill in the palette''s background colour' {
            $doc = [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $script:config, $script:highlight, $true, $true)
            $doc.PageCount | Should -Be 2
            foreach ($page in $doc.Pages) {
                $lines = & $script:lines $page
                $lines[0] | Should -Be (& $script:fill ([Catzc.Base.Maps.MapsPalette]::DefaultBackground))
                $lines[1] | Should -Be (& $script:rect 0 0 842 595 're f')
            }
        }

        It 'takes the background from the config' {
            $config = [Catzc.Base.Maps.MapsConfig]::new([ordered]@{ palette = [ordered]@{ background = '#102030' } })
            $page = [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $config, $null, $false, $true).Pages[0]
            (& $script:lines $page)[0] | Should -Be (& $script:fill '#102030')
        }

        It 'writes the same bytes on two runs' {
            $one = [Catzc.Base.Maps.WorldMapPdf]::Render((& $script:newMap), $script:config, $script:highlight, $true, $true).ToBytes()
            $two = [Catzc.Base.Maps.WorldMapPdf]::Render((& $script:newMap), $script:config, $script:highlight, $true, $true).ToBytes()
            [Convert]::ToBase64String($two) | Should -Be ([Convert]::ToBase64String($one))
            $pdf = & $script:text $one
            $pdf.StartsWith('%PDF-1.4') | Should -BeTrue
            $pdf.EndsWith("%%EOF`n") | Should -BeTrue
        }

        It 'throws when no view is requested' {
            { [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $script:config, $null, $false, $false) } | Should -Throw '*no view requested*'
        }
    }

    Context 'the grid layout' {
        It 'places the headers and cells edge to edge inside the page margins, row 0 at the top' {
            $layout = [Catzc.Base.Maps.WorldMapGridLayout]::new($script:map, $script:config)
            $layout.Rows | Should -Be 3
            $layout.Columns | Should -Be 3
            $layout.Left | Should -Be ([Catzc.Base.Maps.WorldMapGridLayout]::Margin)
            $layout.CellLeft(0) | Should -Be ($layout.Left + $layout.RowHeaderWidth)
            ($layout.CellLeft(2) - $layout.CellLeft(1)) | Should -BeLessThan ($layout.CellWidth + 1e-9)
            ($layout.CellLeft(2) - $layout.CellLeft(1)) | Should -BeGreaterThan ($layout.CellWidth - 1e-9)
            $layout.CellBottom(0) | Should -Be ($layout.Top - $layout.ColumnHeaderHeight - $layout.CellHeight)
            ($layout.CellBottom(0) - $layout.CellBottom(1)) | Should -BeGreaterThan ($layout.CellHeight - 1e-9)
            $layout.Right | Should -BeLessOrEqual (842 - [Catzc.Base.Maps.WorldMapGridLayout]::Margin + 1e-9)
            $layout.Bottom | Should -BeGreaterOrEqual ($layout.LegendBottom + [Catzc.Base.Maps.WorldMapGridLayout]::LegendHeight)
            $layout.Top | Should -BeLessThan $layout.TitleBaseline
            $layout.CellHeight | Should -Be ([Catzc.Base.Maps.WorldMapGridLayout]::MaxCellHeight)
            { $layout.CellLeft(3) } | Should -Throw
            { $layout.CellBottom(-1) } | Should -Throw
        }

        It 'gives the column headers a band of the axis line over two name lines' {
            $layout = [Catzc.Base.Maps.WorldMapGridLayout]::new($script:map, $script:config)
            $size = [Catzc.Base.Maps.WorldMapGridLayout]::LabelSize
            $padding = [Catzc.Base.Maps.WorldMapGridLayout]::Padding
            $layout.ColumnHeaderHeight | Should -Be ($layout.ColumnAxisHeight + $layout.ColumnNameHeight)
            $layout.ColumnAxisHeight | Should -Be ($size + 2 * $padding)
            $layout.ColumnNameHeight | Should -BeGreaterOrEqual (([Catzc.Base.Maps.WorldMapGridLayout]::LineSpacing + 0.7) * $size + 2 * $padding)
        }

        It 'makes the row header as wide as its longest printed label' {
            $layout = [Catzc.Base.Maps.WorldMapGridLayout]::new($script:map, $script:config)
            $widest = [Catzc.Base.Maps.HelveticaMetrics]::Width('Helvetica', 8, 'Root files')
            $layout.RowHeaderWidth | Should -Be ($widest + 2 * [Catzc.Base.Maps.WorldMapGridLayout]::Padding)
        }

        It 'fills each cell at its layout position, shaded by its file count' {
            $layout = [Catzc.Base.Maps.WorldMapGridLayout]::new($script:map, $script:config)
            $content = [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $script:config, $null, $true, $false).Pages[0].Content
            $max = [Catzc.Base.Maps.WorldMapPdf]::ShadeOf(3, 3, $script:config.palette)
            $content | Should -BeLike "*$(& $script:fill $max)`n$(& $script:rect $layout.CellLeft(1) $layout.CellBottom(1) $layout.CellWidth $layout.CellHeight 're f')`n*"
        }
    }

    Context 'labels' {
        It 'prints the bucket row and column by their terms, never the bucket keys' {
            $content = [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $script:config, $null, $true, $false).Pages[0].Content
            $content | Should -BeLike '*(Root files) Tj*'
            $content | Should -BeLike '*(Unlisted files) Tj*'
            $content | Should -Not -BeLike '*(\(no track\)) Tj*'
            $content | Should -Not -BeLike '*(\(other\)) Tj*'
        }

        It 'cuts a label to its character limit with the marker' {
            [Catzc.Base.Maps.WorldMapPdf]::Truncate('gadget-widget', 7) | Should -Be "gadget$([char]0x2026)"
            [Catzc.Base.Maps.WorldMapPdf]::Truncate('widget', 6) | Should -Be 'widget'
            [Catzc.Base.Maps.WorldMapPdf]::Truncate('widget', 1) | Should -Be ([string][char]0x2026)
            { [Catzc.Base.Maps.WorldMapPdf]::Truncate('widget', 0) } | Should -Throw
        }

        It 'prints a track name past max_row_label cut, the same on every run' {
            $map = & $script:newMap @('sprocket-widget')
            $config = [Catzc.Base.Maps.MapsConfig]::new([ordered]@{ limits = [ordered]@{ max_row_label = 10 } })
            [Catzc.Base.Maps.WorldMapPdf]::RowLabel('sprocket-widget', $config) | Should -Be "sprocket-$([char]0x2026)"
            [Catzc.Base.Maps.WorldMapPdf]::RowLabel('(no track)', $config) | Should -Be 'Root files'
            $content = [Catzc.Base.Maps.WorldMapPdf]::Render($map, $config, $null, $true, $false).Pages[0].Content
            $content | Should -BeLike '*(sprocket-\205) Tj*'
        }

        It 'shrinks a label that is too wide, and cuts it at the smallest size' {
            $size = 0.0
            [Catzc.Base.Maps.WorldMapPdf]::Fit('widget', 'Helvetica', 8, 6, 100, [ref] $size) | Should -Be 'widget'
            $size | Should -Be 8
            $wide = [Catzc.Base.Maps.HelveticaMetrics]::Width('Helvetica', 8, 'widget')
            [Catzc.Base.Maps.WorldMapPdf]::Fit('widget', 'Helvetica', 8, 6, $wide * 0.8, [ref] $size) | Should -Be 'widget'
            $size | Should -BeLessThan 8
            $size | Should -BeGreaterOrEqual 6
            $cut = [Catzc.Base.Maps.WorldMapPdf]::Fit('widget gadget sprocket', 'Helvetica', 8, 6, 30, [ref] $size)
            $cut | Should -BeLike "*$([char]0x2026)"
            $size | Should -Be 6
            [Catzc.Base.Maps.HelveticaMetrics]::Width('Helvetica', 6, $cut) | Should -BeLessOrEqual 30
            [Catzc.Base.Maps.WorldMapPdf]::Fit('widget gadget sprocket', 'Helvetica', 8, 6, 30, [ref] $size) | Should -Be $cut
            [Catzc.Base.Maps.WorldMapPdf]::Fit('widget', 'Helvetica', 8, 6, 1, [ref] $size) | Should -Be ''
            $size | Should -Be 0
            $marker = [Catzc.Base.Maps.HelveticaMetrics]::Width('Helvetica', 6, [string][char]0x2026)
            [Catzc.Base.Maps.WorldMapPdf]::Fit('widget', 'Helvetica', 8, 6, $marker + 0.5, [ref] $size) | Should -Be ''
            [Catzc.Base.Maps.WorldMapPdf]::Fit('widget', 'Helvetica', 8, 6, $marker + 5, [ref] $size) | Should -Be "w$([char]0x2026)"
        }

        It 'keeps a header that fits on one line' {
            $size = 0.0
            $lines = [Catzc.Base.Maps.WorldMapPdf]::FitLines('widget gadget', 'Helvetica', 8, 6, 100, [ref] $size)
            $lines | Should -Be @('widget gadget')
            $size | Should -Be 8
        }

        It 'wraps a header at a space (dropped) or after a hyphen (kept) before it shrinks' {
            $size = 0.0
            [Catzc.Base.Maps.WorldMapPdf]::FitLines('widget gadget', 'Helvetica', 8, 6, 30, [ref] $size) | Should -Be @('widget', 'gadget')
            $size | Should -Be 8
            [Catzc.Base.Maps.WorldMapPdf]::FitLines('widget-gadget', 'Helvetica', 8, 6, 30, [ref] $size) | Should -Be @('widget-', 'gadget')
            $size | Should -Be 8
        }

        It 'wraps at the break that leaves the wider line narrowest' {
            $size = 0.0
            [Catzc.Base.Maps.WorldMapPdf]::FitLines('widget gadget sprocket', 'Helvetica', 8, 6, 50, [ref] $size) | Should -Be @('widget gadget', 'sprocket')
            $size | Should -Be 8
        }

        It 'shrinks the wrapped header when its lines are too wide, then cuts each line at the smallest size' {
            $size = 0.0
            [Catzc.Base.Maps.WorldMapPdf]::FitLines('widget-gadget', 'Helvetica', 8, 5, 20, [ref] $size) | Should -Be @('widget-', 'gadget')
            $size | Should -BeLessThan 8
            $size | Should -BeGreaterOrEqual 5
            [Catzc.Base.Maps.HelveticaMetrics]::Width('Helvetica', $size, 'widget-') | Should -BeLessOrEqual 20
            $cut = [Catzc.Base.Maps.WorldMapPdf]::FitLines('widget-gadget', 'Helvetica', 8, 6, 15, [ref] $size)
            $size | Should -Be 6
            $cut.Count | Should -Be 2
            foreach ($line in $cut) {
                $line | Should -BeLike "*$([char]0x2026)"
                [Catzc.Base.Maps.HelveticaMetrics]::Width('Helvetica', 6, $line) | Should -BeLessOrEqual 15
            }
        }

        It 'fits a header with no break on one line, and leaves out one that does not fit' {
            $size = 0.0
            $fit = 0.0
            $one = [Catzc.Base.Maps.WorldMapPdf]::FitLines('sprockets', 'Helvetica', 8, 6, 30, [ref] $size)
            $one | Should -Be @([Catzc.Base.Maps.WorldMapPdf]::Fit('sprockets', 'Helvetica', 8, 6, 30, [ref] $fit))
            $size | Should -Be $fit
            $size | Should -BeLessThan 8
            @([Catzc.Base.Maps.WorldMapPdf]::FitLines('widget gadget', 'Helvetica', 8, 6, 1, [ref] $size)).Count | Should -Be 0
            $size | Should -Be 0
        }

        It 'prints a narrow column''s header on two lines, the first above the second' {
            $config = [Catzc.Base.Maps.MapsConfig]::new([ordered]@{ limits = [ordered]@{ page_width = 240 } })
            $content = [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $config, $null, $true, $false).Pages[0].Content
            $content | Should -Not -BeLike '*(Unlisted files) Tj*'
            $content | Should -BeLike '*(widget-) Tj*'
            $first = [regex]::Match($content, '([\d.]+) Td \(Unlisted\) Tj')
            $second = [regex]::Match($content, '([\d.]+) Td \(files\) Tj')
            $first.Success | Should -BeTrue
            $second.Success | Should -BeTrue
            [double] $first.Groups[1].Value | Should -BeGreaterThan ([double] $second.Groups[1].Value)
        }
    }

    Context 'marks and the highlight' {
        It 'marks the stack-violation cell in the violation colour' {
            $layout = [Catzc.Base.Maps.WorldMapGridLayout]::new($script:map, $script:config)
            $content = [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $script:config, $null, $true, $false).Pages[0].Content
            $border = & $script:rect ($layout.CellLeft(0) + 0.75) ($layout.CellBottom(1) + 0.75) ($layout.CellWidth - 1.5) ($layout.CellHeight - 1.5) 're S'
            $content | Should -BeLike "*$(& $script:stroke ([Catzc.Base.Maps.MapsPalette]::DefaultViolation))`n1.5 w`n$border`n*"
        }

        It 'outlines each lit cell in the highlight colour, on both pages' {
            $layout = [Catzc.Base.Maps.WorldMapGridLayout]::new($script:map, $script:config)
            $doc = [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $script:config, $script:highlight, $true, $true)
            $outline = & $script:rect ($layout.CellLeft(0) + 1.25) ($layout.CellBottom(0) + 1.25) ($layout.CellWidth - 2.5) ($layout.CellHeight - 2.5) 're S'
            $highlightStroke = & $script:stroke ([Catzc.Base.Maps.MapsPalette]::DefaultHighlight)
            $doc.Pages[0].Content | Should -BeLike "*$highlightStroke`n2.5 w`n$outline`n*"
            $doc.Pages[1].Content | Should -BeLike "*$highlightStroke`n2.5 w`n*"
        }

        It 'draws no outline without a highlight' {
            $doc = [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $script:config, $null, $true, $true)
            $highlightStroke = & $script:stroke ([Catzc.Base.Maps.MapsPalette]::DefaultHighlight)
            foreach ($page in $doc.Pages) {
                $page.Content | Should -Not -BeLike "*$highlightStroke*"
            }
        }

        It 'throws on a highlight cell the map does not have' {
            $cell = [Catzc.Base.Maps.HighlightedCell]::new('sprockets', 'widget-script', @(), @('path'))
            $stray = [Catzc.Base.Maps.WorldMapHighlight]::new('path', @(), @($cell))
            { [Catzc.Base.Maps.WorldMapPdf]::Render($script:map, $script:config, $stray, $true, $false) } | Should -Throw "*'sprockets' x 'widget-script'*"
        }
    }

    Context 'shading' {
        It 'runs from the cell colour (empty) to the shade colour (fullest)' {
            $palette = $script:config.palette
            [Catzc.Base.Maps.WorldMapPdf]::ShadeOf(0, 10, $palette) | Should -Be $palette.cell
            [Catzc.Base.Maps.WorldMapPdf]::ShadeOf(10, 10, $palette) | Should -Be $palette.shade
            [Catzc.Base.Maps.WorldMapPdf]::Mix('#000000', '#FFFFFF', 0.5) | Should -Be '#808080'
            [Catzc.Base.Maps.WorldMapPdf]::Mix('#102030', '#102030', 0.3) | Should -Be '#102030'
        }
    }
}
