Describe 'FiltersConfig' -Tag 'L0', 'logic' {
    It 'reads the filters in declaration order, each with its selectors' {
        $config = [Catzc.Base.Globs.FiltersConfig]::new([ordered]@{
                filters = @(
                    [ordered]@{ name = 'widgets'; select = @('aspect.live', 'glob.widgets/**') }
                    [ordered]@{ name = 'gadgets'; select = @('generated', 'track_type.vendor_settings') }
                )
            })
        @($config.filters.name) | Should -Be @('widgets', 'gadgets')
        @($config.filters[0].select) | Should -Be @('aspect.live', 'glob.widgets/**')
    }

    It 'splits a selector into its kind and argument at the first dot' {
        [Catzc.Base.Globs.RepositoryFilter]::KindOf('glob.widgets/x.yml') | Should -Be 'glob'
        [Catzc.Base.Globs.RepositoryFilter]::ArgumentOf('glob.widgets/x.yml') | Should -Be 'widgets/x.yml'
        [Catzc.Base.Globs.RepositoryFilter]::KindOf('generated') | Should -Be 'generated'
        [Catzc.Base.Globs.RepositoryFilter]::ArgumentOf('generated') | Should -Be ''
    }

    It 'refuses <Case>' -ForEach @(
        @{ Case = 'an unknown selector kind'; Filter = [ordered]@{ name = 'widgets'; select = @('widget.live') }; Message = "*'widget.live' is no known kind*" }
        @{ Case = 'a selector with no argument'; Filter = [ordered]@{ name = 'widgets'; select = @('track.') }; Message = "*names nothing after 'track.'*" }
        @{ Case = 'an empty selection'; Filter = [ordered]@{ name = 'widgets'; select = @() }; Message = "*must select a non-empty list*" }
        @{ Case = 'a name not in lower snake case'; Filter = [ordered]@{ name = 'Widgets'; select = @('generated') }; Message = "*lower snake case*" }
    ) {
        { [Catzc.Base.Globs.FiltersConfig]::new([ordered]@{ filters = @($Filter) }) } | Should -Throw -ExpectedMessage $Message
    }

    It 'refuses a filter declared twice' {
        $twice = [ordered]@{ filters = @([ordered]@{ name = 'widgets'; select = @('generated') }, [ordered]@{ name = 'widgets'; select = @('generated') }) }
        { [Catzc.Base.Globs.FiltersConfig]::new($twice) } | Should -Throw -ExpectedMessage '*declared twice*'
    }
}
