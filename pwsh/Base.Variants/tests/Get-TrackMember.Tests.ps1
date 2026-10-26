Describe 'Get-TrackMember' -Tag 'L0', 'logic', 'DDR-TRACK-TRACKISPLACEDCLUSTER' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{
                tracks = [ordered]@{
                    widget = [ordered]@{ members                                                              = @('widget',
                            [ordered]@{ path = 'widget.cache'; generated = $true; committed = $false }); type = 'widget-works'
                    }
                    gadget = [ordered]@{ members                                                                = @('gadget',
                            [ordered]@{ path = 'gadget/rendered.md'; generated = $true },
                            [ordered]@{ path = 'gadget/*/*.cog'; generated = $true; committed = $false }); type = 'gadget-shelf'
                    }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { $script:fixture }
    }

    It 'lists every member of every track with its track name and facts' {
        $members = @(Get-TrackMember)
        $members[0] | Should -BeOfType [Catzc.Base.Variants.TrackMember]
        $members.path | Should -Be @('widget', 'widget.cache', 'gadget', 'gadget/rendered.md', 'gadget/*/*.cog')
        $members.track | Should -Be @('widget', 'widget', 'gadget', 'gadget', 'gadget')
        @($members[1].generated, $members[1].committed) | Should -Be @($true, $false)
    }

    It 'restricts to the named tracks' {
        @(Get-TrackMember -Name gadget).path | Should -Be @('gadget', 'gadget/rendered.md', 'gadget/*/*.cog')
    }

    It 'filters on generated and on committed, each alone or both together' {
        @(Get-TrackMember -Generated $true).path | Should -Be @('widget.cache', 'gadget/rendered.md', 'gadget/*/*.cog')
        @(Get-TrackMember -Committed $false).path | Should -Be @('widget.cache', 'gadget/*/*.cog')
        @(Get-TrackMember -Generated $true -Committed $true).path | Should -Be @('gadget/rendered.md')
        @(Get-TrackMember -Generated $false).path | Should -Be @('widget', 'gadget')
    }

    It 'answers the one member that contains a path, the longest, in the track Get-Track -Path finds' {
        (Get-TrackMember -Path 'gadget/rendered.md').generated | Should -BeTrue
        (Get-TrackMember -Path 'gadget\deep\a.txt').path | Should -BeExactly 'gadget'
        (Get-TrackMember -Path 'gadget/deep/a.txt').track | Should -BeExactly (Get-Track -Path 'gadget/deep/a.txt').name
        Get-TrackMember -Path 'nowhere/a.txt' | Should -BeNullOrEmpty
        (Get-TrackMember -Path 'gadget/deep/spin.cog').path | Should -BeExactly 'gadget/*/*.cog'
    }
}
