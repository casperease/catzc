Describe 'WorldMapBuilder' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:tracks = @(
            [Catzc.Base.Variants.VariantTrack]::new('widgets', @('widgets'), 'modules', $null, @('widget-script', 'widget-config'))
            [Catzc.Base.Variants.VariantTrack]::new('gadgets', @('gadgets'), 'infrastructure', $null, @('widget-config'))
            [Catzc.Base.Variants.VariantTrack]::new('probes', @('probes'), 'verification', $null, @())
            [Catzc.Base.Variants.VariantTrack]::new('docs', @('docs'), 'documentation', $null, @('notes'))
            [Catzc.Base.Variants.VariantTrack]::new([Catzc.Base.Maps.WorldMapBuilder]::PipelinesTrack, @('pipelines'), 'pipelines', $null, @('gadget-pipe'))
        )
        $script:languages = @(
            [Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('widget-config', @('.yml'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('gadget-pipe', @('.yaml'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('notes', @('.md'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('probe-lang', @('.prb'), $null, 'fixture', $null, $null, $null)
        )
        $script:aspects = [ordered]@{
            widgets = @(
                [Catzc.Base.Variants.VariantAspect]::new('live', @('*.ps1', 'configs/**'))
                [Catzc.Base.Variants.VariantAspect]::new('tests', @('**'))
            )
        }
        $script:index = [ordered]@{ 'ADR-WIDGET-GADGET' = 'widgetry'; 'ADR-WIDGET-SPROCKET' = 'widgetry'; 'ADR-GIZMO-COG' = 'gizmos' }
        $script:texts = [ordered]@{
            'widgets/Alpha/Get-Widget.ps1'             = '# [ADR-WIDGET-GADGET#2](/docs/adr/widgetry/widget-gadget.md#rule-adr-widget-gadget2)'
            'widgets/Alpha/configs/alpha.yml'          = '# alpha (ADR-GIZMO-COG)'
            'widgets/Alpha/tests/Get-Widget.Tests.ps1' = '# ADR-GIZMO-COG#9'
            'gadgets/settings.yml'                     = 'gadget: true'
            'gadgets/notes.md'                         = 'A gadget note.'
            'docs/adr/widgetry/widget-gadget.md'       = '### Rule ADR-WIDGET-GADGET:2 (cites ADR-GIZMO-COG)'
            'docs/adr/index.md'                        = '- ADR-WIDGET-SPROCKET'
            'docs/guide.md'                            = 'Read ADR-WIDGET-SPROCKET.'
            'pipelines/ci-widgets.yaml'                = 'trigger: none'
            'pipelines/cd-gadgets.yaml'                = '# ADR-GIZMO-COG:4'
            'pipelines/lonely.yaml'                    = 'trigger: none'
            'probes/extra.ps1'                         = '# ADR-GIZMO-COG'
            'importer.ps1'                             = '# the entry point'
            'README.md'                                = 'See ADR-WIDGET-GADGET.'
        }
        $script:paths = @(
            'widgets/Alpha/Get-Widget.ps1'
            'widgets/Alpha/configs/alpha.yml'
            'widgets/Alpha/configs/alpha.json'
            'widgets/Alpha/configs/.gitkeep'
            'widgets/Alpha/tests/Get-Widget.Tests.ps1'
            'widgets/Alpha/tests/assets/beta.bicep'
            'widgets/.vendor/Thing/thing.json'
            'gadgets/settings.yml'
            'gadgets/notes.md'
            'probes/check.prb'
            'probes/extra.ps1'
            'docs/adr/widgetry/widget-gadget.md'
            'docs/adr/index.md'
            'docs/guide.md'
            'pipelines/ci-widgets.yaml'
            'pipelines/cd-gadgets.yaml'
            'pipelines/lonely.yaml'
            'importer.ps1'
            'README.md'
            'out/.gitkeep'
        )
        $script:adrFiles = [ordered]@{ 'ADR-WIDGET-GADGET' = 'docs/adr/widgetry/widget-gadget.md' }
        $script:globSets = @([Catzc.Base.Globs.GlobSet]::new('widgets-set', 'The widgets.', 'loose-fileset', @('widgets/**'), @(), @(), @(), -1, 'ci-widgets'))
        $script:build = {
            param([string[]] $Paths = $script:paths, $Tracks = $script:tracks, $Languages = $script:languages)
            [Catzc.Base.Maps.WorldMapBuilder]::Build($Tracks, $Languages, $Paths, $script:aspects, $script:index, $script:adrFiles, $script:texts,
                [ordered]@{ 'importer.ps1' = 'widgets/Alpha' }, $script:globSets)
        }
        $script:map = & $script:build
    }

    Context 'placement' {
        It 'places every file in exactly one cell' {
            $script:map.FileCount | Should -Be $script:paths.Count
            ($script:map.Cells | Measure-Object FileCount -Sum).Sum | Should -Be $script:paths.Count
            @($script:map.Placements.Path | Sort-Object -Unique).Count | Should -Be $script:paths.Count
            foreach ($placement in $script:map.Placements) {
                $script:map.Cell($placement.Track, $placement.FileLanguage) | Should -Not -BeNullOrEmpty -Because $placement.Path
            }
        }

        It 'takes the track from the root folder and the file language from the extension' {
            $placement = $script:map.Placement('widgets/Alpha/Get-Widget.ps1')
            $placement.Track | Should -Be 'widgets'
            $placement.FileLanguage | Should -Be 'widget-script'
            $script:map.Placement('widgets\Alpha\configs\alpha.yml').FileLanguage | Should -Be 'widget-config'
        }

        It 'counts a file with an unknown extension or none in the (other) column' {
            $script:map.Placement('widgets/Alpha/configs/alpha.json').FileLanguage | Should -Be ([Catzc.Base.Maps.WorldMap]::NoFileLanguage)
            $script:map.Placement('widgets/Alpha/configs/.gitkeep').FileLanguage | Should -Be ([Catzc.Base.Maps.WorldMap]::NoFileLanguage)
            $script:map.Cell('widgets', [Catzc.Base.Maps.WorldMap]::NoFileLanguage).FileCount | Should -Be 4
        }

        It 'places a repository-root file and out/ in the (no track) row' {
            foreach ($path in 'importer.ps1', 'README.md', 'out/.gitkeep') {
                $script:map.Placement($path).Track | Should -Be ([Catzc.Base.Maps.WorldMap]::NoTrack) -Because $path
            }
        }

        It 'orders the axes ordinally with the bucket last, and the cells row by row' {
            $script:map.Tracks | Should -Be @('docs', 'gadgets', 'pipelines', 'probes', 'widgets', '(no track)')
            $script:map.FileLanguages | Should -Be @('gadget-pipe', 'notes', 'probe-lang', 'widget-config', 'widget-script', '(other)')
            $script:map.Cells.Count | Should -Be 36
            $script:map.Cells[0].Track | Should -Be 'docs'
            $script:map.Cells[0].FileLanguage | Should -Be 'gadget-pipe'
            $script:map.Cells[6].Track | Should -Be 'gadgets'
            $script:map.Placements[0].Path | Should -Be 'README.md'
        }

        It 'builds the same map from any input order' {
            $shuffled = & $script:build -Paths ($script:paths | Sort-Object -Descending) -Tracks ($script:tracks[4..0]) -Languages ($script:languages[4..0])
            $shuffled.ToJson() | Should -BeExactly $script:map.ToJson()
        }

        It 'rejects a path listed twice' {
            { & $script:build -Paths @('docs/guide.md', 'docs/guide.md') } | Should -Throw "*'docs/guide.md' is placed twice*"
        }
    }

    Context 'stack check' {
        It 'flags a live file outside its track''s file languages, and only those' {
            @($script:map.StackViolations.Path) | Should -Be @('gadgets/notes.md', 'widgets/Alpha/configs/alpha.json')
            $script:map.Cell('widgets', '(other)').StackViolation | Should -BeTrue
            $script:map.Cell('gadgets', 'notes').StackViolation | Should -BeTrue
            @($script:map.Cells | Where-Object StackViolation).Count | Should -Be 2
        }

        It 'reads a track without an aspects entry as live throughout' {
            $script:map.Placement('gadgets/notes.md').Live | Should -BeTrue
        }

        It 'never flags a test-aspect file' {
            $placement = $script:map.Placement('widgets/Alpha/tests/assets/beta.bicep')
            $placement.Live | Should -BeFalse
            $placement.StackViolation | Should -BeFalse
        }

        It 'never flags a verification track or a vendored file' {
            foreach ($path in 'probes/extra.ps1', 'probes/check.prb', 'widgets/.vendor/Thing/thing.json') {
                $placement = $script:map.Placement($path)
                $placement.Live | Should -BeFalse -Because $path
                $placement.StackViolation | Should -BeFalse -Because $path
            }
        }

        It 'never flags a live file without an extension' {
            $placement = $script:map.Placement('widgets/Alpha/configs/.gitkeep')
            $placement.Live | Should -BeTrue
            $placement.StackViolation | Should -BeFalse
        }
    }

    Context 'highlight relation in the fixed order per artifact kind' {
        It 'gives an ADR''s own file that ADR''s code, not its citations' {
            $placement = $script:map.Placement('docs/adr/widgetry/widget-gadget.md')
            $placement.Basis | Should -Be 'adr-file'
            $placement.Adr | Should -Be 'ADR-WIDGET-GADGET'
            $placement.Citations | Should -BeNullOrEmpty
        }

        It 'gives a markdown file under docs/adr/ that is no ADR''s own file its citations' {
            $placement = $script:map.Placement('docs/adr/index.md')
            $placement.Basis | Should -Be 'citations'
            $placement.Adr | Should -BeNullOrEmpty
            $placement.Citations | Should -Be @('ADR-WIDGET-SPROCKET')
        }

        It 'gives module code its own citations' {
            $placement = $script:map.Placement('widgets/Alpha/Get-Widget.ps1')
            $placement.Basis | Should -Be 'citations'
            $placement.Citations | Should -Be @('ADR-WIDGET-GADGET#2')
        }

        It 'gives a repository-root file its files.yml owner''s citations, else its own' {
            $importer = $script:map.Placement('importer.ps1')
            $importer.Basis | Should -Be 'files.yml'
            $importer.Citations | Should -Be @('ADR-GIZMO-COG', 'ADR-GIZMO-COG#9', 'ADR-WIDGET-GADGET#2')
            $readme = $script:map.Placement('README.md')
            $readme.Basis | Should -Be 'citations'
            $readme.Citations | Should -Be @('ADR-WIDGET-GADGET')
        }

        It 'gives a pipeline its citations, else its globset''s, else nothing' {
            $cited = $script:map.Placement('pipelines/cd-gadgets.yaml')
            $cited.Basis | Should -Be 'citations'
            $cited.Citations | Should -Be @('ADR-GIZMO-COG#4')
            $bound = $script:map.Placement('pipelines/ci-widgets.yaml')
            $bound.Basis | Should -Be 'globset'
            $bound.Citations | Should -Be @('ADR-GIZMO-COG', 'ADR-GIZMO-COG#9', 'ADR-WIDGET-GADGET#2')
            $script:map.Placement('pipelines/lonely.yaml').Basis | Should -Be 'none'
        }

        It 'reads no citation from a file kind that does not cite' {
            $script:map.Placement('widgets/Alpha/configs/alpha.json').Basis | Should -Be 'none'
        }

        It 'reads no citation from a file a citation_exclude glob matches, and still places the file' {
            $map = [Catzc.Base.Maps.WorldMapBuilder]::Build($script:tracks, $script:languages, $script:paths, $script:aspects, $script:index,
                $script:adrFiles, $script:texts, [ordered]@{ 'importer.ps1' = 'widgets/Alpha' }, $script:globSets, @('docs/*.md', 'widgets/Alpha/tests/**'))
            $guide = $map.Placement('docs/guide.md')
            "$($guide.Track) x $($guide.FileLanguage) $($guide.Basis)" | Should -Be 'docs x notes none'
            $guide.Citations | Should -BeNullOrEmpty
            $guide.Sites | Should -BeNullOrEmpty
            $map.Placement('docs/adr/index.md').Citations | Should -Be @('ADR-WIDGET-SPROCKET')
            $map.Placement('importer.ps1').Citations | Should -Be @('ADR-GIZMO-COG', 'ADR-WIDGET-GADGET#2')
            $map.Placement('docs/adr/widgetry/widget-gadget.md').Basis | Should -Be 'adr-file'
        }
    }

    Context 'data form' {
        It 'emits the JSON shape: axes, count, cells and files' {
            $json = $script:map.ToJson()
            $json | Should -Not -Match "`r"
            $data = $json | ConvertFrom-Json
            @($data.PSObject.Properties.Name) | Should -Be @('tracks', 'file_languages', 'file_count', 'cells', 'files')
            $data.file_count | Should -Be $script:paths.Count
            @($data.cells).Count | Should -Be 36
            @($data.cells[0].PSObject.Properties.Name) | Should -Be @('track', 'file_language', 'file_count', 'stack_violation')
            @($data.files[0].PSObject.Properties.Name) | Should -Be @('path', 'track', 'file_language', 'live', 'stack_violation', 'basis', 'adr', 'citations')
            ($data.files | Where-Object path -EQ 'importer.ps1').citations | Should -Be @('ADR-GIZMO-COG', 'ADR-GIZMO-COG#9', 'ADR-WIDGET-GADGET#2')
        }

        It 'renders console-ready' {
            "$($script:map)" | Should -BeLike 'WorldMap {*FileCount = 20*'
            "$($script:map.Cells[0])" | Should -BeLike 'MapCell {*Track = docs*'
            "$($script:map.Placements[0])" | Should -BeLike 'MapPlacement {*Path = README.md*'
        }
    }
}
