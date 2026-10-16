<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/tests/types/WinAnsi.Tests.ps1
    folder: tests/types
    name: win-ansi-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'WinAnsi' -Tag 'L0', 'logic' {
    It 'gives ASCII and Latin-1 characters their own code' {
        [Catzc.Base.Maps.WinAnsi]::CodeOf('W') | Should -Be 0x57
        [Catzc.Base.Maps.WinAnsi]::CodeOf(' ') | Should -Be 0x20
        [Catzc.Base.Maps.WinAnsi]::CodeOf('~') | Should -Be 0x7E
        [Catzc.Base.Maps.WinAnsi]::CodeOf([char]0x00D7) | Should -Be 0xD7
        [Catzc.Base.Maps.WinAnsi]::CodeOf([char]0x00A0) | Should -Be 0xA0
        [Catzc.Base.Maps.WinAnsi]::CodeOf([char]0x00FF) | Should -Be 0xFF
    }

    It 'gives the typographic characters their 0x80-0x9F code' {
        [Catzc.Base.Maps.WinAnsi]::CodeOf([char]0x20AC) | Should -Be 0x80
        [Catzc.Base.Maps.WinAnsi]::CodeOf([char]0x2013) | Should -Be 0x96
        [Catzc.Base.Maps.WinAnsi]::CodeOf([char]0x2014) | Should -Be 0x97
        [Catzc.Base.Maps.WinAnsi]::CodeOf([char]0x0178) | Should -Be 0x9F
    }

    It 'has no code for a control character, an undefined slot, or a character outside the set' {
        foreach ($code in @(0x0A, 0x09, 0x7F, 0x81, 0x9D, 0x2192, 0x2715, 0xD83D)) {
            [Catzc.Base.Maps.WinAnsi]::CodeOf([char]$code) | Should -Be -1 -Because ('U+{0:X4}' -f $code)
        }
    }

    It 'finds the first character without a code' {
        [Catzc.Base.Maps.WinAnsi]::IndexOfUnsupported("Widget $([char]0x00D7) gadget") | Should -Be -1
        [Catzc.Base.Maps.WinAnsi]::IndexOfUnsupported("Widget $([char]0x2192) gadget") | Should -Be 7
        [Catzc.Base.Maps.WinAnsi]::IndexOfUnsupported('') | Should -Be -1
        [Catzc.Base.Maps.WinAnsi]::IndexOfUnsupported($null) | Should -Be -1
    }

    It 'tells whether a whole text is encodable' {
        [Catzc.Base.Maps.WinAnsi]::IsEncodable("Widget $([char]0x2014) gadget") | Should -BeTrue
        [Catzc.Base.Maps.WinAnsi]::IsEncodable("Widget $([char]0x2192) gadget") | Should -BeFalse
    }
}
