<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Test-IsGuidInRange.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.Asserts/Test-IsGuidInRange.ps1
---
#>

Describe 'Test-IsGuidInRange' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture GUIDs are built at runtime (not literals), so they need no managed-GUID registry entry.
        function script:New-FixtureGuid {
            param([string] $FirstGroup, [string] $LastGroup = '000000000000')
            "$FirstGroup-0000-0000-0000-$LastGroup"
        }
        $script:from = New-FixtureGuid '00000010'
        $script:to = New-FixtureGuid '00000020'
    }

    It 'returns $true inside the range' {
        Test-IsGuidInRange (New-FixtureGuid '00000015') -From $from -To $to | Should -BeTrue
    }

    It 'includes both ends' {
        Test-IsGuidInRange $from -From $from -To $to | Should -BeTrue
        Test-IsGuidInRange $to -From $from -To $to | Should -BeTrue
    }

    It 'returns $false below and above the range' {
        Test-IsGuidInRange (New-FixtureGuid '0000000f') -From $from -To $to | Should -BeFalse
        Test-IsGuidInRange (New-FixtureGuid '00000020' '000000000001') -From $from -To $to | Should -BeFalse
    }

    It 'orders by the GUID as written, group by group' {
        # 01000000 is after 00000001 as written, though its little-endian bytes (ToByteArray) start lower.
        $low = New-FixtureGuid '00000001'
        $high = New-FixtureGuid '01000000'
        Test-IsGuidInRange (New-FixtureGuid '00010000') -From $low -To $high | Should -BeTrue
        Test-IsGuidInRange (New-FixtureGuid '02000000') -From $low -To $high | Should -BeFalse
    }

    It 'accepts braces and upper case on every input' {
        Test-IsGuidInRange ('{' + (New-FixtureGuid '00000015') + '}') -From $from.ToUpperInvariant() -To $to | Should -BeTrue
    }

    It 'compares case-insensitively' {
        Test-IsGuidInRange (New-FixtureGuid '0000001A') -From $from -To $to | Should -BeTrue
    }

    It 'throws on a reversed range' {
        { Test-IsGuidInRange $from -From $to -To $from } | Should -Throw '*reversed*'
    }

    It 'throws on a value that is not a GUID' {
        { Test-IsGuidInRange 'not-a-guid' -From $from -To $to } | Should -Throw '*not a valid GUID*'
    }
}
