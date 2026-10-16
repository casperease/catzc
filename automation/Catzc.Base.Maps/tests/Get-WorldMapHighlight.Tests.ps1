<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
    folder: tests
    name: get-world-map-highlight-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-DSGN-TRACK#12
      - ADR-FLOW-CD
---
#>

Describe 'Get-WorldMapHighlight' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:map = [Catzc.Base.Maps.WorldMapBuilder]::Build(
            @([Catzc.Base.Variants.VariantTrack]::new('widgets', @('widgets'), 'modules', $null, @('widget-script')),
                [Catzc.Base.Variants.VariantTrack]::new('gadgets', @('gadgets'), 'infrastructure', $null, @('widget-script'))),
            @([Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null, $null)),
            @('widgets/Alpha/Get-Widget.ps1', 'widgets/Beta/Get-Gadget.ps1', 'README.md'),
            [ordered]@{}, [ordered]@{ 'ADR-WIDGET-GADGET' = 'widgetry' }, [ordered]@{}, [ordered]@{ 'widgets/Alpha/Get-Widget.ps1' = '# ADR-WIDGET-GADGET' },
            [ordered]@{}, @())
        $script:maps = [Catzc.Base.Maps.MapsConfig]::new([ordered]@{
                highlight = [ordered]@{
                    pins = @([ordered]@{ adr = 'ADR-WIDGET-GADGET#1'; track = 'gadgets'; file_language = 'widget-script'; reason = 'reviewed gadget mention' })
                }
            })
    }

    BeforeEach {
        Mock Get-WorldMap -ModuleName Catzc.Base.Maps { $script:map }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } { $script:maps }
    }

    It 'lights the cells of an ADR code given by position, with the maps.yml pins applied' {
        $highlight = Get-WorldMapHighlight ADR-WIDGET-GADGET
        $highlight | Should -BeOfType [Catzc.Base.Maps.WorldMapHighlight]
        @($highlight.Cells | ForEach-Object { "$($_.Track) x $($_.FileLanguage)" }) | Should -Be @('gadgets x widget-script', 'widgets x widget-script')
        $highlight.Cells[0].Sources | Should -Be @('pin')
    }

    It 'lights the cells of the given files' {
        $highlight = Get-WorldMapHighlight -Path 'widgets/Beta/Get-Gadget.ps1'
        $highlight.Kind | Should -Be 'path'
        $highlight.Cells[0].Files | Should -Be @('widgets/Beta/Get-Gadget.ps1')
    }

    It 'lights the cells of the working tree''s changes on the zero-argument call, skipping a file the map does not hold' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Maps { @('README.md', 'widgets/Beta/Get-Gadget.ps1', 'widgets/Gamma/New-Widget.ps1') }
        $highlight = Get-WorldMapHighlight
        $highlight.Kind | Should -Be 'path'
        $highlight.Requested | Should -Be @('README.md', 'widgets/Beta/Get-Gadget.ps1')
        @($highlight.Cells | ForEach-Object { "$($_.Track) x $($_.FileLanguage)" }) | Should -Be @('widgets x widget-script', '(no track) x (other)')
        Should -Invoke Get-GitChangedPath -ModuleName Catzc.Base.Maps -Times 1 -Exactly
    }

    It 'lights nothing on the zero-argument call when nothing changed' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Maps { @() }
        $highlight = Get-WorldMapHighlight
        $highlight.Requested | Should -BeNullOrEmpty
        $highlight.Cells | Should -BeNullOrEmpty
    }

    It 'does not read the working tree when -Adr or -Path is given' {
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Maps { @('README.md') }
        $null = Get-WorldMapHighlight -Adr 'ADR-WIDGET-GADGET'
        $null = Get-WorldMapHighlight -Path 'README.md'
        Should -Invoke Get-GitChangedPath -ModuleName Catzc.Base.Maps -Times 0 -Exactly
    }

    It 'emits JSON with -AsJson' {
        $data = Get-WorldMapHighlight -Adr 'ADR-WIDGET-GADGET' -AsJson | ConvertFrom-Json
        $data.kind | Should -Be 'adr'
        @($data.cells).Count | Should -Be 2
    }

    It 'throws on an unknown code' {
        { Get-WorldMapHighlight -Adr 'ADR-WIDGET-UNKNOWN' } | Should -Throw "*'ADR-WIDGET-UNKNOWN' is not an ADR code*"
    }
}

Describe 'Get-WorldMapHighlight — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'lights at least one cell for ADR-FLOW-CD' {
        @((Get-WorldMapHighlight -Adr 'ADR-FLOW-CD').Cells).Count | Should -BeGreaterThan 0
    }

    It 'lights, as an ADR file, only the requested ADR''s own file' -Tag 'ADR-DSGN-TRACK#12' {
        $citations = Get-AdrCitationMap
        # Codes taken from the registry, not spelled here, so this test cites no ADR and lights no minimap itself.
        $ruleSets = @(Get-AdrRuleSet | Where-Object { $citations.PathOf($_.External) })
        $codes = @($ruleSets[0].External, "$($ruleSets[1].External)#1", $ruleSets[-1].External)
        $reasons = @((Get-WorldMapHighlight -Adr $codes).Cells.Reasons | Where-Object Basis -EQ 'adr-file')
        @($reasons).Count | Should -Be $codes.Count
        foreach ($reason in $reasons) {
            $reason.Path | Should -Be $citations.PathOf([Catzc.Base.Maps.CitationScanner]::CodeOf($reason.Requested)) -Because $reason.Requested
        }
    }

    It 'returns the working tree''s highlight on the zero-argument call without error' {
        $highlight = Get-WorldMapHighlight
        $highlight | Should -BeOfType [Catzc.Base.Maps.WorldMapHighlight]
        $highlight.Kind | Should -Be 'path'
    }
}
