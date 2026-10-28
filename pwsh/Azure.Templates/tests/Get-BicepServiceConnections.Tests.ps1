Describe 'Get-BicepServiceConnections' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:identities = [ordered]@{
            base = [ordered]@{ role = 'ba'; templates = @('widget'); azure_role = 'owner'; description = 'Deploys the widget.' }
            app  = [ordered]@{ role = 'ap'; templates = @('gadget'); azure_role = 'contributor'; description = 'Deploys the gadget.' }
            view = [ordered]@{ role = 'vw'; templates = @('widget', 'gadget'); azure_role = 'reader'; description = 'Previews both.' }
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'azure' } {
            @{
                org           = 'wco'
                environments  = @{ nsub = @{ shortcode = 'ns'; region_code = 'weu' }; psub = @{ shortcode = 'ps'; region_code = 'weu' } }
                subscriptions = [ordered]@{ widget_nonprod = @{}; widget_prod = @{}; gadget_nonprod = @{} }
            }
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'service-connections' } {
            [Catzc.Azure.Templates.ServiceConnectionsConfig]::new([ordered]@{ identities = $script:identities })
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'roles' } {
            @{ roles = @{ owner = @{}; contributor = @{}; reader = @{} } }
        }
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget', 'gadget' }
        # The widget has a slot in every subscription, the gadget only in widget_nonprod.
        Mock Get-BicepTemplates -ModuleName Catzc.Azure.Templates {
            [pscustomobject]@{ name = 'widget'; slots = @(
                    [pscustomobject]@{ subscription = 'widget_nonprod' }
                    [pscustomobject]@{ subscription = 'widget_prod' }
                    [pscustomobject]@{ subscription = 'gadget_nonprod' }
                )
            }
            [pscustomobject]@{ name = 'gadget'; slots = @([pscustomobject]@{ subscription = 'widget_nonprod' }) }
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
        Mock Get-AdoNaming -ModuleName Catzc.Azure.Templates { 'standard' }
    }

    It 'derives one connection per identity in each subscription that hosts a slot of its templates, in subscription then identity order' {
        $connections = @(Get-BicepServiceConnections)
        @($connections | ForEach-Object name) | Should -Be @(
            'nsub-weu-wco-ado-ba-sc', 'nsub-weu-wco-ado-ap-sc', 'nsub-weu-wco-ado-vw-sc'
            'psub-weu-wco-ado-ba-sc', 'psub-weu-wco-ado-vw-sc'
            'nsub-weu-wco-ado-gadget-ba-sc', 'nsub-weu-wco-ado-gadget-vw-sc'
        )
        $connections[0] | Should -BeOfType ([Catzc.Azure.Templates.BicepServiceConnection])
    }

    It 'carries the identity''s role, Azure role, templates and description onto each connection' {
        $app = Get-BicepServiceConnections | Where-Object identity -EQ 'app'
        $app.subscription | Should -BeExactly 'widget_nonprod'
        $app.role | Should -BeExactly 'ap'
        $app.azure_role | Should -BeExactly 'contributor'
        @($app.templates) | Should -Be @('gadget')
        $app.description | Should -BeExactly 'Deploys the gadget.'
    }

    It 'lists only the named subscriptions'' connections' {
        @(Get-BicepServiceConnections -Subscription widget_prod, gadget_nonprod | ForEach-Object subscription | Select-Object -Unique) |
            Should -Be @('widget_prod', 'gadget_nonprod')
        @(Get-BicepServiceConnections widget_prod | ForEach-Object identity) | Should -Be @('base', 'view')
    }

    It 'refuses a subscription azure.yml does not name' {
        { Get-BicepServiceConnections -Subscription sprocket_nonprod } | Should -Throw '*validation script*'
    }

    It 'refuses an identity whose Azure role roles.yml does not name' {
        $script:identities['base']['azure_role'] = 'sprocket_admin'
        { Get-BicepServiceConnections } | Should -Throw "*Identity 'base' holds azure_role 'sprocket_admin'*"
    }

    It 'refuses an identity that names a template that does not exist' {
        $script:identities['view']['templates'] = @('widget', 'sprocket')
        { Get-BicepServiceConnections } | Should -Throw "*Identity 'view' names template 'sprocket'*"
    }

    It 'refuses two subscriptions that derive one connection name' {
        Mock Get-AzureSubscriptionEnvironment -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Subscription { 'nsub' }
        Mock Get-AzureSubscription -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Subscription { [pscustomobject]@{ name = $Subscription; customer = $null } }
        { Get-BicepServiceConnections } | Should -Throw "*'nsub-weu-wco-ado-ba-sc' is derived twice*"
    }
}

Describe 'Get-BicepServiceConnections — shipped service-connections.yml' -Tag 'L1', 'integrity' {
    It 'connects each subscription''s landing zone and read-only previews, and its workload where expedition has a slot' {
        $connections = @(Get-BicepServiceConnections)
        $templates = Get-BicepTemplates
        $expedition = $templates | Where-Object name -EQ 'expedition'
        $expeditionHosts = @(foreach ($slot in $expedition.slots) {
                $slot.subscription
            })
        $connections | Should -Not -BeNullOrEmpty
        foreach ($subscription in (Get-Config -Config azure).subscriptions.Keys) {
            $identities = @($connections | Where-Object subscription -EQ $subscription | ForEach-Object identity)
            $identities | Should -Contain 'landing-zone' -Because "$subscription deploys its landing zone"
            $identities | Should -Contain 'read-only' -Because "$subscription previews its templates"
            ('workload' -in $identities) | Should -Be ($subscription -in $expeditionHosts) -Because "$subscription has a workload connection exactly when it hosts an expedition slot"
        }
    }
}
