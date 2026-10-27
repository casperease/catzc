Describe 'Catzc.Azure.RolesConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        # Built at runtime, so the guid scan never reads these fixture values as unregistered guids.
        $prefix = 'a100a000-7e57-7e0a-0700-00000000000'
        $script:widgetId = $prefix + '1'
        $script:gadgetId = $prefix + '2'

        function script:Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Azure.RolesConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the RolesConfig constructor to throw'
        }
    }

    It 'reads each role''s id and description, by name, in file order' {
        $config = [Catzc.Azure.RolesConfig]::new([ordered]@{
                roles = [ordered]@{
                    widget_reader = [ordered]@{ id = $widgetId; description = 'Widget Reader — read widgets.' }
                    gadget_owner  = [ordered]@{ id = $gadgetId; description = 'Gadget Owner — own gadgets.' }
                }
            })
        @($config.roles.Keys) | Should -Be @('widget_reader', 'gadget_owner')
        $config.roles['widget_reader'].id | Should -BeExactly $widgetId
        $config.roles['gadget_owner'].description | Should -BeExactly 'Gadget Owner — own gadgets.'
    }

    It 'refuses a bad name, a non-canonical id, a missing description, an unknown key and a duplicate id, all in one throw' {
        $message = Get-ViolationMessage ([ordered]@{
                roles = [ordered]@{
                    WidgetReader = [ordered]@{ id = $widgetId; description = 'x' }
                    widget_upper = [ordered]@{ id = $widgetId.ToUpperInvariant(); description = 'x' }
                    widget_bare  = [ordered]@{ id = $widgetId }
                    widget_extra = [ordered]@{ id = $widgetId; description = 'x'; scope = 'everything' }
                    gadget_one   = [ordered]@{ id = $gadgetId; description = 'x' }
                    gadget_two   = [ordered]@{ id = $gadgetId; description = 'x' }
                }
            })
        $message | Should -BeLike "*role 'WidgetReader': the name must be snake_case*"
        $message | Should -BeLike "*role 'widget_upper': the id must be the role definition GUID, lowercase*"
        $message | Should -BeLike "*role 'widget_bare' needs a description*"
        $message | Should -BeLike "*role 'widget_extra': unknown key 'scope'*"
        $message | Should -BeLike "*role 'gadget_two': id '$gadgetId' is declared twice*"
    }

    It 'refuses an unknown top-level key' {
        Get-ViolationMessage ([ordered]@{ roles = $null; gizmos = @{} }) | Should -BeLike "*unknown top-level key 'gizmos' (allowed: roles)*"
    }
}

Describe 'Catzc.Azure.RolesConfig — shipped roles.yml' -Tag 'L1', 'integrity' {
    It 'loads, and holds the Owner role the action group addresses' {
        (Get-Config -Config roles).roles['owner'].id | Should -BeExactly '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
    }
}
