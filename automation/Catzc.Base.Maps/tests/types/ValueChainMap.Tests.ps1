<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Maps
    relatives:
      page: docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
      source: automation/Catzc.Base.Maps/types/ValueChainMap.cs
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-DSGN-TRACK#{15,16}
      - ADR-THES-ONETRUTH#3
---
#>

Describe 'ValueChainMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:adr = {
            param([string] $External, [string] $Stack, [string[]] $Concerns)
            [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'widget', $External, 'WIDGET', 'WIDGET', $null, $Stack, $Concerns, $Concerns)
        }
        $script:rows = @('TOP', 'BOTTOM')
        $script:columns = @('alpha', 'beta', 'gamma')
        $script:map = [Catzc.Base.Maps.ValueChainMap]::Build($script:rows, $script:columns, @(
                & $script:adr 'ADR-WIDGET-GADGET' 'TOP' @('alpha', 'gamma')
                & $script:adr 'ADR-WIDGET-SPROCKET' 'BOTTOM' @('beta')
                & $script:adr 'ADR-WIDGET-COG' 'TOP' @('gamma')
            ))
        $script:counts = { param($Map) @($Map.Cells | ForEach-Object { "$($_.Stack) x $($_.Concern) = $($_.AdrCount)" }) }
    }

    It 'holds every cell of the grid, row by row, empty cells included' -Tag 'ADR-DSGN-TRACK#16' {
        $script:map.Stacks | Should -Be $script:rows
        $script:map.Concerns | Should -Be $script:columns
        & $script:counts $script:map | Should -Be @(
            'TOP x alpha = 1', 'TOP x beta = 0', 'TOP x gamma = 2'
            'BOTTOM x alpha = 0', 'BOTTOM x beta = 1', 'BOTTOM x gamma = 0'
        )
    }

    It 'lists the ADRs of a cell in the given order' -Tag 'ADR-DSGN-TRACK#16' {
        $script:map.Cell('TOP', 'gamma').Adrs | Should -Be @('ADR-WIDGET-GADGET', 'ADR-WIDGET-COG')
        $script:map.Cell('TOP', 'delta') | Should -BeNullOrEmpty
    }

    It 'answers the cells an ADR sits in, in the map''s order, and nothing for a code it does not hold' -Tag 'ADR-DSGN-TRACK#16' {
        @($script:map.CellsOf('ADR-WIDGET-GADGET') | ForEach-Object { "$($_.Stack) x $($_.Concern)" }) | Should -Be @('TOP x alpha', 'TOP x gamma')
        $script:map.CellsOf('ADR-WIDGET-GIZMO') | Should -BeNullOrEmpty
        $script:map.AdrCount | Should -Be 3
        $script:map.Unplaced | Should -BeNullOrEmpty
        $script:map.Strays | Should -BeNullOrEmpty
    }

    It 'records a row or value-chain concern the axes lack, and an ADR that sits in no cell' -Tag 'ADR-DSGN-TRACK#15' {
        $map = [Catzc.Base.Maps.ValueChainMap]::Build($script:rows, $script:columns, @(
                & $script:adr 'ADR-WIDGET-GADGET' 'MIDDLE' @('alpha')
                & $script:adr 'ADR-WIDGET-COG' 'TOP' @('alpha', 'delta')
                & $script:adr 'ADR-WIDGET-GIZMO' 'TOP' @('delta')
            ))
        $map.Strays | Should -Be @(
            "ADR-WIDGET-GADGET: 'MIDDLE' is not a row of the value-chain stack (TOP, BOTTOM)"
            "ADR-WIDGET-COG: 'delta' is not a value-chain concern (alpha, beta, gamma)"
            "ADR-WIDGET-GIZMO: 'delta' is not a value-chain concern (alpha, beta, gamma)"
        )
        $map.Unplaced | Should -Be @('ADR-WIDGET-GADGET', 'ADR-WIDGET-GIZMO')
        $map.Cell('TOP', 'alpha').Adrs | Should -Be @('ADR-WIDGET-COG')
    }

    It 'throws on a repeated ADR code, a repeated axis name, an empty axis, or an item that is not an ADR' {
        { [Catzc.Base.Maps.ValueChainMap]::Build($script:rows, $script:columns, @((& $script:adr 'ADR-WIDGET-COG' 'TOP' @('alpha')), (& $script:adr 'ADR-WIDGET-COG' 'TOP' @('beta')))) } |
            Should -Throw "*the ADR code 'ADR-WIDGET-COG' is empty or repeated*"
        { [Catzc.Base.Maps.ValueChainMap]::Build(@('TOP', 'TOP'), $script:columns, @()) } | Should -Throw "*row of the value-chain stack 'TOP' is empty or repeated*"
        { [Catzc.Base.Maps.ValueChainMap]::Build($script:rows, @(), @()) } | Should -Throw '*no value-chain concern is given*'
        { [Catzc.Base.Maps.ValueChainMap]::Build($script:rows, $script:columns, @('ADR-WIDGET-COG')) } | Should -Throw '*an ADR is not a Catzc.Base.Docs.AdrRuleSet*'
    }

    It 'emits every cell as JSON' -Tag 'ADR-THES-ONETRUTH#3' {
        $data = $script:map.ToJson() | ConvertFrom-Json
        $data.stacks | Should -Be $script:rows
        $data.concerns | Should -Be $script:columns
        @($data.cells).Count | Should -Be 6
        $data.cells[2].stack | Should -Be 'TOP'
        $data.cells[2].concern | Should -Be 'gamma'
        $data.cells[2].adr_count | Should -Be 2
        $data.cells[2].adrs | Should -Be @('ADR-WIDGET-GADGET', 'ADR-WIDGET-COG')
        $script:map.ToJson() | Should -Not -Match "`r"
    }
}
