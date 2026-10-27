Describe 'Resolve-BicepEnvironmentFacts' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:resolve = {
            param([System.Collections.IDictionary] $Facts, [string] $Environment, [string] $Subscription = 'widget_sub', [string] $Customer = '')
            $template = [Catzc.Azure.Templates.BicepTemplate]::new([ordered]@{
                    name = 'widget'; folder = 'f'; main = 'm'; configuration_folder = 'c'; output_folder = 'o'; deployment_mode = 'Incremental'
                    deployment_target = 'ResourceGroup'; environment_kind = 'environment'; short_name = 'wdg'; facts = $Facts
                })
            $slot = [Catzc.Azure.Templates.BicepSlot]::new($Environment, $Environment, '', $Subscription, $Customer, 'widget.yml')
            InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
                param($Template, $Slot)
                Resolve-BicepEnvironmentFacts -TemplateDescriptor $Template -Slot $Slot
            }
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'azure' } {
            $environments = [System.Collections.Generic.Dictionary[string, object]]::new()
            $environments['gadget'] = [pscustomobject]@{ production = $true }
            $environments['sprocket'] = [pscustomobject]@{ production = $false }
            $environments['cog'] = [pscustomobject]@{ production = $false }
            $subscriptions = [System.Collections.Generic.Dictionary[string, object]]::new()
            $subscriptions['widget_sub'] = [pscustomobject]@{ environments = @('sprocket', 'cog') }
            $subscriptions['gadget_sub'] = [pscustomobject]@{ environments = @('gadget', 'cog') }
            $enforcement = @{ production = 'Default'; nonproduction = 'DoNotEnforce' }
            $groups = [System.Collections.Generic.Dictionary[string, object]]::new()
            $groups['shared'] = @{ production = [pscustomobject]@{ readers = '0a'; operators = '0b'; data_readers = $null; data_writers = '0d' } }
            $groups['widget'] = @{ nonproduction = [pscustomobject]@{ readers = '1a'; operators = '1b'; data_readers = '1c'; data_writers = '1d' } }
            [pscustomobject]@{ environments = $environments; subscriptions = $subscriptions; policy_enforcement = $enforcement; groups = $groups }
        }
    }

    It 'passes the groups of the slot''s owner in its subscription''s class: <subscription>/<customer> -> <expected>' -ForEach @(
        @{ subscription = 'gadget_sub'; customer = ''; expected = '0a,0b,,0d' }
        @{ subscription = 'widget_sub'; customer = 'widget'; expected = '1a,1b,1c,1d' }
        @{ subscription = 'widget_sub'; customer = ''; expected = ',,,' }
    ) {
        $facts = & $script:resolve ([ordered]@{ widgetGroups = 'groups' }) 'cog' $subscription $customer
        @($facts.widgetGroups.Keys) | Should -Be @('readers', 'operators', 'data_readers', 'data_writers')
        @($facts.widgetGroups.Values) -join ',' | Should -Be $expected
    }

    It 'takes the policy enforcement of the slot''s subscription class, whatever its own environment: <subscription> -> <expected>' -ForEach @(
        @{ subscription = 'gadget_sub'; expected = 'Default' }
        @{ subscription = 'widget_sub'; expected = 'DoNotEnforce' }
    ) {
        $facts = & $script:resolve ([ordered]@{ widgetEnforcement = 'policy_enforcement' }) 'cog' $subscription
        $facts.widgetEnforcement | Should -Be $expected
    }

    It 'passes whether the slot''s subscription holds a production environment: <subscription> -> <expected>' -ForEach @(
        @{ subscription = 'gadget_sub'; expected = $true }
        @{ subscription = 'widget_sub'; expected = $false }
    ) {
        $facts = & $script:resolve ([ordered]@{ widgetZoned = 'subscription_production' }) 'cog' $subscription
        $facts.widgetZoned | Should -Be $expected
    }

    It 'passes the slot environment''s field as the parameter: <environment> -> <expected>' -ForEach @(
        @{ environment = 'gadget'; expected = $true }
        @{ environment = 'sprocket'; expected = $false }
    ) {
        $facts = & $script:resolve ([ordered]@{ deployWidgetAlerts = 'production' }) $environment
        $facts.deployWidgetAlerts | Should -Be $expected
    }

    It 'resolves nothing, and reads no config, for a template with no facts' {
        (& $script:resolve ([ordered]@{}) 'gadget').Count | Should -Be 0
        Should -Invoke Get-Config -ModuleName Catzc.Azure.Templates -Times 0 -ParameterFilter { $Config -eq 'azure' }
    }

    It 'throws on a slot environment azure.yml does not declare' {
        { & $script:resolve ([ordered]@{ deployWidgetAlerts = 'production' }) 'sprocket-x' } | Should -Throw "*environment 'sprocket-x', which azure.yml does not declare*"
    }
}
