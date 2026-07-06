Describe 'Assert-AzCliIsConnected' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate from the shipped azure.yml: resolve identity from the test config fixture.
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Cli/tests/assets/config/$Config.yml"
            }
        }
        # The subscription/tenant the function resolves and forwards to the generic primitive.
        $script:sub = Get-AzureSubscription core_lower
        $script:subId = $script:sub.id
        $script:tenantId = $script:sub.tenant.id
    }

    It 'resolves the subscription identity and delegates to Get-AzCliConnectionState' {
        Mock Get-AzCliConnectionState { [ordered]@{ logged_in = $true; connected = $true } } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliIsConnected core_lower } | Should -Not -Throw
        Should -Invoke Get-AzCliConnectionState -ModuleName Catzc.Azure.Cli -ParameterFilter {
            $SubscriptionId -eq $script:subId -and $TenantId -eq $script:tenantId
        }
    }

    It 'checks the CUSTOMER subscription for a customer deploy' {
        $custSub = Get-AzureSubscription acme_lower
        $custSub.id | Should -Not -Be $script:subId   # genuinely a different subscription
        Mock Get-AzCliConnectionState { [ordered]@{ logged_in = $true; connected = $true } } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliIsConnected acme_lower } | Should -Not -Throw
        Should -Invoke Get-AzCliConnectionState -ModuleName Catzc.Azure.Cli -ParameterFilter {
            $SubscriptionId -eq $custSub.id
        }
    }

    It 'throws naming the wrong context with an az login hint when connected is false' {
        Mock Get-AzCliConnectionState {
            [ordered]@{
                logged_in = $true; connected = $false
                expected_tenant = $script:tenantId; expected_subscription = $script:subId
                actual_tenant = '00700000-70a7-50b0-0000-000000000000'; actual_subscription = $script:subId
            }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliIsConnected core_lower } | Should -Throw '*wrong context*az login*'
    }

    It 'throws with an az login hint when not logged in' {
        Mock Get-AzCliConnectionState {
            [ordered]@{
                logged_in = $false; connected = $false
                expected_tenant = $script:tenantId; expected_subscription = $script:subId
                actual_tenant = $null; actual_subscription = $null
            }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliIsConnected core_lower } | Should -Throw '*az login*'
    }
}
