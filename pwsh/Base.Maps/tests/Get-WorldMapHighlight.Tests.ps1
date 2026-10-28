Describe 'Get-WorldMapHighlight' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:map = [Catzc.Base.Maps.WorldMapBuilder]::Build(
            @([Catzc.Base.Variants.VariantTrack]::new('widgets', @('widgets'), 'modules', $null, @('widget-script')),
                [Catzc.Base.Variants.VariantTrack]::new('gadgets', @('gadgets'), 'infrastructure', $null,
                    @('widget-script'))),
            @([Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null,
                    $null)),
            @('widgets/Alpha/Get-Widget.ps1', 'widgets/Beta/Get-Gadget.ps1', 'README.md'),
            [ordered]@{}, [ordered]@{ 'ADR-WIDGET-GADGET' = 'widgetry' }, [ordered]@{}, [ordered]@{ 'widgets/Alpha/Get-Widget.ps1' = '# ADR-WIDGET-GADGET' },
            [ordered]@{}, @())
        $script:maps = [Catzc.Base.Maps.MapsConfig]::new([ordered]@{
                highlight = [ordered]@{
                    pins = @([ordered]@{ rule = 'ADR-WIDGET-GADGET-TURN'; track = 'gadgets'; file_language = 'widget-script'; reason = 'reviewed gadget mention' })
                }
            })
    }

    BeforeEach {
        Mock Get-WorldMap -ModuleName Catzc.Base.Maps { $script:map }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } { $script:maps }
    }

    It 'lights the cells of a rule code given by position, with the maps.yml pins applied' {
        $highlight = Get-WorldMapHighlight ADR-WIDGET-GADGET
        $highlight | Should -BeOfType [Catzc.Base.Maps.WorldMapHighlight]
        @($highlight.Cells | ForEach-Object { "$($_.Track) x $($_.FileLanguage)" }) |
            Should -Be @('gadgets x widget-script', 'widgets x widget-script')
        $highlight.Cells[0].Sources | Should -Be @('pin')
    }

    It 'lights the cells on the world map it is given, without building one' {
        $highlight = Get-WorldMapHighlight ADR-WIDGET-GADGET -WorldMap $script:map
        @($highlight.Cells | ForEach-Object { "$($_.Track) x $($_.FileLanguage)" }) |
            Should -Be @('gadgets x widget-script', 'widgets x widget-script')
        Should -Invoke Get-WorldMap -ModuleName Catzc.Base.Maps -Times 0 -Exactly
    }

    It 'lights the cells of the given files' {
        $highlight = Get-WorldMapHighlight -Path 'widgets/Beta/Get-Gadget.ps1'
        $highlight.Kind | Should -Be 'path'
        $highlight.Cells[0].Files | Should -Be @('widgets/Beta/Get-Gadget.ps1')
    }

    It 'lights the cells of the working tree''s changes on the zero-argument call, skipping a file the map does not hold' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Maps { @('README.md', 'widgets/Beta/Get-Gadget.ps1',
                'widgets/Gamma/New-Widget.ps1') }
        $highlight = Get-WorldMapHighlight
        $highlight.Kind | Should -Be 'path'
        $highlight.Requested | Should -Be @('README.md', 'widgets/Beta/Get-Gadget.ps1')
        @($highlight.Cells | ForEach-Object { "$($_.Track) x $($_.FileLanguage)" }) |
            Should -Be @('widgets x widget-script', '(no track) x (other)')
        Should -Invoke Get-GitChangedPath -ModuleName Catzc.Base.Maps -Times 1 -Exactly
    }

    It 'lights nothing on the zero-argument call when nothing changed' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Maps { @() }
        $highlight = Get-WorldMapHighlight
        $highlight.Requested | Should -BeNullOrEmpty
        $highlight.Cells | Should -BeNullOrEmpty
    }

    It 'does not read the working tree when -Rule or -Path is given' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Maps { @('README.md') }
        $null = Get-WorldMapHighlight -Rule 'ADR-WIDGET-GADGET'
        $null = Get-WorldMapHighlight -Path 'README.md'
        Should -Invoke Get-GitChangedPath -ModuleName Catzc.Base.Maps -Times 0 -Exactly
    }

    It 'emits JSON with -AsJson' {
        $data = Get-WorldMapHighlight -Rule 'ADR-WIDGET-GADGET' -AsJson | ConvertFrom-Json
        $data.kind | Should -Be 'record'
        @($data.cells).Count | Should -Be 2
    }

    It 'throws on an unknown code' {
        { Get-WorldMapHighlight -Rule 'ADR-WIDGET-UNKNOWN' } | Should -Throw "*'ADR-WIDGET-UNKNOWN' is not a record code*"
    }
}

Describe 'Get-WorldMapHighlight — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'lights at least one cell for FDR-CD' {
        @((Get-WorldMapHighlight -Rule 'FDR-CD').Cells).Count | Should -BeGreaterThan 0
    }

    It 'lights, as a record file, only the requested record''s own file' -Tag 'DDR-TRACK-LITCELL' {
        $citations = Get-DrsCitationMap
        # Codes taken from the registry, not spelled here, so this test cites no record and lights no minimap itself.
        $ruleSets = @(Get-DrsRuleSet | Where-Object { $citations.PathOf($_.External) -and $citations.RulesOf($_.External).Count -gt 0 })
        $codes = @($ruleSets[0].External, $citations.RulesOf($ruleSets[1].External)[0], $ruleSets[-1].External)
        $reasons = @((Get-WorldMapHighlight -Rule $codes).Cells.Reasons | Where-Object Basis -EQ 'record-file')
        @($reasons).Count | Should -Be $codes.Count
        foreach ($reason in $reasons) {
            $reason.Path | Should -Be $citations.PathOf($reason.Requested) -Because $reason.Requested
        }
    }

}

# The zero-argument call reads the real working tree with git status, so the point of this one is the launch: L2.
Describe 'Get-WorldMapHighlight — the real working tree' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:skip = if (Get-Command git -ErrorAction Ignore) {
            $null
        }
        else {
            'tool_git_missing'
        }
    }

    It 'returns the working tree''s highlight on the zero-argument call without error' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $highlight = Get-WorldMapHighlight
        $highlight | Should -BeOfType [Catzc.Base.Maps.WorldMapHighlight]
        $highlight.Kind | Should -Be 'path'
    }
}
