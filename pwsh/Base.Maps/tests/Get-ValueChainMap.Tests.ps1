Describe 'Get-ValueChainMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:stacks = @([Catzc.Base.Drs.DrsConfig]::Stacks)
        $script:concerns = @([Catzc.Base.Drs.DrsConfig]::Concerns)
        $script:ruleSets = @(
            [Catzc.Base.Drs.DrsRuleSet]::new('widgetry', 'fixture', 'widget-gadget', 'ADR-WIDGET-GADGET', 'WIDGET',
                'WIDGET',
                $script:stacks[0], [string[]] @($script:concerns[0], $script:concerns[2]),
                [string[]] @($script:concerns[0]))
            [Catzc.Base.Drs.DrsRuleSet]::new('widgetry', 'fixture', 'widget-cog', 'ADR-WIDGET-COG', 'WIDGET', 'WIDGET',
                $script:stacks[0], [string[]] @($script:concerns[0]), [string[]] @($script:concerns[0]))
        )
    }

    BeforeEach {
        Mock Get-DrsRuleSet -ModuleName Catzc.Base.Maps { $script:ruleSets }
    }

    It 'crosses the value-chain stack with the value-chain concerns, every cell included' -Tag 'ADR-REPO-VALUECHAIN-MAP' {
        $map = Get-ValueChainMap
        $map | Should -BeOfType [Catzc.Base.Maps.ValueChainMap]
        $map.Stacks | Should -Be $script:stacks
        $map.Concerns | Should -Be $script:concerns
        @($map.Cells).Count | Should -Be ($script:stacks.Count * $script:concerns.Count)
        $map.Cell($script:stacks[0], $script:concerns[0]).Records | Should -Be @('ADR-WIDGET-GADGET', 'ADR-WIDGET-COG')
        $map.Cell($script:stacks[0], $script:concerns[2]).Records | Should -Be @('ADR-WIDGET-GADGET')
        @($map.Cells | Where-Object RecordCount -GT 0).Count | Should -Be 2
    }

    It 'emits JSON with -AsJson' -Tag 'TDR-ONETRUTH-TRUTHISQUERYABLE' {
        $data = Get-ValueChainMap -AsJson | ConvertFrom-Json
        $data.stacks | Should -Be $script:stacks
        @($data.cells).Count | Should -Be ($script:stacks.Count * $script:concerns.Count)
    }
}

# It reads only drs.yml, so its answer cannot differ between the run modes: source-only.
Describe 'Get-ValueChainMap — the real registry' -Tag 'L1', 'integrity', 'source-only' {
    It 'places every record of drs.yml in at least one cell of its DRS domain''s row' -Tag 'ADR-REPO-VALUECHAIN-STACK', 'ADR-REPO-VALUECHAIN-CONCERN' {
        $map = Get-ValueChainMap
        $ruleSets = @(Get-DrsRuleSet)
        $map.RecordCount | Should -Be $ruleSets.Count
        $map.Unplaced | Should -BeNullOrEmpty
        $map.Strays | Should -BeNullOrEmpty
        foreach ($ruleSet in $ruleSets) {
            $cells = @($map.CellsOf($ruleSet.External))
            $cells.Count | Should -Be $ruleSet.Concerns.Count -Because $ruleSet.External
            @($cells | Where-Object Stack -CNE $ruleSet.Stack) | Should -BeNullOrEmpty -Because $ruleSet.External
        }
    }
}
