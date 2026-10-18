Describe 'Get-ValueChainMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:stacks = @([Catzc.Base.Docs.AdrsConfig]::Stacks)
        $script:concerns = @([Catzc.Base.Docs.AdrsConfig]::Concerns)
        $script:ruleSets = @(
            [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'widget-gadget', 'ADR-WIDGET-GADGET', 'WIDGET', 'WIDGET',
                $script:stacks[0], [string[]] @($script:concerns[0], $script:concerns[2]), [string[]] @($script:concerns[0]))
            [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'widget-cog', 'ADR-WIDGET-COG', 'WIDGET', 'WIDGET',
                $script:stacks[0], [string[]] @($script:concerns[0]), [string[]] @($script:concerns[0]))
        )
    }

    BeforeEach {
        Mock Get-AdrRuleSet -ModuleName Catzc.Base.Maps { $script:ruleSets }
    }

    It 'crosses the value-chain stack with the value-chain concerns, every cell included' -Tag 'ADR-DSGN-TRACK-VALUECHAINMAP' {
        $map = Get-ValueChainMap
        $map | Should -BeOfType [Catzc.Base.Maps.ValueChainMap]
        $map.Stacks | Should -Be $script:stacks
        $map.Concerns | Should -Be $script:concerns
        @($map.Cells).Count | Should -Be ($script:stacks.Count * $script:concerns.Count)
        $map.Cell($script:stacks[0], $script:concerns[0]).Adrs | Should -Be @('ADR-WIDGET-GADGET', 'ADR-WIDGET-COG')
        $map.Cell($script:stacks[0], $script:concerns[2]).Adrs | Should -Be @('ADR-WIDGET-GADGET')
        @($map.Cells | Where-Object AdrCount -GT 0).Count | Should -Be 2
    }

    It 'emits JSON with -AsJson' -Tag 'ADR-THES-ONETRUTH-TRUTHISQUERYABLE' {
        $data = Get-ValueChainMap -AsJson | ConvertFrom-Json
        $data.stacks | Should -Be $script:stacks
        @($data.cells).Count | Should -Be ($script:stacks.Count * $script:concerns.Count)
    }
}

Describe 'Get-ValueChainMap — the real registry' -Tag 'L1', 'integrity', 'source-only' {
    It 'places every ADR of adrs.yml in at least one cell of its ADR domain''s row' -Tag 'ADR-DSGN-TRACK-VALUECHAINSTACK', 'ADR-DSGN-TRACK-VALUECHAINCONCERN' {
        $map = Get-ValueChainMap
        $ruleSets = @(Get-AdrRuleSet)
        $map.AdrCount | Should -Be $ruleSets.Count
        $map.Unplaced | Should -BeNullOrEmpty
        $map.Strays | Should -BeNullOrEmpty
        foreach ($ruleSet in $ruleSets) {
            $cells = @($map.CellsOf($ruleSet.External))
            $cells.Count | Should -Be $ruleSet.Concerns.Count -Because $ruleSet.External
            @($cells | Where-Object Stack -CNE $ruleSet.Stack) | Should -BeNullOrEmpty -Because $ruleSet.External
        }
    }
}
