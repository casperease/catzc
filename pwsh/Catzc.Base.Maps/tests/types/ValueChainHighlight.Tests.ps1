Describe 'ValueChainHighlight' -Tag 'L0', 'logic' {
    BeforeAll {
        $adr = {
            param([string] $External, [string] $Stack, [string[]] $Concerns)
            [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'widget', $External, 'WIDGET', 'WIDGET', $null, $Stack, $Concerns, $Concerns)
        }
        $script:map = [Catzc.Base.Maps.ValueChainMap]::Build(@('TOP', 'BOTTOM'), @('alpha', 'beta', 'gamma'), @(
                & $adr 'ADR-WIDGET-GADGET' 'TOP' @('alpha', 'gamma')
                & $adr 'ADR-WIDGET-SPROCKET' 'BOTTOM' @('beta')
                & $adr 'ADR-WIDGET-COG' 'TOP' @('gamma')
            ))
        $script:cellNames = { param($Highlight) @($Highlight.Cells | ForEach-Object { "$($_.Stack) x $($_.Concern)" }) }
    }

    It 'lights the cells an ADR sits in, in the map''s order' -Tag 'ADR-DSGN-TRACK-VALUECHAINMAP' {
        $highlight = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($script:map, 'ADR-WIDGET-GADGET')
        $highlight.Requested | Should -Be @('ADR-WIDGET-GADGET')
        & $script:cellNames $highlight | Should -Be @('TOP x alpha', 'TOP x gamma')
        $highlight.Cells[1].Adrs | Should -Be @('ADR-WIDGET-GADGET')
    }

    It 'lights a rule''s cells as its ADR''s, in either citation form' -Tag 'ADR-DSGN-TRACK-LITCELL' {
        $highlight = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($script:map, @('ADR-WIDGET-SPROCKET#3', 'ADR-WIDGET-COG:2'))
        $highlight.Requested | Should -Be @('ADR-WIDGET-SPROCKET#3', 'ADR-WIDGET-COG#2')
        & $script:cellNames $highlight | Should -Be @('TOP x gamma', 'BOTTOM x beta')
    }

    It 'lists in a lit cell only the requested ADRs that light it, once each' -Tag 'ADR-DSGN-TRACK-LITCELL' {
        $highlight = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($script:map, @('ADR-WIDGET-COG', 'ADR-WIDGET-GADGET#1', 'ADR-WIDGET-COG#4'))
        $highlight.Requested | Should -Be @('ADR-WIDGET-COG', 'ADR-WIDGET-GADGET#1', 'ADR-WIDGET-COG#4')
        & $script:cellNames $highlight | Should -Be @('TOP x alpha', 'TOP x gamma')
        $highlight.Cells[1].Adrs | Should -Be @('ADR-WIDGET-COG', 'ADR-WIDGET-GADGET')
    }

    It 'lights nothing for an empty request' {
        $highlight = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($script:map, @())
        $highlight.Cells | Should -BeNullOrEmpty
    }

    It 'throws once, naming every reference that is not an ADR code of the map' {
        { [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($script:map, @('ADR-WIDGET-GIZMO', 'widget', 'ADR-WIDGET-COG')) } |
            Should -Throw "*value-chain highlight: 'ADR-WIDGET-GIZMO' is not an ADR code of the adrs registry; 'widget' is not an ADR code of the adrs registry*"
    }

    It 'gives every lit cell a reason per ADR: its ADR domain''s row, the concern, and default or override' -Tag 'ADR-DSGN-TRACK-VALUECHAINSTACK', 'ADR-DSGN-TRACK-VALUECHAINCONCERN' {
        $own = [Catzc.Base.Docs.AdrRuleSet]::new('widgetry', 'fixture', 'gizmo', 'ADR-WIDGET-GIZMO', 'WIDGET', 'WIDGET', $null, 'TOP',
            [string[]] @('beta'), [string[]] @('alpha', 'gamma'))
        $map = [Catzc.Base.Maps.ValueChainMap]::Build(@('TOP', 'BOTTOM'), @('alpha', 'beta', 'gamma'), @($own))
        $reason = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($map, 'ADR-WIDGET-GIZMO#2').Reasons
        @($reason).Count | Should -Be 1
        "$($reason.Requested) $($reason.Adr) $($reason.Domain) $($reason.Stack) $($reason.Concern)" | Should -Be 'ADR-WIDGET-GIZMO#2 ADR-WIDGET-GIZMO widgetry TOP beta'
        $reason.Override | Should -BeTrue
        $default = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($script:map, 'ADR-WIDGET-GADGET')
        @($default.Reasons | ForEach-Object { "$($_.Stack) x $($_.Concern) $($_.Override)" }) | Should -Be @('TOP x alpha False', 'TOP x gamma False')
        @($default.ReasonsOf('TOP', 'gamma')).Count | Should -Be 1
    }

    It 'emits the request and the lit cells as JSON' -Tag 'ADR-THES-ONETRUTH-TRUTHISQUERYABLE' {
        $data = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($script:map, 'ADR-WIDGET-SPROCKET').ToJson() | ConvertFrom-Json
        $data.requested | Should -Be @('ADR-WIDGET-SPROCKET')
        @($data.cells).Count | Should -Be 1
        $data.cells[0].stack | Should -Be 'BOTTOM'
        $data.cells[0].concern | Should -Be 'beta'
        $data.cells[0].adrs | Should -Be @('ADR-WIDGET-SPROCKET')
        @($data.cells[0].reasons[0].PSObject.Properties.Name) |
            Should -Be @('requested', 'adr', 'domain', 'stack', 'concern', 'concerns', 'domain_concerns', 'override')
        $data.cells[0].reasons[0].override | Should -BeFalse
    }
}
