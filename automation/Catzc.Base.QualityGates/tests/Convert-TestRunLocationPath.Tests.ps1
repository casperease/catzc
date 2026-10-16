<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Convert-TestRunLocationPath.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Convert-TestRunLocationPath' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:snapshotLocation = [pscustomobject]@{ SourceRoot = 'C:\widget'; Root = 'C:\tmp\catzc-run-gadget' }
        $script:inPlaceLocation = [pscustomobject]@{ SourceRoot = 'C:\widget'; Root = 'C:\widget' }
        $script:convert = {
            param($Location, [string[]] $Path, [switch] $ToSource)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ L = $Location; P = $Path; T = [bool] $ToSource } {
                param($L, $P, $T)
                @(Convert-TestRunLocationPath -Location $L -Path $P -ToSource:$T)
            }
        }
    }

    It 'maps a path under the working folder into the snapshot, and back' {
        $inside = & $script:convert $script:snapshotLocation @('C:\widget\automation\Mod\tests\A.Tests.ps1')
        $inside | Should -Be @('C:\tmp\catzc-run-gadget\automation\Mod\tests\A.Tests.ps1')
        & $script:convert $script:snapshotLocation $inside -ToSource | Should -Be @('C:\widget\automation\Mod\tests\A.Tests.ps1')
    }

    It 'maps the root itself, case-insensitively and with either separator' {
        & $script:convert $script:snapshotLocation @('c:\WIDGET', 'C:\widget/automation') |
            Should -Be @('C:\tmp\catzc-run-gadget', 'C:\tmp\catzc-run-gadget/automation')
    }

    It 'passes through paths outside the root, sibling-prefix lookalikes, empty values, and every in-place path' {
        & $script:convert $script:snapshotLocation @('C:\temp\Fixture.Tests.ps1', 'C:\widgets\B.Tests.ps1', '') |
            Should -Be @('C:\temp\Fixture.Tests.ps1', 'C:\widgets\B.Tests.ps1', '')
        & $script:convert $script:inPlaceLocation @('C:\widget\A.Tests.ps1') | Should -Be @('C:\widget\A.Tests.ps1')
    }
}
