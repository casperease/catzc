<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/types/PdfNumber.Tests.ps1
    kind: test
---
#>

Describe 'PdfNumber' -Tag 'L0', 'logic' {
    It 'writes at most three decimals, without trailing zeros' {
        [Catzc.Base.Maps.PdfNumber]::Format(12) | Should -Be '12'
        [Catzc.Base.Maps.PdfNumber]::Format(0.5) | Should -Be '0.5'
        [Catzc.Base.Maps.PdfNumber]::Format(1 / 3) | Should -Be '0.333'
        [Catzc.Base.Maps.PdfNumber]::Format(2.0625) | Should -Be '2.063'
        [Catzc.Base.Maps.PdfNumber]::Format(-7.25) | Should -Be '-7.25'
    }

    It 'writes no exponent and no negative zero' {
        [Catzc.Base.Maps.PdfNumber]::Format(1e-9) | Should -Be '0'
        [Catzc.Base.Maps.PdfNumber]::Format(-1e-9) | Should -Be '0'
        [Catzc.Base.Maps.PdfNumber]::Format(1e15) | Should -Be '1000000000000000'
    }

    It 'uses the invariant culture under a comma-decimal culture' {
        $saved = [cultureinfo]::CurrentCulture
        try {
            [cultureinfo]::CurrentCulture = [cultureinfo]::GetCultureInfo('da-DK')
            $text = [Catzc.Base.Maps.PdfNumber]::Format(1234.5)
        }
        finally {
            [cultureinfo]::CurrentCulture = $saved
        }
        $text | Should -Be '1234.5'
    }

    It 'rejects NaN and the infinities' {
        { [Catzc.Base.Maps.PdfNumber]::Format([double]::NaN) } | Should -Throw '*finite*'
        { [Catzc.Base.Maps.PdfNumber]::Format([double]::NegativeInfinity) } | Should -Throw '*finite*'
    }
}
