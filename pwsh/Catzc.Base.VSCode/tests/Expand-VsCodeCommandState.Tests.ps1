Describe 'Expand-VsCodeCommandState' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:expand = {
            param([System.Collections.IDictionary] $Contributes)
            InModuleScope Catzc.Base.VSCode -Parameters @{ Contributes = $Contributes } {
                param($Contributes)
                Expand-VsCodeCommandState -Contributes $Contributes
            }
        }
        $script:contributes = [ordered]@{
            commands = @(
                [ordered]@{ command = 'widget.toggle'; title = 'Widget'; icon = [ordered]@{ light = 'media/widget.svg'; dark = 'media/widget.svg' }; states = @('busy', 'broken'); state_context = 'widget.state' }
                [ordered]@{ command = 'gadget.run'; title = 'Gadget' }
            )
            menus    = [ordered]@{
                'view/title' = @(
                    [ordered]@{ command = 'widget.toggle'; when = 'view == widgets'; group = 'navigation' }
                    [ordered]@{ command = 'gadget.run' }
                )
            }
        }
    }

    It 'makes one command per declared state beside the bare one, its icon and title marked, and drops the state keys' {
        $commands = @((& $script:expand $script:contributes)['commands'])
        $commands.ForEach({ $_['command'] }) | Should -Be @('widget.toggle', 'widget.toggle.busy', 'widget.toggle.broken', 'gadget.run')
        $commands[2]['icon']['dark'] | Should -Be 'media/widget-broken.svg'
        $commands[1]['title'] | Should -Be 'Widget [busy]'
        $commands[0].Contains('states') | Should -BeFalse
        $commands[0].Contains('state_context') | Should -BeFalse
    }

    It 'repeats each menu item per state with its when narrowed, so exactly one shows, and leaves other items alone' {
        $items = @((& $script:expand $script:contributes)['menus']['view/title'])
        $items.ForEach({ $_['when'] }) | Should -Be @(
            'view == widgets && widget.state != busy && widget.state != broken'
            'view == widgets && widget.state == busy'
            'view == widgets && widget.state == broken'
            $null
        )
        $items[1]['group'] | Should -Be 'navigation'
    }

    It 'refuses states without the context key that holds the current one' {
        $broken = [ordered]@{ commands = @([ordered]@{ command = 'widget.toggle'; title = 'Widget'; states = @('busy') }) }
        { & $script:expand $broken } | Should -Throw '*declares states but no state_context*'
    }
}
