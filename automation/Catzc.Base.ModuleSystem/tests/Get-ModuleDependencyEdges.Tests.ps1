Describe 'Get-ModuleDependencyEdges' -Tag 'L0', 'logic' {
    It 'returns typed actual edges from Get-ModuleDependency' {
        Mock Get-ModuleDependency {
            [pscustomobject]@{ From = 'Catzc.A'; To = 'Catzc.B'; CallCount = 3; Functions = @('f->g:10') }
        } -ModuleName Catzc.Base.ModuleSystem

        $edges = Get-ModuleDependencyEdges
        $edges[0] | Should -BeOfType [Catzc.Base.ModuleSystem.ModuleDependencyEdge]
        $edges[0].From | Should -Be 'Catzc.A'
        $edges[0].To | Should -Be 'Catzc.B'
        $edges[0].Kind | Should -Be 'actual'
        $edges[0].CallCount | Should -Be 3
        $edges[0].Functions | Should -Be @('f->g:10')
    }

    It 'returns declared edges from groups and modules with -Declared' {
        Mock Get-ModuleGroupConfig {
            [ordered]@{ Base = [ordered]@{ 'Catzc.Base.B' = @('Catzc.Base.A'); 'Catzc.Base.A' = @() } }
        } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-ModuleDependencyConfig {
            [ordered]@{ 'Catzc.X' = @('Base', 'Catzc.Base.A') }
        } -ModuleName Catzc.Base.ModuleSystem

        $edges = Get-ModuleDependencyEdges -Declared

        $intra = $edges | Where-Object { $_.From -eq 'Catzc.Base.B' -and $_.To -eq 'Catzc.Base.A' }
        $intra | Should -Not -BeNullOrEmpty
        $intra.Kind | Should -Be 'declared'

        ($edges | Where-Object { $_.From -eq 'Catzc.X' -and $_.To -eq 'Base' }) | Should -Not -BeNullOrEmpty
        ($edges | Where-Object { $_.From -eq 'Catzc.X' -and $_.To -eq 'Catzc.Base.A' }) | Should -Not -BeNullOrEmpty
    }
}
