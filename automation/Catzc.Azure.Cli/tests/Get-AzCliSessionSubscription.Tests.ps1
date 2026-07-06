Describe 'Get-AzCliSessionSubscription' -Tag 'L0', 'logic' {
    # The session read is a whole-function boundary mock (ADR-PESTER:3); config discovery redirects to
    # the fixture identities, so nothing production is in play.
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Cli'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Cli/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'resolves the session subscription to its declared azure.yml identity' {
        # acme_lower's fixture GUID; the customer is normalized to its canonical key.
        Mock Get-CurrentAzSubscription -ModuleName Catzc.Azure.Cli {
            [pscustomobject]@{ Id = '00000000-0000-0000-0000-000000000005'; Name = 'live-acme-lower'; TenantId = '00000000-0000-0000-0000-000000000001' }
        }
        $session = Get-AzCliSessionSubscription
        $session.name | Should -Be 'acme_lower'
        $session.customer | Should -Be 'acme'
        $session.tenant.name | Should -Be 'fixtenant'
    }

    It 'resolves a non-customer subscription with an empty customer' {
        Mock Get-CurrentAzSubscription -ModuleName Catzc.Azure.Cli {
            [pscustomobject]@{ Id = '00000000-0000-0000-0000-000000000004'; Name = 'live-cross'; TenantId = '00000000-0000-0000-0000-000000000001' }
        }
        $session = Get-AzCliSessionSubscription
        $session.name | Should -Be 'cross_shared'
        $session.customer | Should -BeNullOrEmpty
    }

    It 'throws when the session subscription is not declared in azure.yml' {
        Mock Get-CurrentAzSubscription -ModuleName Catzc.Azure.Cli {
            [pscustomobject]@{ Id = '99999999-9999-9999-9999-999999999999'; Name = 'foreign'; TenantId = '00000000-0000-0000-0000-000000000001' }
        }
        { Get-AzCliSessionSubscription } | Should -Throw '*not declared in azure.yml*'
    }

    It 'propagates the no-active-context failure from the session read' {
        Mock Get-CurrentAzSubscription -ModuleName Catzc.Azure.Cli {
            throw 'No active Azure CLI subscription context.'
        }
        { Get-AzCliSessionSubscription } | Should -Throw '*No active Azure CLI subscription context*'
    }
}
