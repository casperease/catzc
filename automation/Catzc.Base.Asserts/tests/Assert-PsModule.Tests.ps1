<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-PsModule.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    relatives:
      source: automation/Catzc.Base.Asserts/Assert-PsModule.ps1
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
