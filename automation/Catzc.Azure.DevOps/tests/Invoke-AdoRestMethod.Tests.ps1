<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/tests/Invoke-AdoRestMethod.Tests.ps1
    kind: pester-test
---
#>

Describe 'Invoke-AdoRestMethod' -Tag 'L0', 'logic' {
    Context 'parameter validation' {
        It 'requires Uri parameter' {
            { Invoke-AdoRestMethod -Uri $null } | Should -Throw
        }

        It 'validates Method values' {
            { Invoke-AdoRestMethod -Uri 'https://example.com' -Method 'INVALID' } | Should -Throw
        }
    }
}
