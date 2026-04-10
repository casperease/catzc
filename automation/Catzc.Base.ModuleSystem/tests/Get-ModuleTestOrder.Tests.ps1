Describe 'Get-ModuleTestOrder' -Tag 'L0', 'logic' {
    It 'orders each module after its declared module dependencies (foundation-first)' {
        Mock Get-AutomationModules { @('Catzc.A', 'Catzc.B', 'Catzc.C') } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleGroupConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.C' = @('Catzc.B'); 'Catzc.B' = @('Catzc.A') }
        } -ModuleName Catzc.Base.ModuleSystem

        Get-ModuleTestOrder | Should -Be @('Catzc.A', 'Catzc.B', 'Catzc.C')
    }

    It 'expands a group dependency to all its members (and honours the group-internal layering)' {
        Mock Get-AutomationModules { @('Catzc.App', 'Catzc.Base.A', 'Catzc.Base.B') } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleGroupConfig {
            [ordered]@{ Base = [ordered]@{ 'Catzc.Base.A' = @(); 'Catzc.Base.B' = @('Catzc.Base.A') } }
        } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.App' = @('Base') }
        } -ModuleName Catzc.Base.ModuleSystem

        $order = @(Get-ModuleTestOrder)
        # App depends on the whole Base group -> after every member
        [array]::IndexOf($order, 'Catzc.App') | Should -BeGreaterThan ([array]::IndexOf($order, 'Catzc.Base.A'))
        [array]::IndexOf($order, 'Catzc.App') | Should -BeGreaterThan ([array]::IndexOf($order, 'Catzc.Base.B'))
        # within Base, B depends on A
        [array]::IndexOf($order, 'Catzc.Base.B') | Should -BeGreaterThan ([array]::IndexOf($order, 'Catzc.Base.A'))
    }

    It 'breaks ties alphabetically (deterministic order among same-layer modules)' {
        Mock Get-AutomationModules { @('Catzc.B', 'Catzc.A', 'Catzc.C') } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleGroupConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem

        Get-ModuleTestOrder | Should -Be @('Catzc.A', 'Catzc.B', 'Catzc.C')
    }

    It 'throws on a dependency cycle' {
        Mock Get-AutomationModules { @('Catzc.A', 'Catzc.B') } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleGroupConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.A' = @('Catzc.B'); 'Catzc.B' = @('Catzc.A') }
        } -ModuleName Catzc.Base.ModuleSystem

        { Get-ModuleTestOrder } | Should -Throw '*Cycle*'
    }
}

Describe 'Get-ModuleTestOrder (real dependency graph)' -Tag 'L0', 'integrity' {
    It 'returns every on-disk module exactly once' {
        $order = @(Get-ModuleTestOrder)
        $expected = @(Get-AutomationModules)
        $order.Count | Should -Be $expected.Count
        ($order | Sort-Object) | Should -Be ($expected | Sort-Object)
    }

    It 'orders a base module before a module that depends on it' {
        $order = @(Get-ModuleTestOrder)
        [array]::IndexOf($order, 'Catzc.Base.Asserts') |
            Should -BeLessThan ([array]::IndexOf($order, 'Catzc.Azure.Templates'))
    }
}
