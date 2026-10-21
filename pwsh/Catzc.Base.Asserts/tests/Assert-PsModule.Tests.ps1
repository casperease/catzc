<#
---
catzc:
  immutable:
    with_body_sha: "89b3af1f441e"
  edges:
    code: pwsh/Catzc.Base.Asserts/Assert-PsModule.ps1
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
