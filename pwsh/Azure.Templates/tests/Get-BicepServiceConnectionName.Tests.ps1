Describe 'Get-BicepServiceConnectionName' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'azure' } {
            @{
                org           = 'wco'
                environments  = @{ nsub = @{ shortcode = 'ns'; region_code = 'weu' }; psub = @{ shortcode = 'ps'; region_code = 'neu' } }
                subscriptions = [ordered]@{ widget_nonprod = @{}; widget_prod = @{}; gadget_nonprod = @{} }
            }
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'service-connections' } {
            [Catzc.Azure.Templates.ServiceConnectionsConfig]::new([ordered]@{
                    identities = [ordered]@{
                        base = [ordered]@{ role = 'ba'; templates = @('widget'); azure_role = 'owner'; description = 'Deploys the widget.' }
                        view = [ordered]@{ role = 'vw'; templates = @('widget'); azure_role = 'reader'; description = 'Previews the widget.' }
                    }
                })
        }
        Mock Get-AzureSubscriptionEnvironment -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Subscription {
            if ($Subscription -like '*_prod') {
                'psub'
            }
            else {
                'nsub'
            }
        }
        Mock Get-AzureSubscription -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Subscription {
            [pscustomobject]@{ name = $Subscription; customer = $(if ($Subscription -like 'gadget_*') {
                        'gadget'
                    }
                    else {
                        $null
                    })
            }
        }
        Mock Get-Naming -ModuleName Catzc.Azure.Templates { 'standard' }
    }

    It 'names <subscription>''s <identity> connection <expected>' -ForEach @(
        @{ subscription = 'widget_nonprod'; identity = 'base'; expected = 'nsub-weu-wco-ado-ba-sc' }
        @{ subscription = 'widget_prod'; identity = 'view'; expected = 'psub-neu-wco-ado-vw-sc' }
        @{ subscription = 'gadget_nonprod'; identity = 'base'; expected = 'nsub-weu-wco-ado-gadget-ba-sc' }
    ) {
        Get-BicepServiceConnectionName -Subscription $subscription -Identity $identity | Should -BeExactly $expected
    }

    It 'takes the subscription and the identity by position, and follows the name order' {
        Mock Get-Naming -ModuleName Catzc.Azure.Templates { 'classic' }
        Get-BicepServiceConnectionName gadget_nonprod view | Should -BeExactly 'sc-wco-ado-gadget-nsub-weu-vw'
    }

    It 'refuses <case>' -ForEach @(
        @{ case = 'a subscription azure.yml does not name'; arguments = @{ Subscription = 'sprocket_nonprod'; Identity = 'base' } }
        @{ case = 'an identity service-connections.yml does not name'; arguments = @{ Subscription = 'widget_nonprod'; Identity = 'sprocket' } }
    ) {
        { Get-BicepServiceConnectionName @arguments } | Should -Throw '*validation script*'
    }
}
