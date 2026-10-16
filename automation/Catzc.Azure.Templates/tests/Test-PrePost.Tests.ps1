<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/tests/Test-PrePost.Tests.ps1
    folder: tests
    name: test-pre-post-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-templates/tests/Test-PrePost.Tests.ps1.md
---
#>

BeforeAll {
    Import-Module (Join-Path $PSScriptRoot '../assets/PrePost.psm1') -Force
}

Describe 'Invoke-BicepPrepareParameterSet (starter no-op)' -Tag 'L0', 'logic' {
    It 'returns the same ConfigurationDescriptor it was given' {
        $config = [ordered]@{
            ResourceGroup  = 'rg-test'
            ParametersFile = [ordered]@{ parameters = [ordered]@{} }
        }
        $result = Invoke-BicepPrepareParameterSet `
            -BuildInvocation ([ordered]@{ Template = 'sample'; Environment = 'dev'; Slot = ''; Customer = '' }) `
            -TemplateDescriptor ([ordered]@{ name = 'sample' }) `
            -ConfigurationDescriptor $config

        [object]::ReferenceEquals($result, $config) | Should -BeTrue
    }

    It 'requires BuildInvocation, TemplateDescriptor, and ConfigurationDescriptor' {
        { Invoke-BicepPrepareParameterSet -BuildInvocation $null -TemplateDescriptor @{} -ConfigurationDescriptor @{} } | Should -Throw
        { Invoke-BicepPrepareParameterSet -BuildInvocation @{} -TemplateDescriptor $null -ConfigurationDescriptor @{} } | Should -Throw
        { Invoke-BicepPrepareParameterSet -BuildInvocation @{} -TemplateDescriptor @{} -ConfigurationDescriptor $null } | Should -Throw
    }
}

Describe 'Invoke-BicepPreDeploy (starter no-op)' -Tag 'L0', 'logic' {
    It 'runs without throwing given the four required params' {
        {
            Invoke-BicepPreDeploy `
                -DeployInvocation ([ordered]@{ Environment = 'dev'; Mode = 'Incremental'; DryRun = $false }) `
                -TemplateDescriptor ([ordered]@{ name = 'sample' }) `
                -ConfigurationDescriptor ([ordered]@{ ResourceGroup = 'rg' }) `
                -EnvironmentDescriptor ([ordered]@{ name = 'dev' })
        } | Should -Not -Throw
    }

    It 'requires DeployInvocation, TemplateDescriptor, ConfigurationDescriptor, and EnvironmentDescriptor' {
        { Invoke-BicepPreDeploy -DeployInvocation $null -TemplateDescriptor @{} -ConfigurationDescriptor @{} -EnvironmentDescriptor @{} } | Should -Throw
        { Invoke-BicepPreDeploy -DeployInvocation @{} -TemplateDescriptor $null -ConfigurationDescriptor @{} -EnvironmentDescriptor @{} } | Should -Throw
        { Invoke-BicepPreDeploy -DeployInvocation @{} -TemplateDescriptor @{} -ConfigurationDescriptor $null -EnvironmentDescriptor @{} } | Should -Throw
        { Invoke-BicepPreDeploy -DeployInvocation @{} -TemplateDescriptor @{} -ConfigurationDescriptor @{} -EnvironmentDescriptor $null } | Should -Throw
    }
}

Describe 'Invoke-BicepPostDeploy (starter no-op)' -Tag 'L0', 'logic' {
    It 'runs without throwing given the five required params' {
        {
            Invoke-BicepPostDeploy `
                -DeployInvocation ([ordered]@{ Environment = 'dev'; Mode = 'Incremental'; DryRun = $false }) `
                -TemplateDescriptor ([ordered]@{ name = 'sample' }) `
                -ConfigurationDescriptor ([ordered]@{ ResourceGroup = 'rg' }) `
                -EnvironmentDescriptor ([ordered]@{ name = 'dev' }) `
                -DeploymentOutput ([ordered]@{ properties = [ordered]@{ provisioningState = 'Succeeded' } })
        } | Should -Not -Throw
    }

    It 'requires DeploymentOutput' {
        {
            Invoke-BicepPostDeploy `
                -DeployInvocation ([ordered]@{}) `
                -TemplateDescriptor ([ordered]@{}) `
                -ConfigurationDescriptor ([ordered]@{}) `
                -EnvironmentDescriptor ([ordered]@{}) `
                -DeploymentOutput $null
        } | Should -Throw
    }
}
