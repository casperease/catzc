Describe 'Resolve-BicepEnvironmentFacts' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:resolve = {
            param([System.Collections.IDictionary] $Parameters, [string] $Environment, [string] $Subscription = 'widget_sub', [string] $Customer = '')
            $slot = [Catzc.Azure.Templates.BicepSlot]::new($Environment, $Environment, '', $Subscription, $Customer, 'widget.yml')
            InModuleScope Catzc.Azure.Templates -Parameters @{ Parameters = $Parameters; Slot = $slot } {
                param($Parameters, $Slot)
                Resolve-BicepEnvironmentFacts -Parameters $Parameters -Slot $Slot -ConfigFile 'C:/widget/configuration/widget.yml'
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
        $resolved = & $script:resolve ([ordered]@{ widgetGroups = [ordered]@{ fact = 'groups' } }) 'cog' $subscription $customer
        @($resolved.widgetGroups.value.Keys) | Should -Be @('readers', 'operators', 'data_readers', 'data_writers')
        @($resolved.widgetGroups.value.Values) -join ',' | Should -Be $expected
    }

    It 'resolves { fact: policy_enforcement } to the slot''s subscription class, whatever its own environment: <subscription> -> <expected>' -ForEach @(
        @{ subscription = 'gadget_sub'; expected = 'Default' }
        @{ subscription = 'widget_sub'; expected = 'DoNotEnforce' }
    ) {
        $resolved = & $script:resolve ([ordered]@{ widgetEnforcement = [ordered]@{ fact = 'policy_enforcement' } }) 'cog' $subscription
        $resolved.widgetEnforcement.value | Should -Be $expected
    }

    It 'passes whether the slot''s subscription holds a production environment: <subscription> -> <expected>' -ForEach @(
        @{ subscription = 'gadget_sub'; expected = $true }
        @{ subscription = 'widget_sub'; expected = $false }
    ) {
        $resolved = & $script:resolve ([ordered]@{ widgetZoned = [ordered]@{ fact = 'subscription_production' } }) 'cog' $subscription
        $resolved.widgetZoned.value | Should -Be $expected
    }

    It 'passes the types the shared modules declare, as an array even when there is one: <types>' -ForEach @(
        @{ types = @('Widget.Parts/widgets') }
        @{ types = @('Widget.Parts/gadgets', 'Widget.Parts/widgets') }
    ) {
        Mock Get-BicepModuleResourceTypes -ModuleName Catzc.Azure.Templates { $types }
        $resolved = & $script:resolve ([ordered]@{ widgetTypes = [ordered]@{ fact = 'module_resource_types' } }) 'cog'
        , $resolved.widgetTypes.value | Should -BeOfType ([string[]])
        $resolved.widgetTypes.value | Should -Be $types
    }

    It 'passes the slot environment''s field as the parameter: <environment> -> <expected>' -ForEach @(
        @{ environment = 'gadget'; expected = $true }
        @{ environment = 'sprocket'; expected = $false }
    ) {
        $resolved = & $script:resolve ([ordered]@{ deployWidgetAlerts = [ordered]@{ fact = 'production' } }) $environment
        $resolved.deployWidgetAlerts.value | Should -Be $expected
    }

    It 'passes every other entry through unchanged, in order' {
        $resolved = & $script:resolve ([ordered]@{
                widgetName        = [ordered]@{ value = 'widget' }
                gadgetEnforcement = [ordered]@{ fact = 'policy_enforcement' }
                gadgetSecret      = [ordered]@{ reference = 'kv' }
            }) 'cog'
        @($resolved.Keys) | Should -Be @('widgetName', 'gadgetEnforcement', 'gadgetSecret')
        $resolved.widgetName.value | Should -Be 'widget'
        $resolved.gadgetSecret.reference | Should -Be 'kv'
    }

    It 'resolves nothing, and reads no config, for a slot with no fact' {
        $resolved = & $script:resolve ([ordered]@{ widgetName = [ordered]@{ value = 'widget' } }) 'gadget'
        $resolved.widgetName.value | Should -Be 'widget'
        Should -Invoke Get-Config -ModuleName Catzc.Azure.Templates -Times 0 -ParameterFilter { $Config -eq 'azure' }
    }

    It 'throws on an unknown field, naming the slot file, the parameter and the field' {
        { & $script:resolve ([ordered]@{ widgetMode = [ordered]@{ fact = 'gadget_mode' } }) 'cog' } |
            Should -Throw "*'C:/widget/configuration/widget.yml'*parameter 'widgetMode' names fact 'gadget_mode', which is not a known field*"
    }

    It 'throws on a fact set together with another key' {
        { & $script:resolve ([ordered]@{ widgetMode = [ordered]@{ fact = 'production'; value = $true } }) 'cog' } |
            Should -Throw "*'C:/widget/configuration/widget.yml'*parameter 'widgetMode' sets 'fact' together with 'value'*"
    }

    It 'throws on a slot environment azure.yml does not declare' {
        { & $script:resolve ([ordered]@{ deployWidgetAlerts = [ordered]@{ fact = 'production' } }) 'sprocket-x' } |
            Should -Throw "*environment 'sprocket-x', which azure.yml does not declare*"
    }
}
