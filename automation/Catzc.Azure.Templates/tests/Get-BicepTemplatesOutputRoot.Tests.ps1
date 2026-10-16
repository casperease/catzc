<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-BicepTemplatesOutputRoot.Tests.ps1
    folder: tests
    name: get-bicep-templates-output-root-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-BicepTemplatesOutputRoot' -Tag 'L0', 'logic' {
    It 'is the repository out folder' {
        Get-BicepTemplatesOutputRoot | Should -Be (Join-Path (Get-RepositoryRoot) 'out')
    }
}
