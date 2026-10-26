Describe 'VariantTrack' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([System.Collections.IDictionary] $raw)
            $full = [ordered]@{}
            foreach ($key in $raw.Keys) {
                $full[$key] = $raw[$key]
            }
            if (-not $full.Contains('tracks')) {
                $full['tracks'] = [ordered]@{ widgets = [ordered]@{ members = @('widgetry'); type = 'modules' } }
            }
            [Catzc.Base.Variants.VariantsConfig]::new($full)
        }
    }

    It 'reads a track''s namespace, empty by default, in its language''s casing, and refuses a malformed one' {
        (& $script:make ([ordered]@{})).tracks[0].namespace | Should -BeExactly ''
        $named = & $script:make ([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = 'Gadgets.Kit' } } })
        $named.tracks[0].namespace | Should -BeExactly 'Gadgets.Kit'
        $lower = & $script:make ([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = 'gadgets' } } })
        $lower.tracks[0].namespace | Should -BeExactly 'gadgets'
        foreach ($bad in 'Gadgets.', '.Gadgets', 'Gad gets', 'gadgets.kit', 'gadGets') {
            { & $script:make ([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = $bad } } }) } |
                Should -Throw "*invalid namespace '$bad'*" -Because "'$bad' is neither dotted PascalCase nor one lower-case word"
        }
    }

    It 'joins the namespace to a folder by the track''s join, the dot when it declares none' -Tag 'DDR-TRACK-MODULENAMESPACE' {
        $track = { param($namespace, $join)
            $entry = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = $namespace }
            if ($PSBoundParameters.ContainsKey('join')) {
                $entry['join'] = $join
            }
            (& $script:make ([ordered]@{ tracks = [ordered]@{ widgets = $entry } })).tracks[0]
        }
        foreach ($case in @(
                @{ Namespace = 'Gadgets'; Join = $null; Folder = 'Base.Spin'; Full = 'Gadgets.Base.Spin' }
                @{ Namespace = 'gadgets'; Join = '-'; Folder = 'spin-lamps'; Full = 'gadgets-spin-lamps' }
                @{ Namespace = 'gadgets'; Join = '_'; Folder = 'spin'; Full = 'gadgets_spin' }
                @{ Namespace = 'gadgets'; Join = ''; Folder = 'spin'; Full = 'gadgetsspin' }
            )) {
            $widgets = if ($null -eq $case.Join) {
                & $track $case.Namespace
            }
            else {
                & $track $case.Namespace $case.Join
            }
            $widgets.join | Should -BeExactly $(if ($null -eq $case.Join) {
                    '.'
                }
                else {
                    $case.Join
                })
            $widgets.FullNameOf($case.Folder) | Should -BeExactly $case.Full
            $widgets.FolderNameOf($case.Full) | Should -BeExactly $case.Folder
        }
    }

    It 'refuses a join outside the closed set, and a join with no namespace to join' {
        $entry = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = 'gadgets'; join = '+' }
        { & $script:make ([ordered]@{ tracks = [ordered]@{ widgets = $entry } }) } | Should -Throw "*invalid join '+'*"
        $bare = [ordered]@{ members = @('widgetry'); type = 'modules'; join = '-' }
        { & $script:make ([ordered]@{ tracks = [ordered]@{ widgets = $bare } }) } | Should -Throw '*a join needs a namespace*'
    }

    It 'names the first segment below a place that spells the namespace in its join form, unless an exempt glob matches the path' -Tag 'DDR-TRACK-MODULENAMESPACE' {
        $entry = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = 'gadget'; join = '-'
            namespace_exempt = @('widgetry/.core/gadget-core.*')
        }
        $widgets = (& $script:make ([ordered]@{ tracks = [ordered]@{ widgets = $entry } })).tracks[0]
        $widgets.namespace_exempt | Should -Be @('widgetry/.core/gadget-core.*')
        $widgets.NamespaceSegmentOf('widgetry/gadget-spring/lever.js') | Should -BeExactly 'widgetry/gadget-spring'
        $widgets.NamespaceSegmentOf('widgetry/spring/gadget-lever.js') | Should -BeExactly 'widgetry/spring/gadget-lever.js'
        $widgets.NamespaceSegmentOf('widgetry/spring/lever.js') | Should -BeNullOrEmpty
        $widgets.NamespaceSegmentOf('widgetry/.core/gadget-core.psm1') | Should -BeNullOrEmpty -Because 'the exempt glob names it'
        $widgets.NamespaceSegmentOf('elsewhere/gadget-spring.js') | Should -BeNullOrEmpty -Because 'the path is in no place of the track'
    }

    It 'matches the namespace ordinally in the track''s own join form, so another casing or join is not this track''s namespace' -Tag 'DDR-TRACK-MODULENAMESPACE' {
        $entry = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = 'Gadget' }
        $widgets = (& $script:make ([ordered]@{ tracks = [ordered]@{ widgets = $entry } })).tracks[0]
        $widgets.NamespaceSegmentOf('widgetry/Gadget.Lever/spin.ps1') | Should -BeExactly 'widgetry/Gadget.Lever'
        $widgets.NamespaceSegmentOf('widgetry/tests/gadget-lever.Tests.ps1') | Should -BeNullOrEmpty -Because 'gadget- is another track''s join form'
        $widgets.NamespaceSegmentOf('widgetry/gadget.lever/spin.ps1') | Should -BeNullOrEmpty -Because 'the namespace is spelled in its own casing'
    }

    It 'refuses a namespace_exempt with no namespace, and a malformed exempt glob' {
        $bare = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace_exempt = @('widgetry/x.*') }
        { & $script:make ([ordered]@{ tracks = [ordered]@{ widgets = $bare } }) } | Should -Throw '*a namespace_exempt needs a namespace*'
        $bad = [ordered]@{ members = @('widgetry'); type = 'modules'; namespace = 'gadget'; namespace_exempt = @('widgetry/x**/y') }
        { & $script:make ([ordered]@{ tracks = [ordered]@{ widgets = $bad } }) } | Should -Throw "*namespace_exempt: glob pattern 'widgetry/x``*``*/y'*"
    }

    It 'reads a plain member as authored and committed, and a map member with the facts it states' -Tag 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
        $config = & $script:make ([ordered]@{ tracks = [ordered]@{
                    widget = [ordered]@{ members                                                              = @('widget',
                            [ordered]@{ path = 'widget.cache'; generated = $true; committed = $false }); type = 'widget-works'
                    }
                }
            })
        $members = $config.tracks[0].members
        $members.path | Should -Be @('widget', 'widget.cache')
        @($members[0].generated, $members[0].committed) | Should -Be @($false, $true)
        @($members[1].generated, $members[1].committed) | Should -Be @($true, $false)
        $config.tracks[0].places | Should -Be @('widget',
            'widget.cache') -Because 'places are the members'' paths, computed'
        $config.tracks[0].MemberOf('widget/deep/a.txt').path | Should -BeExactly 'widget'
        $config.tracks[0].MemberOf('widget.cache').generated | Should -BeTrue
        $config.tracks[0].MemberOf('gadget/a.txt') | Should -BeNullOrEmpty
    }

    It 'reads a glob member as files inside a place, never a place itself, and gives it the paths it matches' -Tag 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
        $config = & $script:make ([ordered]@{ tracks = [ordered]@{
                    widget = [ordered]@{ members                                                                = @('widget',
                            [ordered]@{ path = 'widget/*/*.wdg'; generated = $true; committed = $false }); type = 'widget-works'
                    }
                }
            })
        $track = $config.tracks[0]
        $track.places | Should -Be @('widget')
        $track.members[1].glob | Should -BeTrue
        $track.members[0].glob | Should -BeFalse
        $track.MemberOf('widget/gear/spin.wdg').path | Should -BeExactly 'widget/*/*.wdg'
        $track.MemberOf('widget/gear/spin.txt').path | Should -BeExactly 'widget'
        $track.PlaceLengthOf('widget/gear/spin.wdg') | Should -Be 14
    }

    It 'throws on a malformed glob member, an unknown member key and a fact that is not a boolean' -ForEach @(
        @{ Member = 'widget/x**/b'; Message = "*glob pattern 'widget/x`*`*/b'*" }
        @{ Member = [ordered]@{ path = 'widget'; colour = 'blue' }; Message = "*member has unknown key 'colour'*" }
        @{ Member = [ordered]@{ path = 'widget'; committed = 'yes' }; Message = "*member 'widget' committed must be true or false*" }
    ) {
        { & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ members = @($Member); type = 'widget-works' } } }) } |
            Should -Throw $Message
    }

    It 'gives the length of the longest place that contains a path, and -1 when none does' -ForEach @(
        @{ Path = 'widget/a/b.txt'; Length = 6 }
        @{ Path = 'widget'; Length = 6 }
        @{ Path = 'widget/deep/b.txt'; Length = 11 }
        @{ Path = 'widgets/a.txt'; Length = -1 }
        @{ Path = 'gadget/a.txt'; Length = -1 }
    ) {
        $config = & $script:make ([ordered]@{ tracks = [ordered]@{ widget = [ordered]@{ members = @('widget',
                            'widget/deep'); type                                                = 'widget-works'
                    }
                }
            })
        $config.tracks[0].PlaceLengthOf($Path) | Should -Be $Length
    }
}
