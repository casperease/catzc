<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
    kind: test
---
#>

# Get-ValueChainMap builds the value-chain map from the registry's closed sets and its ADRs
# ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)). The logic tests mock the ADRs with
# widget/gadget fixtures ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the axes are
# the closed sets AdrsConfig declares, read from the type, never spelled out here.
Describe 'Get-ValueChainMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:stacks = @([Catzc.Base.Docs.AdrsConfig]::Stacks)
        $script:concerns = @([Catzc.Base.Docs.AdrsConfig]::Concerns)
        $script:ruleSets = @(
            [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'widget-gadget', 'ADR-WIDGET-GADGET', 'WIDGET', 'WIDGET', $null,
                $script:stacks[0], [string[]] @($script:concerns[0], $script:concerns[2]), [string[]] @($script:concerns[0]))
            [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'widget-cog', 'ADR-WIDGET-COG', 'WIDGET', 'WIDGET', $null,
                $script:stacks[0], [string[]] @($script:concerns[0]), [string[]] @($script:concerns[0]))
        )
    }

    BeforeEach {
        Mock Get-AdrRuleSet -ModuleName Catzc.Base.Maps { $script:ruleSets }
    }

    It 'crosses the value-chain stack with the value-chain concerns, every cell included' -Tag 'ADR-DSGN-TRACK#16' {
        $map = Get-ValueChainMap
        $map | Should -BeOfType [Catzc.Base.Maps.ValueChainMap]
        $map.Stacks | Should -Be $script:stacks
        $map.Concerns | Should -Be $script:concerns
        @($map.Cells).Count | Should -Be ($script:stacks.Count * $script:concerns.Count)
        $map.Cell($script:stacks[0], $script:concerns[0]).Adrs | Should -Be @('ADR-WIDGET-GADGET', 'ADR-WIDGET-COG')
        $map.Cell($script:stacks[0], $script:concerns[2]).Adrs | Should -Be @('ADR-WIDGET-GADGET')
        @($map.Cells | Where-Object AdrCount -GT 0).Count | Should -Be 2
    }

    It 'emits JSON with -AsJson' -Tag 'ADR-THES-ONETRUTH#3' {
        $data = Get-ValueChainMap -AsJson | ConvertFrom-Json
        $data.stacks | Should -Be $script:stacks
        @($data.cells).Count | Should -Be ($script:stacks.Count * $script:concerns.Count)
    }
}

# The registry's own value-chain map. It reads only adrs.yml, so its answer cannot differ between the run modes
# (source-only).
Describe 'Get-ValueChainMap — the real registry' -Tag 'L1', 'integrity', 'source-only' {
    It 'places every ADR of adrs.yml in at least one cell of its ADR domain''s row' -Tag 'ADR-DSGN-TRACK#14', 'ADR-DSGN-TRACK#15' {
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
