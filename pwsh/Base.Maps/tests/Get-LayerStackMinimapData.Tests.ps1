Describe 'Get-LayerStackMinimapData' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/pwsh.base.maps/minimap.schema.json'))
        Mock Get-DrsRuleSet -ModuleName Catzc.Base.Maps {
            $concerns = [string[]] @('alpha')
            [Catzc.Base.Drs.DrsRuleSet]::new('widgetry', 'fixture', 'widget', 'ADR-WIDGET-GADGET', 'WIDGET', 'WIDGET',
                'TOP', $concerns, $concerns, 'engine', $null)
            [Catzc.Base.Drs.DrsRuleSet]::new('widgetry', 'fixture', 'widget', 'ADR-WIDGET-GADGET-LONG', 'WIDGET',
                'WIDGET', 'TOP', $concerns, $concerns, 'importer', $null)
        }
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Path = 'widgets/Get-Widget.ps1'; Requested = 'ADR-WIDGET-GADGET-SPIN'; Citations = @(); Facts = $null }
            [pscustomobject]@{ Path = 'widgets/Set-Widget.ps1'; Requested = 'ADR-WIDGET-GADGET-LONG-FOLD'; Citations = @(); Facts = $null }
            [pscustomobject]@{ Path = 'docs/gizmo.md'; Requested = 'ADR-GIZMO'; Citations = @(); Facts = $null }
        }
    }

    It 'lights the layer of the ADR each requested code belongs to, the longest code winning' {
        $data = Get-LayerStackMinimapData -Adr 'ADR-WIDGET'
        $data.Axes[0].Values | Should -Be @([Catzc.Base.Drs.DrsConfig]::Layers)
        @($data.Lit | ForEach-Object { $_.At[0] }) | Should -Be @('engine', 'importer')
        $data.Lit[1].Reasons[0].Note | Should -Be 'ADR-WIDGET-GADGET-LONG'
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }

    It 'hands the world map it is given to the subject' {
        $map = [Catzc.Base.Maps.WorldMapBuilder]::Build(@(), @(), @(),
            [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, @())
        $null = Get-LayerStackMinimapData -Adr 'ADR-WIDGET' -WorldMap $map
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($WorldMap, $map) }
    }

    It 'hands the facts it is given to the subject' {
        $given = @{ 'widgets/Catzc.Widget/Get-Widget.ps1' = @{ track = 'widgets' } }
        $null = Get-LayerStackMinimapData -Adr 'ADR-WIDGET' -Facts $given
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($Facts, $given) }
    }
}
