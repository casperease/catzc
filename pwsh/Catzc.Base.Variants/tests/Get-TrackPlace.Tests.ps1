Describe 'Get-TrackPlace' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    widget = [ordered]@{
                        places = @('widget/parts', 'widget/spares')
                        type   = 'widget-works'
                        kinds  = [ordered]@{ parts = 'widget/parts'; sheets = 'widget/parts/*/sheets'; spares = 'widget/spares' }
                    }
                    gadget = [ordered]@{ places = @('gadget'); type = 'gadget-shelf' }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:fixture }
    }

    It 'returns the place pattern of a named kind, a wildcard segment kept as written' -ForEach @(
        @{ Kind = 'parts'; Expected = 'widget/parts' }
        @{ Kind = 'sheets'; Expected = 'widget/parts/*/sheets' }
        @{ Kind = 'spares'; Expected = 'widget/spares' }
    ) {
        Get-TrackPlace -Track widget -TrackKind $Kind | Should -BeExactly $Expected
    }

    It 'throws on a kind the track does not name, listing its kinds and the config to declare it in' {
        { Get-TrackPlace -Track widget -TrackKind bolts } |
            Should -Throw -ExpectedMessage "Track 'widget' names no kind 'bolts' (its kinds: parts, sheets, spares)*variants.yml*"
    }

    It 'throws on a track that names no kinds' {
        { Get-TrackPlace -Track gadget -TrackKind parts } |
            Should -Throw -ExpectedMessage "*names no kind 'parts' (its kinds: none)*"
    }

    It 'throws on an unknown track through Get-Track' {
        { Get-TrackPlace -Track sprocket -TrackKind parts } | Should -Throw -ExpectedMessage "Unknown track 'sprocket'*"
    }
}

Describe 'Get-TrackPlace — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'places the three infrastructure kinds' -ForEach @(
        @{ Kind = 'templates'; Expected = 'infrastructure/templates' }
        @{ Kind = 'configs'; Expected = 'infrastructure/templates/*/configuration' }
        @{ Kind = 'modules'; Expected = 'infrastructure/modules' }
    ) {
        Get-TrackPlace -Track infrastructure -TrackKind $Kind | Should -BeExactly $Expected
    }
}
