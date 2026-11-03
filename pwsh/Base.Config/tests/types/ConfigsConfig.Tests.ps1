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
                Should -BeLike "*config 'b': unknown key 'pwsh' (allowed: type, scope, differs)*"
            $thrown.Exception.Message | Should -BeLike "*config 'c': an entry must specify a 'type'*"
        }

        It 'derives the sealed configs (scope: engine) and the working-root configs, in file order; absent means module' {
            $registry = [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{
                        widget  = @{ type = 'Tst.Widget' }
                        gadget  = @{ type = 'Tst.Gadget'; scope = 'engine' }
                        gizmo   = @{ type = 'Tst.Gizmo'; scope = 'module' }
                        bracket = @{ type = 'Tst.Bracket'; scope = 'working-root' }
                        cog     = @{ type = 'Tst.Cog'; scope = 'engine' }
                        lever   = @{ type = 'Tst.Lever'; scope = 'working-root' }
                    }
                })
            @($registry.sealedConfigs) | Should -Be @('gadget', 'cog')
            @($registry.workingRootConfigs) | Should -Be @('bracket', 'lever')
        }

        It 'treats an entry with no scope as module, in neither derived list' {
            $registry = [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget' } } })
            @($registry.sealedConfigs).Count | Should -Be 0
            @($registry.workingRootConfigs).Count | Should -Be 0
        }

        It 'rejects overridable as an unknown key, naming the allowed keys' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget'; overridable = $false } } }) } |
                Should -Throw "*config 'widget': unknown key 'overridable' (allowed: type, scope, differs)*"
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

        It 'rejects a scope outside engine, module and working-root, naming the allowed values' {
            { [Catzc.Base.Config.ConfigsConfig]::new(@{ configs = [ordered]@{ widget = @{ type = 'Tst.Widget'; scope = 'gadget' } } }) } |
                Should -Throw "*config 'widget': scope 'gadget' is not one of engine, module, working-root*"
        }

        It 'the shipped registry seals the engine-intrinsic configs' -Tag 'integrity' {
            $raw = Get-Content (Get-CatzcModuleRoot -Module Catzc.Base.Config 'configs/configs.yml') -Raw |
                ConvertFrom-Yaml -Ordered
            $registry = [Catzc.Base.Config.ConfigsConfig]::new($raw)
            foreach ($name in 'configs', 'dependencies', 'profiles', 'exporter', 'glossary') {
                @($registry.sealedConfigs) | Should -Contain $name
            }
            foreach ($name in 'variants', 'drs', 'plans', 'links', 'file-limits', 'go', 'python', 'javascript', 'analyzer-drs-map') {
                @($registry.workingRootConfigs) | Should -Contain $name
            }
        }
    }
}
