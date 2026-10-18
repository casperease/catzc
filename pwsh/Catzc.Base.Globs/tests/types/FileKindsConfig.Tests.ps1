Describe 'FileKindsConfig' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-METAKIND' {
    BeforeAll {
        function script:New-Config {
            param($Kinds)
            [Catzc.Base.Globs.FileKindsConfig]::new([ordered]@{ kinds = $Kinds })
        }

        $script:config = New-Config ([ordered]@{
                widget   = [ordered]@{ definition = 'A widget file.'; files = @('widgets/**/*.wdg') }
                gadget   = [ordered]@{
                    definition = 'A gadget file.'
                    subkinds   = [ordered]@{
                        cog  = [ordered]@{ definition = 'A cog of a gadget.'; files = @('gadgets/cog-*.gdg') }
                        gear = [ordered]@{ definition = 'A gear of a gadget.'; files = @('gadgets/*gear*.gdg') }
                    }
                    files      = @('gadgets/**/*.gdg')
                }
                sprocket = [ordered]@{ definition = 'A sprocket.'; files = @('**/*.wdg') }
            })
    }

    Context 'Resolve' {
        It 'names the first kind whose globs match, in the order declared' {
            $match = $script:config.Resolve('widgets/part.wdg')
            $match.role | Should -BeExactly 'widget'
            $match.subkind | Should -BeNullOrEmpty
            $match.definition | Should -BeExactly 'A widget file.'
            $match.Class | Should -BeExactly 'widget'
        }

        It 'lets a later kind take what no earlier kind matches' {
            $script:config.Resolve('elsewhere/part.wdg').role | Should -BeExactly 'sprocket'
        }

        It 'names a subkind before the kind''s own globs, and in the order the subkinds are written' {
            $cog = $script:config.Resolve('gadgets/cog-gear.gdg')
            $cog.role | Should -BeExactly 'gadget'
            $cog.subkind | Should -BeExactly 'cog'
            $cog.Class | Should -BeExactly 'gadget/cog'
            $script:config.Resolve('gadgets/deep/gear-one.gdg').subkind | Should -BeNullOrEmpty
            $script:config.Resolve('gadgets/gear-one.gdg').subkind | Should -BeExactly 'gear'
        }

        It 'names the kind alone for a file only its own globs match' {
            $match = $script:config.Resolve('gadgets/deep/plain.gdg')
            $match.role | Should -BeExactly 'gadget'
            $match.subkind | Should -BeNullOrEmpty
            $match.Class | Should -BeExactly 'gadget'
        }

        It 'names a file no entry selects other, with no definition' {
            $match = $script:config.Resolve('elsewhere/notes.txt')
            $match.role | Should -BeExactly 'other'
            $match.subkind | Should -BeNullOrEmpty
            $match.definition | Should -BeNullOrEmpty
        }

        It 'names every file other when no kind is declared' {
            (New-Config $null).Resolve('widgets/part.wdg').role | Should -BeExactly 'other'
        }
    }

    Context 'git attributes' {
        It 'holds the attributes and the why of a kind and of a subkind, and none for an entry without git' {
            $config = New-Config ([ordered]@{
                    widget = [ordered]@{ definition = 'A widget.'; files = @('a/**'); git = @{ attributes = @('catzc-widget', 'eol=lf'); why = 'Widgets are data.' } }
                    gadget = [ordered]@{
                        definition = 'A gadget.'
                        subkinds   = [ordered]@{ cog = [ordered]@{ definition = 'A cog.'; files = @('b/**'); git = @{ attributes = @('catzc-cog'); why = 'Cogs are data.' } } }
                        files      = @('c/**')
                    }
                })
            $widget = $config.kinds | Where-Object role -eq 'widget'
            $widget.gitAttributes | Should -Be @('catzc-widget', 'eol=lf')
            $widget.gitWhy | Should -BeExactly 'Widgets are data.'
            $gadget = $config.kinds | Where-Object role -eq 'gadget'
            @($gadget.gitAttributes).Count | Should -Be 0
            $gadget.gitWhy | Should -BeNullOrEmpty
            $gadget.subkinds[0].gitAttributes | Should -Be @('catzc-cog')
            $gadget.subkinds[0].gitWhy | Should -BeExactly 'Cogs are data.'
        }

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'git that is no map'; Git = 'catzc-widget'; Message = '*git must be a map*' }
            @{ Name = 'git with no attributes'; Git = @{ why = 'A why.' }; Message = '*git needs at least one attribute*' }
            @{ Name = 'git with empty attributes'; Git = @{ attributes = @(); why = 'A why.' }; Message = '*git needs at least one attribute*' }
            @{ Name = 'an attribute with whitespace'; Git = @{ attributes = @('eol = lf'); why = 'A why.' }; Message = '*one token without whitespace*' }
            @{ Name = 'a blank attribute'; Git = @{ attributes = @(' '); why = 'A why.' }; Message = '*one token without whitespace*' }
            @{ Name = 'git with no why'; Git = @{ attributes = @('catzc-widget') }; Message = '*git needs a why*' }
            @{ Name = 'git with a blank why'; Git = @{ attributes = @('catzc-widget'); why = ' ' }; Message = '*git needs a why*' }
            @{ Name = 'an unknown git key'; Git = @{ attributes = @('catzc-widget'); why = 'A why.'; nope = 1 }; Message = '*unknown git key ''nope''*' }
        ) {
            { New-Config ([ordered]@{ widget = [ordered]@{ definition = 'A widget.'; files = @('a/**'); git = $Git } }) } | Should -Throw $Message
        }
    }

    Context 'validation' {
        It 'accepts a kind that only has subkinds' {
            $config = New-Config ([ordered]@{
                    gadget = [ordered]@{ definition = 'A gadget.'; subkinds = [ordered]@{ cog = [ordered]@{ definition = 'A cog.'; files = @('a/**') } } }
                })
            $config.Resolve('a/b.txt').Class | Should -BeExactly 'gadget/cog'
            $config.Resolve('z/b.txt').role | Should -BeExactly 'other'
        }

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'a kind with no definition'; Kinds = @{ widget = @{ files = @('a/**') } }; Message = '*needs a definition*' }
            @{ Name = 'a kind with a blank definition'; Kinds = @{ widget = @{ definition = '  '; files = @('a/**') } }; Message = '*needs a definition*' }
            @{ Name = 'a kind with neither globs nor subkinds'; Kinds = @{ widget = @{ definition = 'A widget.' } }; Message = '*needs globs in ''files'', or subkinds*' }
            @{ Name = 'a subkind with no globs'; Kinds = @{ widget = @{ definition = 'A widget.'; subkinds = @{ cog = @{ definition = 'A cog.' } } } }; Message = '*subkind ''cog'' needs at least one glob*' }
            @{ Name = 'a subkind with no definition'; Kinds = @{ widget = @{ definition = 'A widget.'; subkinds = @{ cog = @{ files = @('a/**') } } } }; Message = '*subkind ''cog'' needs a definition*' }
            @{ Name = 'the kind other'; Kinds = @{ other = @{ definition = 'Other.'; files = @('a/**') } }; Message = '*not ''other''*' }
            @{ Name = 'an upper-case kind'; Kinds = @{ Widget = @{ definition = 'A widget.'; files = @('a/**') } }; Message = '*lowercase words joined by*' }
            @{ Name = 'an unknown key on a kind'; Kinds = @{ widget = @{ definition = 'A widget.'; files = @('a/**'); nope = 1 } }; Message = '*unknown key ''nope''*' }
            @{ Name = 'an unknown key on a subkind'; Kinds = @{ widget = @{ definition = 'A widget.'; subkinds = @{ cog = @{ definition = 'A cog.'; files = @('a/**'); nope = 1 } } } }; Message = '*unknown key ''nope''*' }
            @{ Name = 'an empty glob'; Kinds = @{ widget = @{ definition = 'A widget.'; files = @('a/**', ' ') } }; Message = '*a glob in ''files'' is empty*' }
            @{ Name = 'a kind that is not a map'; Kinds = @{ widget = 'x' }; Message = '*must be a map*' }
        ) {
            { New-Config $Kinds } | Should -Throw $Message
        }

        It 'rejects an unknown top-level key and a kinds value that is no map' {
            { [Catzc.Base.Globs.FileKindsConfig]::new(@{ widgets = @{} }) } | Should -Throw '*unknown key ''widgets''*'
            { [Catzc.Base.Globs.FileKindsConfig]::new(@{ kinds = 'x' }) } | Should -Throw '*kinds must be a map*'
            { [Catzc.Base.Globs.FileKindsConfig]::new($null) } | Should -Throw
        }
    }

    Context 'overlaps and shadowing' {
        BeforeAll {
            function script:New-Shadowed {
                param($Overlaps)
                $raw = [ordered]@{
                    kinds = [ordered]@{
                        widget   = [ordered]@{ definition = 'A widget file.'; files = @('widgets/**/*.txt') }
                        gadget   = [ordered]@{
                            definition = 'A gadget file.'
                            subkinds   = [ordered]@{ cog = [ordered]@{ definition = 'A cog.'; files = @('gadgets/cog-*.txt') } }
                            files      = @('gadgets/**/*.txt')
                        }
                        sprocket = [ordered]@{ definition = 'Any text file.'; files = @('**/*.txt') }
                    }
                }
                if ($null -ne $Overlaps) {
                    $raw.overlaps = $Overlaps
                }
                [Catzc.Base.Globs.FileKindsConfig]::new($raw)
            }
            $script:paths = [string[]] @('widgets/a.txt', 'widgets/b.txt', 'gadgets/cog-1.txt', 'gadgets/x.txt', 'other/one.txt')
        }

        It 'has no overlaps by default, and reads the pairs in order' {
            (New-Shadowed).overlaps.Count | Should -Be 0
            $pairs = (New-Shadowed @(, @('widget', 'sprocket'))).overlaps
            $pairs.Count | Should -Be 1
            $pairs[0].Earlier | Should -BeExactly 'widget'
            $pairs[0].Later | Should -BeExactly 'sprocket'
        }

        It 'reports a kind mostly shadowed by an earlier one the overlaps do not list, once per hiding kind' {
            $shadows = @((New-Shadowed).Shadowing($script:paths))
            $shadows.Count | Should -Be 2
            $shadows[0].Hidden | Should -BeExactly 'sprocket'
            $shadows[0].By | Should -BeExactly 'gadget'
            $shadows[0].Taken | Should -Be 2
            $shadows[0].Matched | Should -Be 5
            $shadows[1].By | Should -BeExactly 'widget'
            $shadows[1].Taken | Should -Be 2
        }

        It 'reports nothing for a listed pair, and nothing below the shadowed share' {
            @((New-Shadowed @(@('widget', 'sprocket'), @('gadget', 'sprocket'))).Shadowing($script:paths)).Count | Should -Be 0
            @((New-Shadowed).Shadowing([string[]] @('widgets/a.txt', 'other/one.txt', 'other/two.txt'))).Count | Should -Be 0
            @((New-Shadowed).Shadowing([string[]] @())).Count | Should -Be 0
        }

        It 'counts a subkind''s files as the kind''s own' {
            @((New-Shadowed).Shadowing([string[]] @('gadgets/cog-1.txt', 'gadgets/cog-2.txt', 'gadgets/x.txt')) | Where-Object Hidden -eq 'gadget').Count | Should -Be 0
        }

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'an overlap that is not a pair'; Overlaps = @(, @('widget')); Message = '*an overlap is a pair*' }
            @{ Name = 'an overlap naming an undeclared kind'; Overlaps = @(, @('widget', 'cog')); Message = '*names a kind the registry does not declare*' }
            @{ Name = 'an overlap out of precedence order'; Overlaps = @(, @('sprocket', 'widget')); Message = '*not in precedence order*' }
            @{ Name = 'an overlap listed twice'; Overlaps = @(@('widget', 'sprocket'), @('widget', 'sprocket')); Message = '*listed twice*' }
            @{ Name = 'overlaps that are not a list'; Overlaps = 'widget'; Message = '*overlaps must be a list*' }
        ) {
            { New-Shadowed $Overlaps } | Should -Throw $Message
        }
    }
}
