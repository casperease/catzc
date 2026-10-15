<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleTestOrder.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.ModuleSystem/Get-ModuleTestOrder.ps1
---
#>

Describe 'Get-ModuleTestOrder' -Tag 'L0', 'logic' {
    It 'orders each module after its declared module dependencies (dependencies-first)' {
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
            [ordered]@{ Widgets = [ordered]@{ 'Catzc.Base.A' = @(); 'Catzc.Base.B' = @('Catzc.Base.A') } }
        } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.App' = @('Widgets') }
        } -ModuleName Catzc.Base.ModuleSystem

        $order = @(Get-ModuleTestOrder)
        # App depends on the whole Widgets group -> after every member
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

    It 'returns every module exactly once, an undeclared one among the roots' {
        Mock Get-AutomationModules { @('Catzc.Widget', 'Catzc.Gadget', 'Catzc.Gizmo', 'Catzc.Base.Widget') } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleGroupConfig {
            [ordered]@{ Base = [ordered]@{ 'Catzc.Base.Widget' = @() } }
        } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.Widget' = @('Base'); 'Catzc.Gadget' = @('Catzc.Widget') }
        } -ModuleName Catzc.Base.ModuleSystem

        $order = @(Get-ModuleTestOrder)
        $order | Should -HaveCount 4
        @($order | Sort-Object -Unique) | Should -HaveCount 4
        $order | Should -Be @('Catzc.Base.Widget', 'Catzc.Gizmo', 'Catzc.Widget', 'Catzc.Gadget')
    }
}
