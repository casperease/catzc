Describe 'Assert-AzCliCanAccess' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate from the shipped azure.yml: resolve identity from the test config fixture.
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Cli/tests/assets/config/$Config.yml"
            }
        }
        $script:sub = Get-AzureSubscription core_lower
        $script:subId = $script:sub.id
    }

    It 'resolves the subscription identity and delegates to Assert-AzCliSubscriptionAccessible' {
        Mock Assert-AzCliSubscriptionAccessible { } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliCanAccess core_lower } | Should -Not -Throw
        Should -Invoke Assert-AzCliSubscriptionAccessible -ModuleName Catzc.Azure.Cli -ParameterFilter {
            $SubscriptionId -eq $script:subId
        }
    }

    It 'checks the CUSTOMER subscription for a customer deploy' {
        $custSub = Get-AzureSubscription acme_lower
        $custSub.id | Should -Not -Be $script:subId   # genuinely a different subscription
        Mock Assert-AzCliSubscriptionAccessible { } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliCanAccess acme_lower } | Should -Not -Throw
        Should -Invoke Assert-AzCliSubscriptionAccessible -ModuleName Catzc.Azure.Cli -ParameterFilter {
            $SubscriptionId -eq $custSub.id
        }
    }

    It 'propagates the throw from the generic access check' {
        Mock Assert-AzCliSubscriptionAccessible { throw 'cannot access subscription' } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliCanAccess core_lower } | Should -Throw '*cannot access subscription*'
    }
}
