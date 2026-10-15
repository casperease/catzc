<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-IsGuidInRange.Tests.ps1
    kind: pester-test
---
#>

Describe 'Assert-IsGuidInRange' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture GUIDs are built at runtime (not literals), so they need no managed-GUID registry entry.
        $script:from = '00000010-0000-0000-0000-' + '000000000000'
        $script:inside = '00000015-0000-0000-0000-' + '000000000000'
        $script:to = '00000020-0000-0000-0000-' + '000000000000'
    }

    It 'passes for a GUID inside the range' {
        { Assert-IsGuidInRange $inside -From $from -To $to } | Should -Not -Throw
    }

    It 'throws naming the range for a GUID outside it' {
        { Assert-IsGuidInRange $to -From $from -To $inside } | Should -Throw '*not in the GUID range*'
    }
}
