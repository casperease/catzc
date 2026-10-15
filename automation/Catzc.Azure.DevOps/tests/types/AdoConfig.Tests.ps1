<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/tests/types/AdoConfig.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Azure.DevOps/types/AdoConfig.cs
---
#>

Describe 'AdoConfig' -Tag 'L0' {
    BeforeAll {
        $script:baseConfig = @{
            organization = 'https://dev.azure.com/example-org'
            project      = 'My%20Project'
            tenant       = 'fa0e0000-7e0a-0700-1d00-000000000000'
        }
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Azure.DevOps.AdoConfig]::new($raw) }
    }

    It 'passes for the shipped ado.yml' -Tag 'integrity' {
        Get-Config -Config ado | Should -BeOfType [Catzc.Azure.DevOps.AdoConfig]
    }

    It 'passes for a minimal valid config' -Tag 'logic' {
        $config = & $script:make (Copy-Object $baseConfig)
        $config.organization | Should -Be 'https://dev.azure.com/example-org'
        $config['project'] | Should -Be 'My%20Project'
        $config.tenant | Should -Be 'fa0e0000-7e0a-0700-1d00-000000000000'
    }

    It 'throws when a required key is missing' -Tag 'logic' {
        $bad = @{ organization = 'https://dev.azure.com/x' }
        { & $script:make $bad } | Should -Throw '*Missing required*'
    }

    It 'throws when a key is not snake_case' -Tag 'logic' {
        $bad = [ordered]@{ Organization = 'https://dev.azure.com/x'; project = 'p'; tenant = 'fa0e0000-7e0a-0700-1d00-000000000000' }
        { & $script:make $bad } | Should -Throw '*snake_case*'
    }

    It 'throws when organization is not an https URL' -Tag 'logic' {
        $bad = Copy-Object $baseConfig
        $bad.organization = 'dev.azure.com/x'
        { & $script:make $bad } | Should -Throw '*organization*'
    }

    It 'throws when project is empty' -Tag 'logic' {
        $bad = Copy-Object $baseConfig
        $bad.project = ''
        { & $script:make $bad } | Should -Throw '*project*'
    }

    It 'throws when tenant is not a GUID' -Tag 'logic' {
        $bad = Copy-Object $baseConfig
        $bad.tenant = 'not-a-guid'
        { & $script:make $bad } | Should -Throw '*tenant*'
    }

    It 'throws when tenant is omitted (it is the correctness spec — required)' -Tag 'logic' {
        $configuration = Copy-Object $baseConfig
        $configuration.Remove('tenant')
        { & $script:make $configuration } | Should -Throw '*Missing required*tenant*'
    }

    It 'reports every violation in one throw' -Tag 'logic' {
        $bad = [ordered]@{ organization = 'dev.azure.com/x'; project = ''; tenant = 'not-a-guid'; colour = 'blue' }
        $err = { & $script:make $bad } | Should -Throw -PassThru
        foreach ($expected in "*unknown key 'colour'*", '*organization*invalid*', '*project is empty*', '*tenant*invalid*') {
            $err.Exception.Message | Should -BeLike $expected
        }
    }
}
