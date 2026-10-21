<#
---
catzc:
  edges:
    code: pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1
    cites:
      - ADR-REPO-SLIDES-MINIMAPSFROMDATA
---
#>

Describe 'Write-DiagramMinimapData' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-MINIMAPSFROMDATA' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:folder = 'docs/explanation/widget/.assets/widget-flow'
        $source = Join-Path $script:root $script:folder
        [System.IO.Directory]::CreateDirectory($source) | Out-Null
        # The widget's declaration lists one of the two lit layers and omits the other.
        $yml = @'
about:
  adrs:
    - ADR-WIDGET
content:
  minimaps:
    layer-stack:
      - cell: automation
        by:
          - ADR-WIDGET
'@
        [System.IO.File]::WriteAllText((Join-Path $source 'diagram.drawio.yml'), $yml)
        Mock Get-Config -ModuleName Catzc.Base.Slides -ParameterFilter { $Config -eq 'maps' } { [Catzc.Base.Maps.MapsConfig]::new([ordered]@{}) }
        Mock Get-WorldMap -ModuleName Catzc.Base.Slides { }
        Mock Get-WorldMapHighlight -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Cells = @() } }
        Mock Get-MinimapFact -ModuleName Catzc.Base.Slides { @{} }
        Mock Get-LayerStackMinimapData -ModuleName Catzc.Base.Slides {
            $reason = [Catzc.Base.Maps.MinimapReason]::new('widget.md', 'cites', 'ADR-WIDGET', 'ADR-WIDGET')
            $cells = [Catzc.Base.Maps.MinimapCell[]] @(
                [Catzc.Base.Maps.MinimapCell]::new([string[]] @('automation'), 1, @($reason))
                [Catzc.Base.Maps.MinimapCell]::new([string[]] @('contract'), 1, @($reason))
            )
            [Catzc.Base.Maps.MinimapData]::new('layer-stack', @([Catzc.Base.Maps.MinimapAxis]::new('layer', [string[]] @('automation', 'contract'))), $cells, $cells)
        }
        $script:target = InModuleScope Catzc.Base.Slides -Parameters @{ Folder = $script:folder; Root = $script:root } {
            param($Folder, $Root)
            Write-DiagramMinimapData -Folder $Folder -RepositoryRoot $Root -WarningVariable warned -WarningAction SilentlyContinue
            $script:warned = $warned
        }
        $script:warned = InModuleScope Catzc.Base.Slides { $script:warned }
    }

    It 'draws only the lit cells the declaration lists' {
        $drawn = Get-Content -Raw (Join-Path $script:root "out/minimaps/$script:folder/layer-stack.json") | ConvertFrom-Json
        @($drawn.lit | ForEach-Object { $_.at -join '/' }) | Should -Be @('automation')
        @($drawn.cells).Count | Should -Be 2
    }

    It 'keeps the whole computed data for the declaration writer' {
        $computed = Get-Content -Raw (Join-Path $script:root "out/minimaps/$script:folder/computed/layer-stack.json") | ConvertFrom-Json
        @($computed.lit | ForEach-Object { $_.at -join '/' }) | Should -Be @('automation', 'contract')
    }

    It 'reports the dropped cell' {
        "$($script:warned)" | Should -BeLike "*$script:folder*'layer-stack'*contract*"
        "$($script:warned)" | Should -Not -BeLike '*automation*'
    }

    It 'returns the folder''s output folder' {
        $script:target | Should -Be (Join-Path (Join-Path $script:root 'out/minimaps') $script:folder)
    }
}
