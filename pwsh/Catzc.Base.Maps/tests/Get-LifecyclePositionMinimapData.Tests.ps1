Describe 'Get-LifecyclePositionMinimapData' -Tag 'L0', 'logic', 'FDR-CD-RUNGSREGISTRY' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/catzc.base.maps/minimap.schema.json'))
        $script:subject = { param([string] $Path,
                [string[]] $Citations) [pscustomobject]@{ Path = $Path; Requested = 'ADR-WIDGET'; Citations = $Citations; Facts = $null } }
        Mock Get-Rung -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Flow.Rung]::new('widget-uat', 'widget', 'none', @('ADR-WIDGET-GADGET-SPIN'))
            [Catzc.Base.Flow.Rung]::new('gadget-uat', 'gadget', 'rc', @('ADR-WIDGET-GADGET-FOLD'))
            [Catzc.Base.Flow.Rung]::new('gizmo', 'gizmo', 'rbc', @('ADR-WIDGET-COG-TURN'))
        }
    }

    It 'lights a cell per rung from the cites edges of the subject''s files' {
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            & $script:subject 'widgets/Get-Widget.ps1' @('ADR-WIDGET-GADGET-SPIN')
            & $script:subject 'widgets/Set-Widget.ps1' @('ADR-WIDGET-COG-TURN')
        }
        $data = Get-LifecyclePositionMinimapData -Adr 'ADR-WIDGET'
        $data.Axes[0].Values | Should -Be @('widget-uat', 'gadget-uat', 'gizmo')
        @($data.Lit | ForEach-Object { $_.At[0] }) | Should -Be @('widget-uat', 'gizmo')
        $data.Lit[0].Reasons[0].Subject | Should -Be 'widgets/Get-Widget.ps1'
        $data.Lit[0].Reasons[0].Note | Should -Be 'ADR-WIDGET-GADGET-SPIN'
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }

    It 'lights every rung whose rule sits under a cited ADR' {
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps { & $script:subject 'docs/widget.md' @('ADR-WIDGET-GADGET') }
        @((Get-LifecyclePositionMinimapData -Adr 'ADR-WIDGET').Lit | ForEach-Object { $_.At[0] }) |
            Should -Be @('widget-uat', 'gadget-uat')
    }

    It 'lights nothing for a subject that cites no rung''s rule, and still draws every rung' {
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps { & $script:subject 'docs/widget.md' @('ADR-GIZMO') }
        $data = Get-LifecyclePositionMinimapData -Adr 'ADR-GIZMO'
        $data.Lit | Should -HaveCount 0
        $data.Cells | Should -HaveCount 3
    }

    It 'hands the world map it is given to the subject' {
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps { & $script:subject 'docs/widget.md' @('ADR-GIZMO') }
        $map = [Catzc.Base.Maps.WorldMapBuilder]::Build(@(), @(), @(),
            [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, @())
        $null = Get-LifecyclePositionMinimapData -Adr 'ADR-GIZMO' -WorldMap $map
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($WorldMap, $map) }
    }

    It 'hands the facts it is given to the subject' {
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps { & $script:subject 'docs/widget.md' @('ADR-GIZMO') }
        $given = @{ 'docs/widget.md' = @{ track = 'docs' } }
        $null = Get-LifecyclePositionMinimapData -Adr 'ADR-GIZMO' -Facts $given
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($Facts, $given) }
    }
}
