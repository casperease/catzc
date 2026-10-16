<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.DevOps/tests/Invoke-AdoRestMethod.Tests.ps1
    folder: tests
    name: invoke-ado-rest-method-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
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
