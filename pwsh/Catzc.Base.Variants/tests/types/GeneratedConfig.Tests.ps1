Describe 'GeneratedConfig' -Tag 'L0', 'logic' {
    It 'reads each target''s path or glob and its generator, in order' {
        $config = [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{
                targets = @(
                    [ordered]@{ path = 'widgets/index.md'; generator = 'Build-WidgetIndex' }
                    [ordered]@{ path = 'gadgets/**'; generator = 'Build-Gadget' }
                )
            })
        @($config.targets.path) | Should -Be @('widgets/index.md', 'gadgets/**')
        @($config.targets.generator) | Should -Be @('Build-WidgetIndex', 'Build-Gadget')
    }

    It 'has no targets when it declares none' {
        @([Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{}).targets) | Should -HaveCount 0
    }

    It 'refuses <Case>' -ForEach @(
        @{ Case = 'an unknown key'; Raw = [ordered]@{ widgets = @() }; Message = "*unknown key 'widgets'*" }
        @{ Case = 'a target without a generator'; Raw = [ordered]@{ targets = @([ordered]@{ path = 'widgets/x.md' }) }; Message = "*names no generator*" }
        @{ Case = 'a backslash path'; Raw = [ordered]@{ targets = @([ordered]@{ path = 'widgets\x.md'; generator = 'Build-Widget' }) }; Message = "*'/'-separated*" }
        @{ Case = 'an unknown target key'; Raw = [ordered]@{ targets = @([ordered]@{ path = 'w'; generator = 'g'; committed = $true }) }; Message = "*unknown key 'committed'*" }
    ) {
        { [Catzc.Base.Variants.GeneratedConfig]::new($Raw) } | Should -Throw -ExpectedMessage $Message
    }
}
