Describe 'MinimapData' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
    BeforeAll {
        $schemaPath = Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/pwsh.base.maps/minimap.schema.json'
        $script:schema = [System.IO.File]::ReadAllText($schemaPath)
        $script:conforms = { param([string] $Json) Test-Json -Json $Json -Schema $script:schema -ErrorAction SilentlyContinue }

        $tracks = @(
            [Catzc.Base.Variants.VariantTrack]::new('widgets', @('widgets'), 'modules', $null, @('widget-script'))
            [Catzc.Base.Variants.VariantTrack]::new('docs', @('docs'), 'documentation', $null, @('notes'))
        )
        $languages = @(
            [Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('notes', @('.md'), $null, 'fixture', $null, $null, $null)
        )
        $texts = [ordered]@{ 'widgets/Alpha/Get-Widget.ps1' = '# ADR-WIDGET-GADGET-SPIN'; 'docs/guide.md' = 'Read ADR-WIDGET-GADGET.' }
        $paths = @('widgets/Alpha/Get-Widget.ps1', 'docs/drs/widgetry/widget-gadget.md', 'docs/guide.md')
        $script:worldMap = [Catzc.Base.Maps.WorldMapBuilder]::Build($tracks, $languages, $paths, [ordered]@{},
            [ordered]@{ 'ADR-WIDGET-GADGET' = 'widgetry' }, [ordered]@{ 'ADR-WIDGET-GADGET' = 'docs/drs/widgetry/widget-gadget.md' }, $texts, [ordered]@{}, @())
        $script:worldHighlight = [Catzc.Base.Maps.WorldMapHighlight]::ForAdr($script:worldMap, @('ADR-WIDGET-GADGET'),
            @(), @())

        $adr = {
            param([string] $External, [string] $Stack, [string[]] $Concerns)
            [Catzc.Base.Drs.DrsRuleSet]::new('widgetry', 'fixture', 'widget', $External, 'WIDGET', 'WIDGET', $Stack,
                $Concerns, $Concerns)
        }
        $script:chain = [Catzc.Base.Maps.ValueChainMap]::Build(@('TOP', 'BOTTOM'), @('alpha', 'beta'), @(
                & $adr 'ADR-WIDGET-GADGET' 'TOP' @('alpha')
                & $adr 'ADR-WIDGET-SPROCKET' 'BOTTOM' @('beta')
            ))
        $script:chainHighlight = [Catzc.Base.Maps.ValueChainHighlight]::ForAdr($script:chain, 'ADR-WIDGET-GADGET')
    }

    It 'serializes the grid to the minimap schema, every lit cell with its reason' {
        $data = [Catzc.Base.Maps.MinimapData]::FromWorldMap($script:worldMap, $script:worldHighlight)
        $data.Id | Should -Be 'grid'
        $data.Axes.Name | Should -Be @('track', 'file_language')
        $data.Lit.Count | Should -BeGreaterThan 0
        $data.Lit | ForEach-Object { $_.Reasons.Count | Should -BeGreaterThan 0 }
        & $script:conforms $data.ToJson() | Should -BeTrue
    }

    It 'serializes the axis to the minimap schema, lit by the requested ADR' {
        $data = [Catzc.Base.Maps.MinimapData]::FromValueChain($script:chain, $script:chainHighlight)
        $data.Id | Should -Be 'axis'
        $data.Axes.Name | Should -Be @('stack', 'concern')
        @($data.Lit | ForEach-Object { $_.At -join ' x ' }) | Should -Be @('TOP x alpha')
        $data.Lit[0].Reasons[0].Subject | Should -Be 'ADR-WIDGET-GADGET'
        & $script:conforms $data.ToJson() | Should -BeTrue
    }

    It 'rejects an id outside the eight minimaps, naming them' {
        { [Catzc.Base.Maps.MinimapData]::new('widget', @(), @(), @()) } |
            Should -Throw "*minimap id 'widget' is not one of: grid, code-locations, axis*"
    }

    It 'rejects a lit cell with no reason, and a cell whose place does not match the axes' {
        $axes = @([Catzc.Base.Maps.MinimapAxis]::new('widget', @('a', 'b')))
        { [Catzc.Base.Maps.MinimapData]::new('grid', $axes, @(), @([Catzc.Base.Maps.MinimapCell]::new(@('a'), 1))) } |
            Should -Throw '*has no reason*'
        { [Catzc.Base.Maps.MinimapData]::new('grid', $axes, @([Catzc.Base.Maps.MinimapCell]::new(@('a', 'b'), 1)),
                @()) } | Should -Throw '*names 2 axis values, but the minimap has 1 axes*'
    }

    It 'the schema rejects a minimap whose lit cell has no reasons' {
        & $script:conforms '{ "id": "grid", "axes": [], "cells": [], "lit": [ { "at": [], "count": 1 } ] }' |
            Should -BeFalse
    }
}
