Describe 'PlaceRows' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:places = [Catzc.Base.Maps.MapsMinimapPlaces]::Default()
        $script:cell = { param([string] $Track, [string] $Module,
            [string] $Folder) [Catzc.Base.Maps.MinimapCell]::new([string[]] @($Track, $Module, $Folder), 1,
            [Catzc.Base.Maps.MinimapReason[]] @([Catzc.Base.Maps.MinimapReason]::new("$Track/$Module/$Folder/x",
            'citation', 'ADR-WIDGET', $null))) }
        $script:cells = { param([object[]] $Places) [Catzc.Base.Maps.MinimapCell[]] @($Places | ForEach-Object { & $script:cell $_[0] $_[1] $_[2] }) }
        $script:rowsOf = { param([object[]] $Places) [Catzc.Base.Maps.PlaceRows]::From([Catzc.Base.Maps.MinimapCell[]] @(& $script:cells $Places), $script:places) }
    }

    Context 'the budget and the path form' {
        It 'declares every default once on the config type' {
            $script:places.rows | Should -Be 7
            $script:places.counter_rows | Should -Be 1
            $script:places.row_chars | Should -Be 40
            $script:places.row_join | Should -BeExactly '.'
            $script:places.name_join | Should -BeExactly '_'
            $script:places.root_marker | Should -BeExactly '(root)'
            $script:places.fold_separator | Should -BeExactly '|'
            $script:places.fold_count_prefix | Should -BeExactly '+'
        }

        It 'takes its joins and its root marker from the configuration, not from the code' {
            $other = [Catzc.Base.Maps.MapsMinimapPlaces]::new(7, 1, 40, 'Catzc.', '+', '#', '/', '-', '<root>')
            [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Cog', 'types', $other) |
                Should -BeExactly 'widgets/widget-cog/types'
        }
    }

    Context 'one place in its minimised form' {
        It 'is the path from the root joined with dots, the module prefix dropped and its dots made underscores, in lower case' {
            [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget', '.', $script:places) |
                Should -BeExactly 'widgets.widget'
            [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Cog', 'types', $script:places) |
                Should -BeExactly 'widgets.widget_cog.types'
        }

        It 'names the folder of a place outside any module, its path joined with dots' {
            [Catzc.Base.Maps.PlaceRows]::Form('docs', '-', 'explanation/ado', $script:places) |
                Should -BeExactly 'docs.explanation.ado'
            [Catzc.Base.Maps.PlaceRows]::Form('.claude', '-', 'skills', $script:places) |
                Should -BeExactly '.claude.skills'
        }

        It 'never cuts a name: a module row that is too long counts its folders, a folder path counts the segments left out' {
            $row = [Catzc.Base.Maps.PlaceRows]::Form('widgets', 'Catzc.Widget.Sprocket.Assembly.Gadgetry', 'types',
                $script:places)
            $row | Should -BeExactly 'widgets.widget_sprocket_assembly_gadgetry.+1'
            $row | Should -Not -BeLike '*...*'
            [Catzc.Base.Maps.PlaceRows]::Form('docs', '-', 'explanation/automation/pwsh/very-long-folder-name-here',
                $script:places) | Should -BeExactly 'docs.explanation.automation.pwsh.+1'
        }

        It 'knows whether a row is already in the minimised form' {
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.widget.types', $script:places) | Should -BeTrue
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.Widget.types', $script:places) | Should -BeFalse
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.catzc_widget.types', $script:places) | Should -BeFalse
            [Catzc.Base.Maps.PlaceRows]::IsNormal(('widgets.' + ('x' * 50)), $script:places) | Should -BeTrue
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.widget.(root)|configs|types', $script:places) |
                Should -BeTrue
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.widget.types|configs', $script:places) | Should -BeFalse
            [Catzc.Base.Maps.PlaceRows]::IsNormal('widgets.widget.configs|...', $script:places) | Should -BeFalse
        }
    }

    Context 'the rows of a minimap' {
        It 'is one row for each module and one for each folder outside a module, in repository path order' {
            $rows = & $script:rowsOf @(
                , @('widgets', 'Catzc.Widget', 'types')
                , @('widgets', 'Catzc.Widget', 'configs')
                , @('widgets', 'Catzc.Widget.Cog', '.')
                , @('widgets', 'Catzc.Widget.Gear', '.')
                , @('widgets', 'Catzc.Widget.Gear', 'tests')
                , @('docs', '-', 'explanation/ado')
                , @('.claude', '-', 'skills')
            )
            @($rows.Rows) | Should -Be @('.claude.skills', 'docs.explanation.ado', 'widgets.widget.configs|types',
                'widgets.widget_cog', 'widgets.widget_gear.(root)|tests')
            $rows.Counters | Should -BeExactly '7 places'
        }

        It 'drops a docs place at the docs root, which names no folder, and does not count it' {
            $rows = & $script:rowsOf @(, @('docs', '-', '.'))
            $rows.Rows.Count | Should -Be 0
            $rows.Counters | Should -BeExactly '0 places'
        }

        It 'counts the folders of a module row that is too long, never eliding any of them' {
            $places = foreach ($folder in 'configs', 'private', 'tests', 'types') {
                , @('widgets', 'Catzc.Widget.Gears', $folder)
            }
            $rows = & $script:rowsOf $places
            @($rows.Rows) | Should -Be @('widgets.widget_gears.+4')
        }

        It 'folds the modules of a track into one row only when the rows are more than the 7, and counts them when the names do not fit' {
            $places = @(, @('docs', '-', 'explanation'))
            $places += foreach ($n in 1..9) {
                , @('widgets', "Catzc.Cog$n", '.')
            }
            $rows = & $script:rowsOf $places
            @($rows.Rows) | Should -Be @('docs.explanation', 'widgets.+9')
            $rows.Counters | Should -BeExactly '10 places'
        }

        It 'never exceeds 7 place rows and counts what it leaves out' {
            $places = foreach ($n in 1..12) {
                , @("gadgets$n", "Catzc.Gadget$n", '.')
            }
            $rows = & $script:rowsOf $places
            $rows.Rows.Count | Should -Be 7
            $rows.Counters | Should -BeExactly '+5 more · 12 places'
            $rows.Counters.Length | Should -BeLessOrEqual 40
        }

        It 'draws the primary places first and the secondary ones only while the rows hold them, counting all of them' {
            $primary = [Catzc.Base.Maps.MinimapCell[]] @(& $script:cells @(, @('widgets', 'Catzc.Widget', '.')))
            $secondary = [Catzc.Base.Maps.MinimapCell[]] @(& $script:cells @(foreach ($n in 1..8) {
                        , @("gadgets$n", "Catzc.Gadget$n", '.')
                    }))
            $rows = [Catzc.Base.Maps.PlaceRows]::From($primary, $secondary, $script:places)
            $rows.Rows.Count | Should -Be 7
            @($rows.Rows) | Should -Contain 'widgets.widget'
            $rows.Counters | Should -BeExactly '+2 more · 9 places'
        }

        It 'counts a place once however many files light it' {
            $rows = & $script:rowsOf @(
                , @('docs', '-', 'explanation')
                , @('docs', '-', 'explanation')
            )
            $rows.Rows.Count | Should -Be 1
            $rows.Counters | Should -BeExactly '1 place'
        }
    }
}
