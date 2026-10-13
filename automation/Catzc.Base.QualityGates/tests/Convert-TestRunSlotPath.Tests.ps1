Describe 'Convert-TestRunSlotPath' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:snapshotSlot = [pscustomobject]@{ SourceRoot = 'C:\widget'; Root = 'C:\tmp\catzc-run-gadget' }
        $script:inPlaceSlot = [pscustomobject]@{ SourceRoot = 'C:\widget'; Root = 'C:\widget' }
        $script:convert = {
            param($Slot, [string[]] $Path, [switch] $ToSource)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ S = $Slot; P = $Path; T = [bool] $ToSource } {
                param($S, $P, $T)
                @(Convert-TestRunSlotPath -Slot $S -Path $P -ToSource:$T)
            }
        }
    }

    It 'maps a path under the working folder into the snapshot, and back' {
        $inside = & $script:convert $script:snapshotSlot @('C:\widget\automation\Mod\tests\A.Tests.ps1')
        $inside | Should -Be @('C:\tmp\catzc-run-gadget\automation\Mod\tests\A.Tests.ps1')
        & $script:convert $script:snapshotSlot $inside -ToSource | Should -Be @('C:\widget\automation\Mod\tests\A.Tests.ps1')
    }

    It 'maps the root itself, case-insensitively and with either separator' {
        & $script:convert $script:snapshotSlot @('c:\WIDGET', 'C:\widget/automation') |
            Should -Be @('C:\tmp\catzc-run-gadget', 'C:\tmp\catzc-run-gadget/automation')
    }

    It 'passes through paths outside the root, sibling-prefix lookalikes, empty values, and every in-place path' {
        & $script:convert $script:snapshotSlot @('C:\temp\Fixture.Tests.ps1', 'C:\widgets\B.Tests.ps1', '') |
            Should -Be @('C:\temp\Fixture.Tests.ps1', 'C:\widgets\B.Tests.ps1', '')
        & $script:convert $script:inPlaceSlot @('C:\widget\A.Tests.ps1') | Should -Be @('C:\widget\A.Tests.ps1')
    }
}
