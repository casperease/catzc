Describe 'Get-ModuleNeighbourhoodMinimapData' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.0.0/catzc.base.maps/minimap.schema.json'))
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'dependencies' } {
            [pscustomobject]@{
                groups  = [ordered]@{ Base = [pscustomobject]@{ members = [ordered]@{ Asserts = @(); Widgets = @('Asserts') } } }
                modules = [ordered]@{ Gadgets = @('Widgets', 'Asserts'); Gizmos = @('Gadgets') }
            }
        }
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Path = (Get-CatzcModulesFolder) + '/Widgets/Get-Widget.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ module = 'Widgets'; moduletype = 'pwsh-folder' } }
            [pscustomobject]@{ Path = 'docs/widget.md'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'docs' } }
        }
    }

    It 'lights the subject''s modules and places their dependencies and dependents around them' {
        $data = Get-ModuleNeighbourhoodMinimapData -Adr 'ADR-WIDGET'
        $data.Axes[0].Values | Should -Be @('subject', 'depends-on', 'used-by')
        @($data.Cells | ForEach-Object { $_.At -join ' x ' }) | Should -Be @('subject x Widgets', 'depends-on x Asserts', 'used-by x Gadgets')
        @($data.Lit | ForEach-Object { $_.At -join ' x ' }) | Should -Be @('subject x Widgets')
        $data.Lit[0].Reasons[0].Note | Should -Be 'pwsh-folder'
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }

    It 'hands the world map it is given to the subject' {
        $map = [Catzc.Base.Maps.WorldMapBuilder]::Build(@(), @(), @(), [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, @())
        $null = Get-ModuleNeighbourhoodMinimapData -Adr 'ADR-WIDGET' -WorldMap $map
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($WorldMap, $map) }
    }

    It 'hands the facts it is given to the subject' {
        $given = @{ 'widgets/Catzc.Widget/Get-Widget.ps1' = @{ track = 'widgets' } }
        $null = Get-ModuleNeighbourhoodMinimapData -Adr 'ADR-WIDGET' -Facts $given
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($Facts, $given) }
    }
}
