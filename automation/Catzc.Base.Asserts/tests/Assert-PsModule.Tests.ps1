<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-PsModule.Tests.ps1
    folder: tests
    name: assert-ps-module-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
---
#>

Describe 'Assert-PsModule' -Tag 'L0', 'logic' {
    It 'passes for an available module' {
        { Assert-PsModule 'Microsoft.PowerShell.Utility' } | Should -Not -Throw
    }

    It 'throws for a missing module' {
        { Assert-PsModule 'Not.A.Real.Module.XYZ' } | Should -Throw
    }
}
