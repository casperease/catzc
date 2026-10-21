<#
---
catzc:
  immutable:
    with_body_sha: a63e94e0dd4b
  edges:
    code: pwsh/Catzc.Base.Maps/types/MapsConfig.cs
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
---
#>

Describe 'MapsConfig' -Tag 'L0' {
    BeforeAll {
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Base.Maps.MapsConfig]::new($raw) }
        $script:times = [string][char]0x00D7
        $script:arrow = [string][char]0x2192
        $script:pin = { [ordered]@{ adr = 'ADR-WIDGET-GADGET-FOLD'; track = 'widgets'; file_language = 'gadget-script'; reason = 'reviewed widget mention' } }
    }

    Context 'integrity (shipped maps.yml)' -Tag 'L1', 'integrity' {
        It 'constructs from the shipped maps.yml' {
            Get-Config -Config maps | Should -BeOfType [Catzc.Base.Maps.MapsConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'applies every default on an empty file' {
            foreach ($raw in @([ordered]@{}, $null)) {
                $config = & $script:make $raw
                $config.palette.background | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultBackground)
                $config.palette.row | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultRow)
                $config.palette.column | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultColumn)
                $config.palette.cell | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultCell)
                $config.palette.shade | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultShade)
                $config.palette.line | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultLine)
                $config.palette.text | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultText)
                $config.palette.violation | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultViolation)
                $config.palette.highlight | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultHighlight)
                $config.limits.page_width | Should -Be ([Catzc.Base.Maps.MapsLimits]::DefaultPageWidth)
                $config.limits.page_height | Should -Be ([Catzc.Base.Maps.MapsLimits]::DefaultPageHeight)
                $config.limits.min_font_size | Should -Be ([Catzc.Base.Maps.MapsLimits]::DefaultMinFontSize)
                $config.limits.max_row_label | Should -Be ([Catzc.Base.Maps.MapsLimits]::DefaultMaxRowLabel)
                $config.limits.max_column_label | Should -Be ([Catzc.Base.Maps.MapsLimits]::DefaultMaxColumnLabel)
                $config.labels.grid_title | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultGridTitle)
                $config.labels.tree_title | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultTreeTitle)
                $config.labels.row_axis | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultRowAxis)
                $config.labels.column_axis | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultColumnAxis)
                $config.labels.root_files | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultRootFiles)
                $config.labels.unlisted_files | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultUnlistedFiles)
                $config.labels.legend_files | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultLegendFiles)
                $config.labels.legend_violation | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultLegendViolation)
                $config.labels.legend_highlight | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultLegendHighlight)
                $config.labels.value_chain_title | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultValueChainTitle)
                $config.labels.value_chain_row_axis | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultValueChainRowAxis)
                $config.labels.value_chain_column_axis | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultValueChainColumnAxis)
                $config.labels.value_chain_legend_adrs | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultValueChainLegendAdrs)
                $config.labels.value_chain_legend_highlight | Should -Be ([Catzc.Base.Maps.MapsLabels]::DefaultValueChainLegendHighlight)
                $config.highlight.pins.Count | Should -Be 0
                $config.highlight.exceptions.Count | Should -Be 0
                $config.highlight.citation_exclude | Should -Be @([Catzc.Base.Maps.MapsHighlight]::DefaultCitationExclude)
                $config.highlight.citation_exclude | Should -Be @('.claude/hindsight/**', '.claude/learnings/**', 'docs/.assets/**', 'docs/explanation/**', 'python/catzc_diagrams/**')
                $config.output_folder | Should -Be ([Catzc.Base.Maps.MapsConfig]::DefaultOutputFolder)
            }
        }

        It 'applies the defaults of an omitted key inside a given section' {
            $config = & $script:make ([ordered]@{ palette = [ordered]@{ cell = '#AABBCC' }; limits = [ordered]@{ page_width = 600 } })
            $config.palette.cell | Should -Be '#AABBCC'
            $config.palette.row | Should -Be ([Catzc.Base.Maps.MapsPalette]::DefaultRow)
            $config.limits.page_width | Should -Be 600
            $config.limits.page_height | Should -Be ([Catzc.Base.Maps.MapsLimits]::DefaultPageHeight)
        }

        It 'reads every key it is given' {
            $config = & $script:make ([ordered]@{
                    palette       = [ordered]@{
                        background = '#0A0B0C'; row = '#010203'; column = '#040506'; cell = '#070809'; shade = '#102030'; line = '#405060'
                        text = '#708090'; violation = '#A0B0C0'; highlight = '#abcdef'
                    }
                    limits        = [ordered]@{ page_width = 595.5; page_height = 842; min_font_size = 4.5; max_row_label = 12; max_column_label = 8 }
                    labels        = [ordered]@{
                        grid_title = "Widgets $script:times gadgets"; tree_title = 'Widget tree'; row_axis = 'Widget'; column_axis = 'Gadget'
                        root_files = 'Top widgets'; unlisted_files = 'Gizmos'; legend_files = 'Widgets per cell'
                        legend_violation = 'Gadget clash'; legend_highlight = 'Lit widget'
                        value_chain_title = 'Gadget chain: widgets'; value_chain_row_axis = 'Widget rank'
                        value_chain_column_axis = 'Gadget step, longer than any world-map limit'; value_chain_legend_adrs = 'Gadget: widgets'
                        value_chain_legend_highlight = 'Lit gadget'
                    }
                    highlight     = [ordered]@{ pins = @(& $script:pin); exceptions = @(& $script:pin); citation_exclude = @('widgets/**/*.md') }
                    output_folder = 'widget-map'
                })
            $config.palette.highlight | Should -Be '#ABCDEF'
            $config.palette.background | Should -Be '#0A0B0C'
            $config.palette.shade | Should -Be '#102030'
            $config.palette.violation | Should -Be '#A0B0C0'
            $config.limits.page_width | Should -Be 595.5
            $config.limits.min_font_size | Should -Be 4.5
            $config.limits.max_column_label | Should -Be 8
            $config.labels.grid_title | Should -Be "Widgets $script:times gadgets"
            $config.labels.column_axis | Should -Be 'Gadget'
            $config.labels.root_files | Should -Be 'Top widgets'
            $config.labels.unlisted_files | Should -Be 'Gizmos'
            $config.labels.legend_highlight | Should -Be 'Lit widget'
            $config.labels.value_chain_title | Should -Be 'Gadget chain: widgets'
            $config.labels.value_chain_row_axis | Should -Be 'Widget rank'
            $config.labels.value_chain_column_axis | Should -Be 'Gadget step, longer than any world-map limit'
            $config.labels.value_chain_legend_adrs | Should -Be 'Gadget: widgets'
            $config.labels.value_chain_legend_highlight | Should -Be 'Lit gadget'
            $config.highlight.pins[0] | Should -BeOfType [Catzc.Base.Maps.MapsPin]
            $config.highlight.pins[0].adr | Should -Be 'ADR-WIDGET-GADGET-FOLD'
            $config.highlight.pins[0].track | Should -Be 'widgets'
            $config.highlight.pins[0].file_language | Should -Be 'gadget-script'
            $config.highlight.exceptions[0].reason | Should -Be 'reviewed widget mention'
            $config.highlight.citation_exclude | Should -Be @('widgets/**/*.md')
            $config.output_folder | Should -Be 'widget-map'
        }

        It 'throws on an unknown key, at the top and in each section' {
            $err = { & $script:make ([ordered]@{
                        gadgets   = 1
                        palette   = [ordered]@{ border = '#000000' }
                        limits    = [ordered]@{ page_depth = 1 }
                        labels    = [ordered]@{ subtitle = 'Widget' }
                        highlight = [ordered]@{ pinned = @() }
                    }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'gadgets'*"
            $err.Exception.Message | Should -BeLike "*palette: unknown key 'border'*"
            $err.Exception.Message | Should -BeLike "*limits: unknown key 'page_depth'*"
            $err.Exception.Message | Should -BeLike "*labels: unknown key 'subtitle'*"
            $err.Exception.Message | Should -BeLike "*highlight: unknown key 'pinned'*"
        }

        It 'throws on a citation_exclude that is not a list of repository-relative globs' {
            { & $script:make ([ordered]@{ highlight = [ordered]@{ citation_exclude = 'widgets/**' } }) } |
                Should -Throw '*highlight.citation_exclude must be a list of globs*'
            { & $script:make ([ordered]@{ highlight = [ordered]@{ citation_exclude = @('/widgets/**', 'gadgets\notes.md') } }) } |
                Should -Throw "*citation_exclude[[]0]: '/widgets/**' is not a repository-relative glob*citation_exclude[[]1]*"
        }

        It 'throws on a section that is not a mapping' {
            { & $script:make ([ordered]@{ palette = '#000000' }) } | Should -Throw '*palette must be a mapping*'
            { & $script:make ([ordered]@{ limits = @(1, 2) }) } | Should -Throw '*limits must be a mapping*'
        }

        It 'throws on a colour that is not a # and six hex digits' {
            $err = { & $script:make ([ordered]@{ palette = [ordered]@{ row = 'widget'; column = '#FFF'; cell = 'FFFFFF'; highlight = '#GGGGGG' } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*palette.row: invalid colour 'widget'*"
            $err.Exception.Message | Should -BeLike "*palette.column: invalid colour '#FFF'*"
            $err.Exception.Message | Should -BeLike "*palette.cell: invalid colour 'FFFFFF'*"
            $err.Exception.Message | Should -BeLike "*palette.highlight: invalid colour '#GGGGGG'*"
        }

        It 'throws on a size that is zero, negative or not a number' {
            $err = { & $script:make ([ordered]@{ limits = [ordered]@{ page_width = 0; page_height = -10; min_font_size = 'widget' } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*limits.page_width: '0' is not a positive number*"
            $err.Exception.Message | Should -BeLike "*limits.page_height: '-10' is not a positive number*"
            $err.Exception.Message | Should -BeLike "*limits.min_font_size: 'widget' is not a positive number*"
        }

        It 'throws on a label length that is not a positive whole number' {
            $err = { & $script:make ([ordered]@{ limits = [ordered]@{ max_row_label = 0; max_column_label = 2.5 } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*limits.max_row_label: '0' is not a positive whole number*"
            $err.Exception.Message | Should -BeLike "*limits.max_column_label: '2.5' is not a positive whole number*"
        }

        It 'throws on a label that is not WinAnsi-encodable, naming the character' {
            { & $script:make ([ordered]@{ labels = [ordered]@{ grid_title = "Widgets $script:arrow gadgets" } }) } |
                Should -Throw '*labels.grid_title: *cannot show: U+2192 at 8*'
            { & $script:make ([ordered]@{ labels = [ordered]@{ tree_title = "Widget$([char]0x0A)gadget" } }) } |
                Should -Throw '*labels.tree_title: *cannot show: U+000A at 6*'
        }

        It 'accepts a WinAnsi label outside ASCII' {
            (& $script:make ([ordered]@{ labels = [ordered]@{ grid_title = "Widgets $script:times gadgets" } })).labels.grid_title |
                Should -Be "Widgets $script:times gadgets"
        }

        It 'throws on an empty label and on a row or column header longer than its limit' {
            $err = { & $script:make ([ordered]@{
                        limits = [ordered]@{ max_row_label = 4; max_column_label = 4 }
                        labels = [ordered]@{ tree_title = '  '; row_axis = 'Widgets'; column_axis = 'Gadgets'; root_files = 'Wid'; unlisted_files = 'Gizmos' }
                    }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike '*labels.tree_title is empty*'
            $err.Exception.Message | Should -BeLike "*labels.row_axis: 'Widgets' is 7 characters, longer than its limit of 4*"
            $err.Exception.Message | Should -BeLike "*labels.column_axis: 'Gadgets' is 7 characters, longer than its limit of 4*"
            $err.Exception.Message | Should -BeLike "*labels.unlisted_files: 'Gizmos' is 6 characters, longer than its limit of 4*"
            $err.Exception.Message | Should -Not -BeLike '*labels.root_files*'
        }

        It 'throws on a pins list that is not a list, and on an entry that is not a mapping' {
            { & $script:make ([ordered]@{ highlight = [ordered]@{ pins = 'ADR-WIDGET' } }) } | Should -Throw '*highlight.pins must be a list*'
            { & $script:make ([ordered]@{ highlight = [ordered]@{ exceptions = @('ADR-WIDGET') } }) } |
                Should -Throw '*highlight.exceptions`[0`] must be a mapping*'
        }

        It 'throws on a pin with a bad or missing field, or an unknown key' {
            $bad = [ordered]@{ adr = 'widget-3'; track = 'Widgets'; file_language = 'Gadget'; colour = 'blue' }
            $err = { & $script:make ([ordered]@{ highlight = [ordered]@{ pins = @((& $script:pin), $bad) } }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike '*highlight.pins`[1`]: unknown key ''colour''*'
            $err.Exception.Message | Should -BeLike '*highlight.pins`[1`]: invalid adr ''widget-3''*'
            $err.Exception.Message | Should -BeLike '*highlight.pins`[1`]: invalid track ''Widgets''*'
            $err.Exception.Message | Should -BeLike '*highlight.pins`[1`]: invalid file_language ''Gadget''*'
            $err.Exception.Message | Should -BeLike '*highlight.pins`[1`]: reason is required*'
            $err.Exception.Message | Should -Not -BeLike '*pins`[0`]*'
            { & $script:make ([ordered]@{ highlight = [ordered]@{ pins = @([ordered]@{ reason = 'widget' }) } }) } |
                Should -Throw '*highlight.pins`[0`]: adr is required*'
        }

        It 'accepts a dotted track name in a pin' {
            $entry = & $script:pin
            $entry.track = '.gadgets'
            (& $script:make ([ordered]@{ highlight = [ordered]@{ pins = @($entry) } })).highlight.pins[0].track | Should -Be '.gadgets'
        }

        It 'throws on an output folder that is not one folder name' {
            foreach ($folder in @('widget/map', 'widget\map', '..', 'C:', '.')) {
                { & $script:make ([ordered]@{ output_folder = $folder }) } | Should -Throw "*output_folder '$folder' must be one folder name*"
            }
        }

        It 'gives each diagram kind its pool and three defaults when the file names none' {
            $config = & $script:make ([ordered]@{})
            $config.MinimapsOf('explanation').pool | Should -Be @('axis', 'lifecycle-position', 'layer-stack', 'grid')
            $config.MinimapsOf('explanation').defaults | Should -Be @('axis', 'lifecycle-position', 'layer-stack')
            $config.MinimapsOf('reference').pool | Should -Be @('code-locations', 'track-placement', 'engine-strip', 'module-neighbourhood', 'grid')
            $config.MinimapsOf('reference').defaults | Should -Be @('track-placement', 'engine-strip', 'module-neighbourhood')
        }

        It 'reads a kind''s pool and defaults from the file' {
            $raw = [ordered]@{ minimaps = [ordered]@{ explanation = [ordered]@{ pool = @('grid', 'axis', 'layer-stack'); defaults = @('grid', 'axis', 'layer-stack') } } }
            (& $script:make $raw).MinimapsOf('explanation').defaults | Should -Be @('grid', 'axis', 'layer-stack')
        }

        It 'rejects an unknown minimap id, a default outside the pool, and a count other than three' {
            { & $script:make ([ordered]@{ minimaps = [ordered]@{ reference = [ordered]@{ pool = @('widget') } } }) } | Should -Throw "*'widget' is not one of: grid, code-locations*"
            { & $script:make ([ordered]@{ minimaps = [ordered]@{ reference = [ordered]@{ defaults = @('grid', 'axis', 'engine-strip') } } }) } | Should -Throw "*'axis' is not in the pool*"
            { & $script:make ([ordered]@{ minimaps = [ordered]@{ explanation = [ordered]@{ defaults = @('grid') } } }) } | Should -Throw '*names 1 minimaps; a diagram shows exactly 3*'
        }

        It 'rejects a diagram kind outside explanation and reference, naming them' {
            { (& $script:make ([ordered]@{})).MinimapsOf('widget') } | Should -Throw "*diagram kind 'widget' is not one of: explanation, reference*"
        }

        It 'names a data command for every minimap id by default, and takes an override per id' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $default = & $script:make ([ordered]@{})
            @($default.minimap_data.Keys | Sort-Object) | Should -Be @([Catzc.Base.Maps.MinimapData]::Ids | Sort-Object)
            $default.minimap_data['code-locations'] | Should -Be 'Get-CodeLocationsMinimapData'
            $override = & $script:make ([ordered]@{ minimaps = [ordered]@{ data = [ordered]@{ grid = 'Get-WidgetGrid' } } })
            $override.minimap_data['grid'] | Should -Be 'Get-WidgetGrid'
            $override.minimap_data['axis'] | Should -Be 'Get-AxisMinimapData'
        }

        It 'rejects a data command for an unknown id or one that is not a Verb-Noun name' {
            { & $script:make ([ordered]@{ minimaps = [ordered]@{ data = [ordered]@{ widget = 'Get-Widget' } } }) } | Should -Throw "*minimaps.data: 'widget' is not one of: grid*"
            { & $script:make ([ordered]@{ minimaps = [ordered]@{ data = [ordered]@{ grid = 'widget grid' } } }) } | Should -Throw "*minimaps.data.grid 'widget grid' must be a Verb-Noun command name*"
        }

        It 'declares the axis rows and columns once, and takes the ones it is given' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $default = (& $script:make ([ordered]@{})).minimap_axis
            @($default.rows | ForEach-Object Key) | Should -Be @('DSGN', 'FLOW', 'AUTO', 'CLOUD')
            $default.RowOf('PRIN') | Should -Be 'DSGN'
            $given = (& $script:make ([ordered]@{ minimaps = [ordered]@{ axis = [ordered]@{ rows = [ordered]@{ UPPER = @('TOP') }; columns = @('alpha') } } })).minimap_axis
            $given.RowOf('TOP') | Should -Be 'UPPER'
            $given.RowOf('BOTTOM') | Should -BeNullOrEmpty
            $given.columns | Should -Be @('alpha')
        }
    }
}
