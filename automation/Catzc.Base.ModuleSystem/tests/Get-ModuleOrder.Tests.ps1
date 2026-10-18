Describe 'Get-ModuleOrder' -Tag 'L0', 'logic', 'ADR-AUTO-MODULE#5' {
    It 'orders each module after its declared module dependencies (dependencies-first)' {
        Mock Get-ModuleGroupConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.C' = @('Catzc.B'); 'Catzc.B' = @('Catzc.A') }
        } -ModuleName Catzc.Base.ModuleSystem

        Get-ModuleOrder -Module 'Catzc.C', 'Catzc.A', 'Catzc.B' | Should -Be @('Catzc.A', 'Catzc.B', 'Catzc.C')
    }

    It 'expands a group dependency to all its members (and honours the group-internal layering)' {
        Mock Get-ModuleGroupConfig {
            [ordered]@{ Widgets = [ordered]@{ 'Catzc.Base.A' = @(); 'Catzc.Base.B' = @('Catzc.Base.A') } }
        } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.App' = @('Widgets') }
        } -ModuleName Catzc.Base.ModuleSystem

        $order = @(Get-ModuleOrder -Module 'Catzc.App', 'Catzc.Base.A', 'Catzc.Base.B')
        # App depends on the whole Widgets group -> after every member
        [array]::IndexOf($order, 'Catzc.App') | Should -BeGreaterThan ([array]::IndexOf($order, 'Catzc.Base.A'))
        [array]::IndexOf($order, 'Catzc.App') | Should -BeGreaterThan ([array]::IndexOf($order, 'Catzc.Base.B'))
        # within Base, B depends on A
        [array]::IndexOf($order, 'Catzc.Base.B') | Should -BeGreaterThan ([array]::IndexOf($order, 'Catzc.Base.A'))
    }

    It 'breaks ties alphabetically (deterministic order among same-layer modules)' {
        Mock Get-ModuleGroupConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem

        Get-ModuleOrder -Module 'Catzc.B', 'Catzc.A', 'Catzc.C' | Should -Be @('Catzc.A', 'Catzc.B', 'Catzc.C')
    }

    It 'throws on a dependency cycle' {
        Mock Get-ModuleGroupConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.A' = @('Catzc.B'); 'Catzc.B' = @('Catzc.A') }
        } -ModuleName Catzc.Base.ModuleSystem

        { Get-ModuleOrder -Module 'Catzc.A', 'Catzc.B' } | Should -Throw '*Cycle*'
    }

    It 'returns every module exactly once, an undeclared one among the roots' {
        Mock Get-ModuleGroupConfig {
            [ordered]@{ Base = [ordered]@{ 'Catzc.Base.Widget' = @() } }
        } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.Widget' = @('Base'); 'Catzc.Gadget' = @('Catzc.Widget') }
        } -ModuleName Catzc.Base.ModuleSystem

        $order = @(Get-ModuleOrder -Module 'Catzc.Widget', 'Catzc.Gadget', 'Catzc.Gizmo', 'Catzc.Base.Widget')
        $order | Should -HaveCount 4
        @($order | Sort-Object -Unique) | Should -HaveCount 4
        $order | Should -Be @('Catzc.Base.Widget', 'Catzc.Gizmo', 'Catzc.Widget', 'Catzc.Gadget')
    }

    It 'orders the modules the resolver finds when no module is named' {
        Mock Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $TrackType -contains 'modules' } {
            [Catzc.Base.Modules.Module]::new('Catzc.B', 'widgets', 'widget-folder', 'widgetry', 'widgetry/Catzc.B', 'folder', $null, $null, $null, $null)
            [Catzc.Base.Modules.Module]::new('Catzc.A', 'widgets', 'widget-folder', 'widgetry', 'widgetry/Catzc.A', 'folder', $null, $null, $null, $null)
        }
        Mock Get-ModuleGroupConfig { [ordered]@{} } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig { [ordered]@{ 'Catzc.A' = @('Catzc.B') } } -ModuleName Catzc.Base.ModuleSystem

        Get-ModuleOrder | Should -Be @('Catzc.B', 'Catzc.A')
    }
}

Describe 'Get-ModuleOrder on the repository' -Tag 'L1', 'integrity', 'ADR-AUTO-MODULE#5' {
    It 'orders every module of the code track once, each after every module it is declared to depend on' {
        $names = @((Get-CatzcModule -TrackType modules).name)
        $order = @(Get-ModuleOrder)
        $order | Should -HaveCount $names.Count
        $map = InModuleScope Catzc.Base.ModuleSystem -Parameters @{ Names = $names } { param($Names) Get-ModuleDependencyMap -Module $Names }
        foreach ($name in $order) {
            foreach ($dependency in $map[$name]) {
                [array]::IndexOf($order, $dependency) | Should -BeLessThan ([array]::IndexOf($order, $name)) -Because "$name depends on $dependency"
            }
        }
    }
}
