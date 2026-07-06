Describe 'Assert-AdoConfig' -Tag 'L0' {
    BeforeAll {
        $script:baseConfig = @{
            organization = 'https://dev.azure.com/example-org'
            project      = 'My%20Project'
            tenant       = 'fa0e0000-7e0a-0700-1d00-000000000000'
        }
    }

    It 'passes for the shipped ado.yml' -Tag 'integrity' {
        $config = Get-Content (Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.DevOps/configs/ado.yml') -Raw | ConvertFrom-Yaml
        { & (Get-Module Catzc.Azure.DevOps) { Assert-AdoConfig $args[0] } $config } | Should -Not -Throw
    }

    It 'passes for a minimal valid config' -Tag 'logic' {
        { & (Get-Module Catzc.Azure.DevOps) { Assert-AdoConfig $args[0] } (Copy-Object $baseConfig) } | Should -Not -Throw
    }

    It 'throws when a required key is missing' -Tag 'logic' {
        $bad = @{ organization = 'https://dev.azure.com/x' }
        { & (Get-Module Catzc.Azure.DevOps) { Assert-AdoConfig $args[0] } $bad } | Should -Throw '*Missing required*'
    }

    It 'throws when a key is not snake_case' -Tag 'logic' {
        $bad = @{ Organization = 'https://dev.azure.com/x'; project = 'p'; tenant = 'fa0e0000-7e0a-0700-1d00-000000000000' }
        { & (Get-Module Catzc.Azure.DevOps) { Assert-AdoConfig $args[0] } $bad } | Should -Throw '*snake_case*'
    }

    It 'throws when organization is not an https URL' -Tag 'logic' {
        $bad = Copy-Object $baseConfig
        $bad.organization = 'dev.azure.com/x'
        { & (Get-Module Catzc.Azure.DevOps) { Assert-AdoConfig $args[0] } $bad } | Should -Throw '*organization*'
    }

    It 'throws when project is empty' -Tag 'logic' {
        $bad = Copy-Object $baseConfig
        $bad.project = ''
        { & (Get-Module Catzc.Azure.DevOps) { Assert-AdoConfig $args[0] } $bad } | Should -Throw '*project*'
    }

    It 'throws when tenant is not a GUID' -Tag 'logic' {
        $bad = Copy-Object $baseConfig
        $bad.tenant = 'not-a-guid'
        { & (Get-Module Catzc.Azure.DevOps) { Assert-AdoConfig $args[0] } $bad } | Should -Throw '*tenant*'
    }

    It 'throws when tenant is omitted (it is the correctness spec — required)' -Tag 'logic' {
        $configuration = Copy-Object $baseConfig
        $configuration.Remove('tenant')
        { & (Get-Module Catzc.Azure.DevOps) { Assert-AdoConfig $args[0] } $configuration } | Should -Throw '*Missing required*tenant*'
    }
}
