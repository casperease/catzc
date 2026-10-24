Describe 'PlaceRows' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:places = [Catzc.Base.Maps.MapsMinimapPlaces]::Default()
        $script:cell = { param([string] $Track, [string] $Module, [string] $Folder) [Catzc.Base.Maps.MinimapCell]::new([string[]] @($Track, $Module, $Folder), 1, [Catzc.Base.Maps.MinimapReason[]] @([Catzc.Base.Maps.MinimapReason]::new('widgets/x', 'citation', 'ADR-WIDGET', $null))) }
        $script:rowsOf = { param([object[]] $Places) [Catzc.Base.Maps.PlaceRows]::From([Catzc.Base.Maps.MinimapCell[]] @($Places | ForEach-Object { & $script:cell $_[0] $_[1] $_[2] }), $script:places) }
    }

    Context 'the budget and the path form' {
        It 'declares every default once on the config type' {
            $script:places.rows | Should -Be 7
            $script:places.counter_rows | Should -Be 1
            $script:places.row_chars | Should -Be 40
            @($script:places.group_order) | Should -Be @('docs', 'modules', 'rest')
            $script:places.row_join | Should -BeExactly '.'
            $script:places.name_join | Should -BeExactly '_'
            $script:places.root_marker | Should -BeExactly '(root)'
            $script:places.fold_separator | Should -BeExactly '|'
            $script:places.fold_count_prefix | Should -BeExactly '+'
        }

        It 'refuses a group order that does not name each group once' {
            { [Catzc.Base.Maps.MapsMinimapPlaces]::new(7, 1, 40, [string[]] @('docs', 'modules'), 'Catzc.', '...') } | Should -Throw '*group_order must name each of*'
            { [Catzc.Base.Maps.MapsMinimapPlaces]::new(7, 1, 40, [string[]] @('docs', 'docs', 'rest'), 'Catzc.', '...') } | Should -Throw "*'modules' exactly once*"
        }

        It 'takes its joins and its root marker from the configuration, not from the code' {
            $other = [Catzc.Base.Maps.MapsMinimapPlaces]::new(7, 1, 40, [string[]] @('docs', 'modules', 'rest'), 'Catzc.', '...', '+', '#', '/', '-', '<root>')
            [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Cog', 'types', $other) | Should -BeExactly 'widgets/widget-cog/types'
        }
    }

    Context 'one place in its minimised form' {
        It 'is the path from the root joined with dots, the module prefix dropped and its dots made underscores, in lower case' {
            [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget', '.', $script:places) | Should -BeExactly 'widgets.widget'
            [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Cog', 'types', $script:places) | Should -BeExactly 'widgets.widget_cog.types'
            [Catzc.Base.Maps.PlaceRows]::Form('docs', '-', '.', $script:places) | Should -BeExactly 'docs'
        }

        It 'elides the middle of a long module name at an underscore boundary and keeps the tail that tells places apart' {
            $row = [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Sprocket.Assembly.Gadgetry', 'types', $script:places)
            $row.Length | Should -BeLessOrEqual 40
            $row | Should -BeExactly 'widgets.widget...assembly_gadgetry.types'
        }

        It 'recovers the place of a row, the module as its repository normal form' {
            ([Catzc.Base.Maps.PlaceRows]::Recover('widgets.widget_cog.types', $script:places))[0] | Should -Be @('widgets', 'catzc.widget.cog', 'types')
            ([Catzc.Base.Maps.PlaceRows]::Recover('widgets.widget', $script:places))[0] | Should -Be @('widgets', 'catzc.widget', '.')
            ([Catzc.Base.Maps.PlaceRows]::Recover('docs', $script:places))[0] | Should -Be @('docs', '-', '.')
        }

        It 'recovers every place a joined row names, the module root from its marker' {
            $recovered = [Catzc.Base.Maps.PlaceRows]::Recover('widgets.widget.(root)|configs|types', $script:places)
            $recovered.Count | Should -Be 3
            $recovered[0] | Should -Be @('widgets', 'catzc.widget', '.')
            $recovered[2] | Should -Be @('widgets', 'catzc.widget', 'types')
        }

        It 'round-trips every place that fits: form, recover, form again' {
            foreach ($place in @(@('docs', '-', '.'), @('widgets', 'Catzc.Widget', '.'), @('widgets', 'Catzc.Widget', 'tests'), @('gadgets', 'Catzc.Gadget.Cog', 'configs'))) {
                $row = [Catzc.Base.Maps.PlaceRows]::Form($place[0], $place[1], $place[2], $script:places)
                $back = ([Catzc.Base.Maps.PlaceRows]::Recover($row, $script:places))[0]
                [Catzc.Base.Maps.PlaceRows]::Form($back[0], $back[1].Replace('catzc.', 'Catzc.'), $back[2], $script:places) | Should -BeExactly $row
            }
        }

        It 'throws for a row that elides a name, folds modules or names a count only, since it names no place' {
            { [Catzc.Base.Maps.PlaceRows]::Recover('widgets.widget...gadgetry.types', $script:places) } | Should -Throw '*elides a name*'
            { [Catzc.Base.Maps.PlaceRows]::Recover('widgets.widget.+3', $script:places) } | Should -Throw '*names a count*'
            { [Catzc.Base.Maps.PlaceRows]::Recover('widgets.cog|gear|sprocket', $script:places) } | Should -Throw '*folds several modules*'
        }

        It 'knows whether a row is already in the minimised form' {
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.widget.types', $script:places) | Should -BeTrue
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.Widget.types', $script:places) | Should -BeFalse
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.catzc_widget.types', $script:places) | Should -BeFalse
            [Catzc.Base.Maps.PlaceRows]::IsNormal(('widgets.' + ('x' * 50)), $script:places) | Should -BeTrue
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.widget.(root)|configs|types', $script:places) | Should -BeTrue
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.widget.types|configs', $script:places) | Should -BeFalse
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.widget.configs|...', $script:places) | Should -BeTrue
        }
    }

    Context 'the rows of a minimap' {
        It 'is one row for each module, its lit sub-folders joined in order and its own root as the marker, sorted by path' {
            $rows = & $script:rowsOf @(
                , @('docs', '-', '.')
                , @('widgets', 'Catzc.Widget', 'types')
                , @('widgets', 'Catzc.Widget', 'configs')
                , @('widgets', 'Catzc.Widget.Cog', '.')
                , @('widgets', 'Catzc.Widget.Gear', '.')
                , @('widgets', 'Catzc.Widget.Gear', 'tests')
                , @('widgets', 'Catzc.Widget.Gear', 'types')
                , @('widgets', 'Catzc.Gadget', 'configs')
                , @('widgets', 'Catzc.Sprocket', '.')
                , @('widgets', 'Catzc.Spindle', 'configs')
            )
            @($rows.Rows) | Should -Be @('docs', 'widgets.gadget.configs', 'widgets.spindle.configs', 'widgets.sprocket', 'widgets.widget.configs|types', 'widgets.widget_cog', 'widgets.widget_gear.(root)|tests|types')
            $rows.Counters | Should -BeExactly '10 places'
        }

        It 'orders the groups by the configuration, not by the code' {
            $places = [Catzc.Base.Maps.MapsMinimapPlaces]::new(7, 1, 40, [string[]] @('rest', 'modules', 'docs'), 'Catzc.', '...')
            $rows = [Catzc.Base.Maps.PlaceRows]::From([Catzc.Base.Maps.MinimapCell[]] @(
                    (& $script:cell 'docs' '-' '.'), (& $script:cell 'widgets' 'Catzc.Widget' '.'), (& $script:cell 'gadgets' '-' '.')), $places)
            @($rows.Rows) | Should -Be @('gadgets', 'widgets.widget', 'docs')
        }

        It 'draws every place as its own row while they fit the budget, and the counters line says how many' {
            $rows = & $script:rowsOf @(
                , @('docs', '-', '.')
                , @('widgets', 'Catzc.Widget', '.')
            )
            $rows.Rows.Count | Should -Be 2
            $rows.Counters | Should -BeExactly '2 places'
        }

        It 'shortens a row that is too long to the whole names that fit, then the elision' {
            $places = foreach ($folder in 'configs', 'private', 'tests', 'types') { , @('widgets', 'Catzc.Widget.Gears', $folder) }
            $rows = & $script:rowsOf $places
            @($rows.Rows) | Should -Be @('widgets.widget_gears.configs|private|...')
        }

        It 'falls back to the count when not even one name fits' {
            $places = foreach ($folder in 'configuration-and-settings', 'types-and-definitions') { , @('widgets', 'Catzc.Widget.Sprocket.Assembly.Gadgetry', $folder) }
            $rows = & $script:rowsOf $places
            @($rows.Rows)[0] | Should -BeExactly 'widgets.widget...assembly_gadgetry.+2'
        }

        It 'folds the modules of the track with the most rows into one row only when the rows are more than the 7' {
            $places = @(, @('docs', '-', '.'))
            $places += foreach ($n in 1..9) { , @('widgets', "Catzc.Cog$n", '.') }
            $rows = & $script:rowsOf $places
            $rows.Rows.Count | Should -BeLessOrEqual 7
            @($rows.Rows) | Should -Contain 'widgets.cog1|cog2|cog3|cog4|cog5|...'
            $rows.Counters | Should -BeExactly '10 places'
        }

        It 'falls back to the count of places when not even one folded module name fits' {
            $places = foreach ($n in 1..8) { , @('widgets', "Catzc.Widget.Sprocket.Assembly.Gadgetry.Number$n", '.') }
            $rows = & $script:rowsOf $places
            @($rows.Rows) | Should -Be @('widgets.+8')
        }

        It 'never exceeds 7 place rows and counts what it leaves out' {
            $places = foreach ($n in 1..12) { , @("gadgets$n", "Catzc.Gadget$n", '.') }
            $rows = & $script:rowsOf $places
            $rows.Rows.Count | Should -Be 7
            $rows.Counters | Should -BeExactly '+5 more · 12 places'
            $rows.Counters.Length | Should -BeLessOrEqual 40
        }

        It 'keeps every row within 40 characters' {
            $places = foreach ($n in 1..3) { , @('widgets', "Catzc.Widget.Sprocket.Assembly.Gadgetry$n", 'types') }
            foreach ($row in (& $script:rowsOf $places).Rows) { $row.Length | Should -BeLessOrEqual 40 }
        }

        It 'counts a place once however many files light it' {
            $rows = & $script:rowsOf @(
                , @('docs', '-', '.')
                , @('docs', '-', '.')
            )
            $rows.Rows.Count | Should -Be 1
            $rows.Counters | Should -BeExactly '1 place'
        }
    }
}
