Describe 'ConfigsConfig' -Tag 'L0' {
    Context 'registry self-validation (Catzc.Base.Config.ConfigsConfig)' -Tag 'logic' {
        # Inline registries, so the validator's rules are proven apart from whatever the shipped registry holds today.
        It 'accepts a valid registry (one type per entry)' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ a = @{ type = 'Foo' }; b = @{ type = 'Bar' } } }) } |
                Should -Not -Throw
        }

        It 'exposes the registry as config name to type, in file order' {
            $registry = [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget' }; gadget = @{ type = ' Tst.Gadget ' } } })
            @($registry.configs.Keys) | Should -Be @('widget', 'gadget')
            $registry.configs['gadget'] | Should -Be 'Tst.Gadget'
        }

        It 'rejects an unknown top-level key and a non-map configs value' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ widget = 1 }) } |
                Should -Throw "*unknown top-level key 'widget' (allowed: configs)*"
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = 'gadget' }) } |
                Should -Throw "*'configs' must be a map*"
        }

        It 'accepts an absent or empty configs map' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{}) } | Should -Not -Throw
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{} }) } | Should -Not -Throw
        }

        It 'throws once listing every entry with no type or an unknown key' {
            $thrown = { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ a = @{ module = 'X' }; b = @{ type = 'Foo'; pwsh = 'Bar' }; c = $null } }) } |
                Should -Throw -PassThru
            $thrown.Exception.Message | Should -BeLike "*config 'a': an entry must specify a 'type'*"
            $thrown.Exception.Message |
                Should -BeLike "*config 'b': unknown key 'pwsh' (allowed: type, overridable, differs)*"
            $thrown.Exception.Message | Should -BeLike "*config 'c': an entry must specify a 'type'*"
        }

        It 'lists the sealed configs (overridable: false); absent means overridable' {
            $registry = [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{
                        widget = @{ type = 'Tst.Widget' }
                        gadget = @{ type = 'Tst.Gadget'; overridable = $false }
                        gizmo  = @{ type = 'Tst.Gizmo'; overridable = $true }
                    }
                })
            @($registry.sealedConfigs) | Should -Be @('gadget')
        }

        It 'reads each key a shipped value may differ on with its reason, and rejects a blank reason or a list' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $registry = [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{
                        widget = @{ type = 'Tst.Widget'; differs = [ordered]@{ size = 'The widgets ship large.' } }
                        gadget = @{ type = 'Tst.Gadget' }
                    }
                })
            $registry.differs['widget']['size'] | Should -BeExactly 'The widgets ship large.'
            $registry.differs.ContainsKey('gadget') | Should -BeFalse
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget'; differs = @{ size = ' ' } } } }) } |
                Should -Throw "*config 'widget': differs 'size' needs its reason*"
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget'; differs = @('size') } } }) } |
                Should -Throw "*config 'widget': differs must be a map*"
        }

        It 'compares a shipped key with the type''s Default constant of that key, scalars only' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $type = [Catzc.Base.Variants.VariantsConfig]
            $same = [Catzc.Base.Config.ConfigDefaultDifference]::Compare($type,
                [ordered]@{ naming = 'standard'; have_customers = $false })
            @($same).Count | Should -Be 0
            $differs = @([Catzc.Base.Config.ConfigDefaultDifference]::Compare($type,
                    [ordered]@{ naming = 'gadget'; tracks = @{ widgets = @{} }; widget_size = 3 }))
            $differs.Count | Should -Be 1
            $differs[0].key | Should -BeExactly 'naming'
            $differs[0].shipped | Should -BeExactly 'gadget'
            $differs[0].declared | Should -BeExactly 'standard'
            [Catzc.Base.Config.ConfigDefaultDifference]::Pascal('have_customers') | Should -BeExactly 'HaveCustomers'
        }

        It 'rejects an overridable that is not true or false' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget'; overridable = 'no' } } }) } |
                Should -Throw "*config 'widget': overridable must be true or false*"
        }

        It 'the shipped registry seals the engine-intrinsic configs' -Tag 'integrity' {
            $raw = Get-Content (Get-CatzcModuleRoot -Module Catzc.Base.Config 'configs/configs.yml') -Raw |
                ConvertFrom-Yaml -Ordered
            $registry = [Catzc.Base.Config.ConfigsConfig]::new($raw)
            foreach ($name in 'configs', 'dependencies', 'profiles', 'exporter', 'glossary') {
                @($registry.sealedConfigs) | Should -Contain $name
            }
        }
    }
}
