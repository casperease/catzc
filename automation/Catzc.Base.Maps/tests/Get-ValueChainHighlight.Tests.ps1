<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Maps
    relatives:
      page: docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
      source: automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-DSGN-TRACK#{12,16}
      - ADR-THES-ONETRUTH#3
---
#>

Describe 'Get-ValueChainHighlight' -Tag 'L0', 'logic' {
    BeforeAll {
        $adr = {
            param([string] $External, [string] $Stack, [string[]] $Concerns)
            [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'widget', $External, 'WIDGET', 'WIDGET', $null, $Stack, $Concerns, $Concerns)
        }
        $script:map = [Catzc.Base.Maps.ValueChainMap]::Build(@('TOP', 'BOTTOM'), @('alpha', 'beta'), @(
                & $adr 'ADR-WIDGET-GADGET' 'TOP' @('alpha', 'beta')
                & $adr 'ADR-WIDGET-COG' 'BOTTOM' @('beta')
            ))
    }

    BeforeEach {
        Mock Get-ValueChainMap -ModuleName Catzc.Base.Maps { $script:map }
    }

    It 'lights the cells of an ADR code given by position' -Tag 'ADR-DSGN-TRACK#16' {
        $highlight = Get-ValueChainHighlight ADR-WIDGET-GADGET
        $highlight | Should -BeOfType [Catzc.Base.Maps.ValueChainHighlight]
        @($highlight.Cells | ForEach-Object { "$($_.Stack) x $($_.Concern)" }) | Should -Be @('TOP x alpha', 'TOP x beta')
    }

    It 'lights a rule citation''s ADR cells' -Tag 'ADR-DSGN-TRACK#12' {
        $highlight = Get-ValueChainHighlight -Adr 'ADR-WIDGET-COG#2'
        $highlight.Requested | Should -Be @('ADR-WIDGET-COG#2')
        @($highlight.Cells | ForEach-Object { "$($_.Stack) x $($_.Concern)" }) | Should -Be @('BOTTOM x beta')
    }

    It 'emits JSON with -AsJson' -Tag 'ADR-THES-ONETRUTH#3' {
        $data = Get-ValueChainHighlight -Adr 'ADR-WIDGET-GADGET', 'ADR-WIDGET-COG' -AsJson | ConvertFrom-Json
        @($data.cells).Count | Should -Be 3
        $data.cells[1].adrs | Should -Be @('ADR-WIDGET-GADGET')
        $data.cells[2].adrs | Should -Be @('ADR-WIDGET-COG')
    }

    It 'throws on an unknown code' {
        { Get-ValueChainHighlight -Adr 'ADR-WIDGET-UNKNOWN' } | Should -Throw "*'ADR-WIDGET-UNKNOWN' is not an ADR code*"
    }
}

Describe 'Get-ValueChainHighlight — the real registry' -Tag 'L1', 'integrity', 'source-only' {
    It 'lights the cells of each ADR''s row and value-chain concerns, for every ADR of adrs.yml' -Tag 'ADR-DSGN-TRACK#16' {
        foreach ($ruleSet in @(Get-AdrRuleSet)) {
            $cells = @((Get-ValueChainHighlight -Adr "$($ruleSet.External)#1").Cells)
            @($cells | ForEach-Object Concern) | Should -Be @($ruleSet.Concerns) -Because $ruleSet.External
            @($cells | Where-Object Stack -CNE $ruleSet.Stack) | Should -BeNullOrEmpty -Because $ruleSet.External
        }
    }
}
