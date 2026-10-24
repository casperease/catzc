Describe 'PlaceRows' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:places = [Catzc.Base.Maps.MapsMinimapPlaces]::Default()
        $script:cell = { param([string] $Track, [string] $Module, [string] $Folder) [Catzc.Base.Maps.MinimapCell]::new([string[]] @($Track, $Module, $Folder), 1, [Catzc.Base.Maps.MinimapReason[]] @([Catzc.Base.Maps.MinimapReason]::new('widgets/x', 'citation', 'ADR-WIDGET', $null))) }
        $script:rowsOf = { param([object[]] $Places) [Catzc.Base.Maps.PlaceRows]::From([Catzc.Base.Maps.MinimapCell[]] @($Places | ForEach-Object { & $script:cell $_[0] $_[1] $_[2] }), $script:places) }
    }

    Context 'the budget' {
        It 'declares the defaults once on the config type: 7 place rows, 1 counters row, 40 characters, the four groups in order' {
            $script:places.rows | Should -Be 7
            $script:places.counter_rows | Should -Be 1
            $script:places.row_chars | Should -Be 40
            @($script:places.group_order) | Should -Be @('docs', 'modules', 'sub-folders', 'rest')
        }

        It 'refuses a group order that does not name each group once' {
            { [Catzc.Base.Maps.MapsMinimapPlaces]::new(7, 1, 40, [string[]] @('docs', 'modules'), 'Catzc.', '...') } | Should -Throw '*group_order must name each of*'
            { [Catzc.Base.Maps.MapsMinimapPlaces]::new(7, 1, 40, [string[]] @('docs', 'docs', 'sub-folders', 'rest'), 'Catzc.', '...') } | Should -Throw "*'modules' exactly once*"
        }
    }

    Context 'one place in its minimised form' {
        It 'drops the module prefix whole and leaves out the placeholder parts' {
            [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget', '.', $script:places) | Should -BeExactly 'widgets / Widget'
            [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Cog', 'types', $script:places) | Should -BeExactly 'widgets / Widget.Cog / types'
            [Catzc.Base.Maps.PlaceRows]::Form('docs', '-', '.', $script:places) | Should -BeExactly 'docs'
        }

        It 'elides the middle of a long module at a segment boundary and keeps the tail that tells places apart' {
            $row = [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Sprocket.Assembly.Gadgetry', 'types', $script:places)
            $row.Length | Should -BeLessOrEqual 40
            $row | Should -BeExactly 'widgets / Widget...Gadgetry / types'
            $row | Should -Match '\.\.\.Gadgetry'
        }

        It 'cuts at a dot between whole segments, never inside a word' {
            $row = [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Sprocket.Assembly.Gadgetry', 'types', $script:places)
            $module = ($row -split ' / ')[1]
            foreach ($piece in ($module -split '\.\.\.')) {
                @('Widget', 'Sprocket', 'Assembly', 'Gadgetry') | Should -Contain $piece
            }
        }

        It 'recovers the place of a row that kept everything, with the prefix restored' {
            [Catzc.Base.Maps.PlaceRows]::Recover('widgets / Widget.Cog / types', $script:places) | Should -Be @('widgets', 'Catzc.Widget.Cog', 'types')
            [Catzc.Base.Maps.PlaceRows]::Recover('widgets / Widget', $script:places) | Should -Be @('widgets', 'Catzc.Widget', '.')
            [Catzc.Base.Maps.PlaceRows]::Recover('docs', $script:places) | Should -Be @('docs', '-', '.')
        }

        It 'round-trips every place that fits: form, recover, form again' {
            foreach ($place in @(@('docs', '-', '.'), @('widgets', 'Catzc.Widget', '.'), @('widgets', 'Catzc.Widget', 'tests'), @('gadgets', 'Catzc.Gadget.Cog', 'configs'))) {
                $row = [Catzc.Base.Maps.PlaceRows]::Form($place[0], $place[1], $place[2], $script:places)
                $back = [Catzc.Base.Maps.PlaceRows]::Recover($row, $script:places)
                $back | Should -Be $place
                [Catzc.Base.Maps.PlaceRows]::Form($back[0], $back[1], $back[2], $script:places) | Should -BeExactly $row
            }
        }

        It 'throws for a row that elided its middle or folded places, since it names no one place' {
            { [Catzc.Base.Maps.PlaceRows]::Recover('widgets / Widget...Gadgetry / types', $script:places) } | Should -Throw '*elides its middle*'
            { [Catzc.Base.Maps.PlaceRows]::Recover('widgets / Widget / +3', $script:places) } | Should -Throw '*folds places*'
        }

        It 'knows whether a row is already in the minimised form' {
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets / Widget / types', $script:places) | Should -BeTrue
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets / Catzc.Widget / types', $script:places) | Should -BeFalse
            [Catzc.Base.Maps.PlaceRows]::IsNormal(('widgets / ' + ('x' * 50)), $script:places) | Should -BeTrue
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets / Widget / types / a / b', $script:places) | Should -BeFalse
        }
    }

    Context 'the rows of a minimap' {
        It 'groups the places in the declared order: docs, then modules, then their sub-folders, then the rest' {
            $rows = & $script:rowsOf @(
                , @('gadgets', '-', '.')
                , @('widgets', 'Catzc.Widget', 'types')
                , @('widgets', 'Catzc.Widget', '.')
                , @('docs', '-', '.')
            )
            @($rows.Rows) | Should -Be @('docs', 'widgets / Widget', 'widgets / Widget / types', 'gadgets')
        }

        It 'orders the groups by the configuration, not by the code' {
            $places = [Catzc.Base.Maps.MapsMinimapPlaces]::new(7, 1, 40, [string[]] @('rest', 'sub-folders', 'modules', 'docs'), 'Catzc.', '...')
            $rows = [Catzc.Base.Maps.PlaceRows]::From([Catzc.Base.Maps.MinimapCell[]] @(
                    (& $script:cell 'docs' '-' '.'), (& $script:cell 'widgets' 'Catzc.Widget' '.'), (& $script:cell 'gadgets' '-' '.')), $places)
            @($rows.Rows) | Should -Be @('gadgets', 'widgets / Widget', 'docs')
        }

        It 'draws every place as its own row while they fit the budget, and the counters line says how many' {
            $rows = & $script:rowsOf @(, @('docs', '-', '.'), @('widgets', 'Catzc.Widget', '.'))
            $rows.Rows.Count | Should -Be 2
            $rows.Counters | Should -BeExactly '2 places'
        }

        It 'folds the module with the most rows into one row when the places are more than the 7 rows' {
            $places = @(, @('docs', '-', '.'))
            $places += , @('widgets', 'Catzc.Widget', '.')
            $places += foreach ($folder in 'configs', 'tests', 'types', 'private') { , @('widgets', 'Catzc.Widget', $folder) }
            $places += foreach ($module in 'Catzc.Gadget', 'Catzc.Cog', 'Catzc.Sprocket') { , @('gadgets', $module, '.') }
            $rows = & $script:rowsOf $places
            $rows.Rows.Count | Should -BeLessOrEqual 7
            @($rows.Rows) | Should -Contain 'widgets / Widget / +5'
            $rows.Counters | Should -BeExactly '9 places'
        }

        It 'never exceeds 7 place rows and counts what it leaves out' {
            $places = foreach ($n in 1..12) { , @('gadgets', "Catzc.Gadget$n", '.') }
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
            $rows = & $script:rowsOf @(, @('docs', '-', '.'), @('docs', '-', '.'))
            $rows.Rows.Count | Should -Be 1
            $rows.Counters | Should -BeExactly '1 place'
        }
    }
}
