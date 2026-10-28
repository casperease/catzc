Describe 'Get-EngineStripMinimapData' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/pwsh.base.maps/minimap.schema.json'))
        Mock Get-FileLanguage -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('gadget-shell', @('.sh'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('notes', @('.md'), $null, 'fixture', $null, $null, $null)
        }
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Path = 'widgets/Get-Widget.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ language = 'widget-script'; module = 'Widgets' } }
            [pscustomobject]@{ Path = 'tests/gadget.sh'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ language = 'gadget-shell' } }
            [pscustomobject]@{ Path = 'docs/widget.md'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ language = 'notes' } }
        }
    }

    It 'lights each engine beside the script language a subject file is written in' {
        $data = Get-EngineStripMinimapData -Rule 'ADR-WIDGET'
        $data.Axes[0].Values | Should -Be @([Catzc.Base.Engines.ExecutionEngines]::Names)
        $data.Axes[1].Values | Should -Not -Contain 'notes'
        $lit = @($data.Lit | ForEach-Object { $_.At -join ' x ' })
        $lit | Should -Contain 'pwsh x widget-script'
        $lit | Should -Contain 'bash x gadget-shell'
        ($data.Lit | Where-Object { $_.At[1] -eq 'widget-script' }).Reasons[0].Note | Should -Be 'Widgets'
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }

    It 'hands the world map it is given to the subject' {
        $map = [Catzc.Base.Maps.WorldMapBuilder]::Build(@(), @(), @(),
            [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, @())
        $null = Get-EngineStripMinimapData -Rule 'ADR-WIDGET' -WorldMap $map
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($WorldMap, $map) }
    }

    It 'hands the facts it is given to the subject' {
        $given = @{ 'widgets/Catzc.Widget/Get-Widget.ps1' = @{ track = 'widgets' } }
        $null = Get-EngineStripMinimapData -Rule 'ADR-WIDGET' -Facts $given
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($Facts, $given) }
    }
}
