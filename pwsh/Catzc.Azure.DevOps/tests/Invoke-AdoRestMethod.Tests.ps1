<#
---
catzc:
  immutable:
    with_body_sha: a9b128030d4d
  edges:
    code: pwsh/Catzc.Azure.DevOps/Invoke-AdoRestMethod.ps1
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
