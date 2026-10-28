Describe 'Get-ValueChainHighlight' -Tag 'L0', 'logic' {
    BeforeAll {
        $record = {
            param([string] $External, [string] $Stack, [string[]] $Concerns)
            [Catzc.Base.Drs.DrsRuleSet]::new('widgetry', 'fixture', 'widget', $External, 'WIDGET', 'WIDGET', $Stack,
                $Concerns, $Concerns)
        }
        $script:map = [Catzc.Base.Maps.ValueChainMap]::Build(@('TOP', 'BOTTOM'), @('alpha', 'beta'), @(
                & $record 'ADR-WIDGET-GADGET' 'TOP' @('alpha', 'beta')
                & $record 'ADR-WIDGET-COG' 'BOTTOM' @('beta')
            ))
    }

    BeforeEach {
        Mock Get-ValueChainMap -ModuleName Catzc.Base.Maps { $script:map }
    }

    It 'lights the cells of a record code given by position' -Tag 'ADR-REPO-VALUECHAIN-MAP' {
        $highlight = Get-ValueChainHighlight ADR-WIDGET-GADGET
        $highlight | Should -BeOfType [Catzc.Base.Maps.ValueChainHighlight]
        @($highlight.Cells | ForEach-Object { "$($_.Stack) x $($_.Concern)" }) | Should -Be @('TOP x alpha',
            'TOP x beta')
    }

    It 'lights a rule citation''s record cells' -Tag 'DDR-TRACK-LITCELL' {
        $highlight = Get-ValueChainHighlight -Rule 'ADR-WIDGET-COG-SPIN'
        $highlight.Requested | Should -Be @('ADR-WIDGET-COG-SPIN')
        @($highlight.Cells | ForEach-Object { "$($_.Stack) x $($_.Concern)" }) | Should -Be @('BOTTOM x beta')
    }

    It 'emits JSON with -AsJson' -Tag 'TDR-ONETRUTH-TRUTHISQUERYABLE' {
        $data = Get-ValueChainHighlight -Rule 'ADR-WIDGET-GADGET', 'ADR-WIDGET-COG' -AsJson | ConvertFrom-Json
        @($data.cells).Count | Should -Be 3
        $data.cells[1].records | Should -Be @('ADR-WIDGET-GADGET')
        $data.cells[2].records | Should -Be @('ADR-WIDGET-COG')
    }

    It 'throws on an unknown code' {
        { Get-ValueChainHighlight -Rule 'ADR-WIDGET-UNKNOWN' } |
            Should -Throw "*'ADR-WIDGET-UNKNOWN' is not a record code*"
    }
}

Describe 'Get-ValueChainHighlight — the real registry' -Tag 'L1', 'integrity', 'source-only' {
    It 'lights the cells of each record''s row and value-chain concerns, for every record of drs.yml' -Tag 'ADR-REPO-VALUECHAIN-MAP' {
        $citations = Get-DrsCitationMap
        foreach ($ruleSet in @(Get-DrsRuleSet)) {
            # A rule lights its record's cells; a record with no rules of its own stands for itself.
            $rule = @($citations.RulesOf($ruleSet.External)) + $ruleSet.External | Select-Object -First 1
            $cells = @((Get-ValueChainHighlight -Rule $rule).Cells)
            @($cells | ForEach-Object Concern) | Should -Be @($ruleSet.Concerns) -Because $ruleSet.External
            @($cells | Where-Object Stack -CNE $ruleSet.Stack) | Should -BeNullOrEmpty -Because $ruleSet.External
        }
    }
}
