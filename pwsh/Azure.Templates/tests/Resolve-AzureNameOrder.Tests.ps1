# cspell:ignore widgetfirst
Describe 'Resolve-AzureNameOrder' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-AzureNameOrderSet -ModuleName Catzc.Azure.Templates {
            [ordered]@{ widgetfirst = @(@('widget'), @('gadget')) }
        }
    }

    It 'looks a preset name up in the order set' {
        $order = InModuleScope Catzc.Azure.Templates { Resolve-AzureNameOrder -Order 'widgetfirst' }
        $order.Count | Should -Be 2
        $order[0] | Should -Be @('widget')
        $order[1] | Should -Be @('gadget')
    }

    It 'turns an explicit segment list into one segment per position' {
        $order = InModuleScope Catzc.Azure.Templates { Resolve-AzureNameOrder -Order @('gadget', 'widget') }
        $order.Count | Should -Be 2
        , $order[0] | Should -BeOfType [object[]]
        $order[0] | Should -Be @('gadget')
        $order[1] | Should -Be @('widget')
    }

    It 'throws on an unknown preset, naming the known ones' {
        { InModuleScope Catzc.Azure.Templates { Resolve-AzureNameOrder -Order 'sideways' } } |
            Should -Throw "*Unknown name order 'sideways'*widgetfirst*"
    }
}
