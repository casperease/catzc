<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/tests/types/PdfPage.Tests.ps1
    folder: tests/types
    name: pdf-page-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'PdfPage' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:page = { [Catzc.Base.Maps.PdfPage]::new(200, 100) }
    }

    It 'writes one operator line per drawing call' {
        $page = & $script:page
        $null = $page.SetFillColor(1, 0.5, 0).FillRect(1, 2, 3, 4)
        $null = $page.SetStrokeColor('#FF0000').SetLineWidth(2).StrokeRect(1, 2, 3, 4)
        $null = $page.Line(0, 0, 10, 20)
        $null = $page.Text([Catzc.Base.Maps.PdfFont]::Helvetica, 8, 5, 6, 'Widget')
        $page.OperationCount | Should -Be 7
        $page.Content | Should -Be (@(
                '1 0.5 0 rg'
                '1 2 3 4 re f'
                '1 0 0 RG'
                '2 w'
                '1 2 3 4 re S'
                '0 0 m 10 20 l S'
                'BT /F1 8 Tf 5 6 Td (Widget) Tj ET'
                ''
            ) -join "`n")
    }

    It 'turns a hex colour into 0-1 components' {
        $page = & $script:page
        $null = $page.SetFillColor('#336699')
        $page.Content | Should -Be "0.2 0.4 0.6 rg`n"
    }

    It 'names Helvetica /F1 and Helvetica-Bold /F2' {
        [Catzc.Base.Maps.PdfPage]::FontName([Catzc.Base.Maps.PdfFont]::Helvetica) | Should -Be 'F1'
        [Catzc.Base.Maps.PdfPage]::FontName([Catzc.Base.Maps.PdfFont]::HelveticaBold) | Should -Be 'F2'
    }

    It 'escapes parentheses and backslashes' {
        [Catzc.Base.Maps.PdfPage]::Escape('widget (gadget) \ x') | Should -Be 'widget \(gadget\) \\ x'
    }

    It 'writes WinAnsi codes from 0x80 up as octal escapes' {
        [Catzc.Base.Maps.PdfPage]::Escape("a $([char]0x00D7) b") | Should -Be 'a \327 b'
        [Catzc.Base.Maps.PdfPage]::Escape("$([char]0x2014)") | Should -Be '\227'
        [Catzc.Base.Maps.PdfPage]::Escape("$([char]0x20AC)") | Should -Be '\200'
    }

    It 'rejects text outside WinAnsi, naming the code point and index' {
        $page = & $script:page
        { $page.Text([Catzc.Base.Maps.PdfFont]::Helvetica, 8, 0, 0, "Widget $([char]0x2192) gadget") } |
            Should -Throw '*U+2192 at index 7*WinAnsi*'
        $page.OperationCount | Should -Be 0
    }

    It 'rejects a bad page size, colour, line width and font size' {
        { [Catzc.Base.Maps.PdfPage]::new(0, 100) } | Should -Throw '*page side*'
        { [Catzc.Base.Maps.PdfPage]::new(100, 14401) } | Should -Throw '*page side*'
        { [Catzc.Base.Maps.PdfPage]::new([double]::NaN, 100) } | Should -Throw '*page side*'
        $page = & $script:page
        { $page.SetFillColor(1.5, 0, 0) } | Should -Throw '*0 to 1*'
        { $page.SetStrokeColor('#12345') } | Should -Throw '*six hex digits*'
        { $page.SetStrokeColor('#GGGGGG') } | Should -Throw '*six hex digits*'
        { $page.SetLineWidth(-1) } | Should -Throw '*zero or more*'
        { $page.Text([Catzc.Base.Maps.PdfFont]::Helvetica, 0, 0, 0, 'Widget') } | Should -Throw '*more than zero*'
        { $page.FillRect([double]::PositiveInfinity, 0, 1, 1) } | Should -Throw '*finite*'
    }

    It 'renders through ConsoleText' {
        "$(& $script:page)" | Should -Be 'PdfPage { Width = 200, Height = 100, OperationCount = 0 }'
    }
}
