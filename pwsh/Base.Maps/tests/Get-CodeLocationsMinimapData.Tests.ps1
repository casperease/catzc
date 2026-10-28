Describe 'Get-CodeLocationsMinimapData' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/pwsh.base.maps/minimap.schema.json'))
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/private/Get-Cog.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'widgets'; module = 'Catzc.Widget' } }
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/private/Get-Sprocket.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'widgets'; module = 'Catzc.Widget' } }
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/Get-Widget.ps1'; Requested = 'ADR-GADGET'; Citations = @(); Facts = @{ track = 'widgets'; module = 'Catzc.Widget' } }
            [pscustomobject]@{ Path = 'gadgets/notes.md'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'gadgets' } }
            [pscustomobject]@{ Path = 'loose.txt'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = $null }
        }
    }

    It 'draws only the places a subject file sits in: track, module and folder, each lit by its files' {
        $data = Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET', 'ADR-GADGET'
        @($data.Axes | ForEach-Object Name) | Should -Be @('track', 'module', 'folder')
        @($data.Cells | ForEach-Object { $_.At -join ' / ' }) | Should -Be @('gadgets / - / .',
            'widgets / Catzc.Widget / .', 'widgets / Catzc.Widget / private')
        @($data.Lit | ForEach-Object { $_.Count }) | Should -Be @(1, 1, 2)
        $data.Lit[2].Reasons.Subject | Should -Be @('widgets/Catzc.Widget/private/Get-Cog.ps1',
            'widgets/Catzc.Widget/private/Get-Sprocket.ps1')
    }

    It 'gives every lit cell its reason and serializes to the minimap contract' {
        $data = Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET'
        @($data.Lit | Where-Object { $_.Reasons.Count -eq 0 }) | Should -BeNullOrEmpty
        Test-Json -Json (Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET' -AsJson) -Schema $script:schema | Should -BeTrue
    }

    It 'carries the rows its place list draws, computed beside the data, in the contract' {
        $data = Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET', 'ADR-GADGET'
        @($data.PlaceRows.Rows) | Should -Be @('gadgets', 'widgets.widget.(root)|private')
        $data.PlaceRows.Counters | Should -BeExactly '3 places'
        $json = Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET', 'ADR-GADGET' -AsJson
        Test-Json -Json $json -Schema $script:schema | Should -BeTrue
        ($json | ConvertFrom-Json).place_rows.counters | Should -BeExactly '3 places'
    }

    It 'places the drawing''s own glyphs first, the cited records'' places only while rows remain, and counts a label that names no file' {
        Mock Get-MinimapFact -ModuleName Catzc.Base.Maps {
            $facts = @{}
            foreach ($file in $Path) {
                $facts[$file] = @{ track = 'widgets'; module = 'Catzc.Widget.Cog' }
            }
            $facts
        }
        Mock Write-Message -ModuleName Catzc.Base.Maps { }
        $glyphs = @(
            [ordered]@{ kind = 'code'; label = 'Get-Sprocket' }
            [ordered]@{ kind = 'type'; label = 'SprocketConfig' }
            [ordered]@{ kind = 'code'; label = 'a plain phrase' }
        )
        $tracked = @('widgets/Catzc.Widget.Cog/Get-Sprocket.ps1', 'widgets/Catzc.Widget.Cog/types/SprocketConfig.cs')
        $data = Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET' -Glyph $glyphs -TrackedPath $tracked
        @($data.PlaceRows.Rows) | Should -Contain 'widgets.widget_cog.(root)|types'
        $data.PlaceRows.Counters | Should -BeExactly '5 places'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Maps -ParameterFilter { $Message -like '*2 of 3 glyph label(s) resolved to a repository place, 1 dropped*' }
    }

    It 'drops the docs places of the cited records when the drawing draws no doc' {
        Mock Get-MinimapSubject -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Path = 'docs/drs/widgets/rule.md'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'docs' } }
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/Get-Widget.ps1'; Requested = 'ADR-WIDGET'; Citations = @(); Facts = @{ track = 'widgets'; module = 'Catzc.Widget' } }
        }
        $data = Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET'
        @($data.PlaceRows.Rows) | Should -Be @('widgets.widget')
    }

    It 'hands the world map it is given to the subject' {
        $map = [Catzc.Base.Maps.WorldMapBuilder]::Build(@(), @(), @(),
            [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, [ordered]@{}, @())
        $null = Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET' -WorldMap $map
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($WorldMap, $map) }
    }

    It 'hands the facts it is given to the subject' {
        $given = @{ 'widgets/Catzc.Widget/Get-Widget.ps1' = @{ track = 'widgets' } }
        $null = Get-CodeLocationsMinimapData -Rule 'ADR-WIDGET' -Facts $given
        Should -Invoke Get-MinimapSubject -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter { [object]::ReferenceEquals($Facts, $given) }
    }
}
