# Tests for the PrePost starter (Catzc.Azure.Templates/assets/PrePost.psm1) — the copy-in template that
# authors clone into infrastructure/templates/<name>/PrePost.psm1. Production code does NOT load it;
# these tests import it explicitly to verify the starter is a working no-op baseline.

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
        # Null the parameter under test (supplying the others) so mandatory binding THROWS rather than
        # PROMPTS — omitting a mandatory param entirely hangs an interactive host waiting for input.
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
        # Pass DeploymentOutput explicitly as $null (rather than omitting it) so mandatory binding
        # throws instead of prompting for the missing value.
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
