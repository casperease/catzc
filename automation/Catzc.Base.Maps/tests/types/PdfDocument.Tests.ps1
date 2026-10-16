<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/types/PdfDocument.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Maps
    relatives:
      source: automation/Catzc.Base.Maps/types/PdfDocument.cs
---
#>

# cspell:ignore startxref nstartxref nstream endstream  -- PDF keywords, some behind a "`n" escape
Describe 'PdfDocument' -Tag 'L0', 'logic' {
    BeforeAll {
        # One byte per character, so a string index is a byte offset.
        $script:text = { param([byte[]] $bytes) [System.Text.Encoding]::Latin1.GetString($bytes) }
        $script:sample = {
            param([string] $label = 'Widget (gadget) \ sprocket')
            $doc = [Catzc.Base.Maps.PdfDocument]::new()
            $page = $doc.AddPage(842, 595)
            $null = $page.SetFillColor('#336699').FillRect(10, 20, 100.5, 40.25)
            $null = $page.SetStrokeColor(0, 0, 0).SetLineWidth(0.5).StrokeRect(10, 20, 100.5, 40.25)
            $null = $page.Line(0, 0, 842, 595)
            $null = $page.Text([Catzc.Base.Maps.PdfFont]::HelveticaBold, 12, 30, 560, $label)
            $second = $doc.AddPage(595, 842)
            $null = $second.Text([Catzc.Base.Maps.PdfFont]::Helvetica, 9, 40, 40, "Gadget $([char]0x00D7) widget")
            $doc
        }
    }

    It 'starts with the PDF 1.4 header and ends with %%EOF' {
        $pdf = & $script:text (& $script:sample).ToBytes()
        $pdf.StartsWith("%PDF-1.4`n") | Should -BeTrue
        $pdf.EndsWith("`n%%EOF`n") | Should -BeTrue
    }

    It 'points every xref offset at its object, and startxref at the xref table' {
        $pdf = & $script:text (& $script:sample).ToBytes()
        $tail = [regex]::Match($pdf, "startxref`n(\d+)`n%%EOF`n$")
        $tail.Success | Should -BeTrue
        $xref = [int]$tail.Groups[1].Value
        $pdf.Substring($xref, 5) | Should -Be "xref`n"
        $head = [regex]::Match($pdf.Substring($xref), "^xref`n0 (\d+)`n")
        $size = [int]$head.Groups[1].Value
        $size | Should -Be 9
        $entries = $pdf.Substring($xref + $head.Length, 20 * $size)
        $entries.Substring(0, 20) | Should -Be "0000000000 65535 f `n"
        for ($n = 1; $n -lt $size; $n++) {
            $entry = $entries.Substring(20 * $n, 20)
            $entry | Should -Match '^\d{10} 00000 n \n$'
            $offset = [long]$entry.Substring(0, 10)
            $pdf.Substring($offset, "$n 0 obj`n".Length) | Should -Be "$n 0 obj`n" -Because "object $n sits at offset $offset"
        }
        $pdf | Should -Match "trailer`n<< /Size $size /Root 1 0 R /ID \[<[0-9A-F]{32}> <[0-9A-F]{32}>\] >>`nstartxref"
    }

    It 'gives each content stream its exact /Length' {
        $pdf = & $script:text (& $script:sample).ToBytes()
        $streams = [regex]::Matches($pdf, "<< /Length (\d+) >>`nstream`n")
        $streams.Count | Should -Be 2
        foreach ($m in $streams) {
            $start = $m.Index + $m.Length
            $pdf.Substring($start + [int]$m.Groups[1].Value, 10) | Should -Be "endstream`n"
        }
    }

    It 'counts the pages in /Count and lists them in /Kids' {
        $doc = & $script:sample
        $doc.PageCount | Should -Be 2
        & $script:text $doc.ToBytes() | Should -Match '/Type /Pages /Kids \[5 0 R 7 0 R\] /Count 2 >>'
    }

    It 'writes the same bytes on two runs' {
        $first = (& $script:sample).ToBytes()
        $second = (& $script:sample).ToBytes()
        [Convert]::ToHexString($second) | Should -Be ([Convert]::ToHexString($first))
    }

    It 'derives a different /ID from different content' {
        $id = { param($doc) [regex]::Match((& $script:text $doc.ToBytes()), '/ID \[<([0-9A-F]{32})>').Groups[1].Value }
        $widget = & $id (& $script:sample 'Widget')
        $gadget = & $id (& $script:sample 'Gadget')
        $widget | Should -Not -BeNullOrEmpty
        $gadget | Should -Not -Be $widget
    }

    It 'writes no creation or modification date' {
        & $script:text (& $script:sample).ToBytes() | Should -Not -Match 'CreationDate|ModDate'
    }

    It 'names both base-14 fonts with WinAnsiEncoding' {
        $pdf = & $script:text (& $script:sample).ToBytes()
        $pdf | Should -Match '/BaseFont /Helvetica /Encoding /WinAnsiEncoding'
        $pdf | Should -Match '/BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding'
        $pdf | Should -Match '/Resources << /Font << /F1 3 0 R /F2 4 0 R >> >>'
    }

    It 'writes invariant numbers under a comma-decimal culture' {
        $saved = [cultureinfo]::CurrentCulture
        try {
            [cultureinfo]::CurrentCulture = [cultureinfo]::GetCultureInfo('da-DK')
            (1.5).ToString() | Should -Be '1,5' -Because 'the test culture uses a comma'
            $pdf = & $script:text (& $script:sample).ToBytes()
        }
        finally {
            [cultureinfo]::CurrentCulture = $saved
        }
        $pdf | Should -Match "`n10 20 100\.5 40\.25 re f`n"
        $pdf | Should -Match "`n0\.5 w`n"
        $pdf | Should -Not -Match '\d,\d'
    }

    It 'throws on a document with no page' {
        { [Catzc.Base.Maps.PdfDocument]::new().ToBytes() } | Should -Throw '*at least one page*'
    }

    It 'renders through ConsoleText' {
        "$(& $script:sample)" | Should -Be 'PdfDocument { PageCount = 2 }'
    }

    It 'writes a sample file that a reader can open' {
        $path = Join-Path $TestDrive 'widget.pdf'
        [System.IO.File]::WriteAllBytes($path, (& $script:sample).ToBytes())
        (Get-Item -LiteralPath $path).Length | Should -BeGreaterThan 0
    }
}
