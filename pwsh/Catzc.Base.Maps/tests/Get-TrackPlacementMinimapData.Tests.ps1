Describe 'Get-TrackPlacementMinimapData' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.0.0/Catzc.Base.Maps/minimap.schema.json'))
        Mock Get-Track -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Variants.VariantTrack]::new('widgets', @('widgets'), 'modules', $null, @('widget-script'))
            [Catzc.Base.Variants.VariantTrack]::new('gadgets', @('gadgets'), 'modules', 'gizmo', @('widget-script'))
            [Catzc.Base.Variants.VariantTrack]::new('docs', @('docs'), 'documentation', $null, @('notes'))
        }
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Path = 'gadgets/Get-Gadget.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'gadgets'; tracktype = 'modules'; vendor = 'gizmo' } }
            [pscustomobject]@{ Path = 'importer.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ language = 'widget-script' } }
        }
    }

    It 'lights the track each subject file sits in, under its track type, with its vendor' {
        $data = Get-TrackPlacementMinimapData -Adr 'ADR-WIDGET'
        $data.Axes[0].Values | Should -Be @('modules', 'documentation')
        $data.Cells | Should -HaveCount 3
        @($data.Lit | ForEach-Object { $_.At -join ' x ' }) | Should -Be @('modules x gadgets')
        $data.Lit[0].Reasons[0].Note | Should -Be 'gizmo'
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }
}
