Describe 'GeneratedConfig' -Tag 'L0', 'logic' {
    It 'reads each writer row by its name, in order' {
        $config = [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{
                writers = [ordered]@{
                    'Build-WidgetIndex' = [ordered]@{ class = 'rollable'; inputs = @('widgets/*.yml'); outputs = @('widgets/index.md') }
                    'Build-Gadget' = [ordered]@{ class = 'untracked'; check = 'none'; outputs = @('gadgets/**') }
                }
            })
        @($config.writers | ForEach-Object name) | Should -Be @('Build-WidgetIndex', 'Build-Gadget')
        @($config.writers | ForEach-Object class) | Should -Be @('rollable', 'untracked')
        @($config.writers[0].outputs | ForEach-Object path) | Should -Be @('widgets/index.md')
    }

    It 'has no writers when it declares none' {
        @([Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{}).writers) | Should -HaveCount 0
        @([Catzc.Base.Variants.GeneratedConfig]::new($null).writers) | Should -HaveCount 0
    }

    It 'gives an omitted key its default' {
        $row = [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{
                writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; outputs = @('widgets/x.md') } }
            }).writers[0]
        $row.check | Should -Be ([Catzc.Base.Variants.GeneratedWriterRow]::DefaultCheck)
        $row.result_path | Should -Be ([Catzc.Base.Variants.GeneratedWriterRow]::DefaultResultPath)
        $row.at_import | Should -BeFalse
        @($row.inputs) | Should -HaveCount 0
        $row.expands | Should -BeNullOrEmpty
        $row.regenerate | Should -BeNullOrEmpty
        $row.remove | Should -BeNullOrEmpty
    }

    It 'reads every key a row may set' {
        $row = [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{
                writers = [ordered]@{
                    'Build-Widget' = [ordered]@{
                        class = 'import-critical'; check = 'file'; result_path = 'Widget'; at_import = $true; inputs = @('widgets/*.yml')
                        outputs = @('widgets/x.md'); expands = 'widgets'; regenerate = 'Build-Widget'; remove = 'Remove-Widget'
                    }
                }
            }).writers[0]
        $row.class | Should -Be 'import-critical'
        $row.result_path | Should -Be 'Widget'
        $row.at_import | Should -BeTrue
        $row.expands | Should -Be 'widgets'
        $row.regenerate | Should -Be 'Build-Widget'
        $row.remove | Should -Be 'Remove-Widget'
    }

    It 'gives a check other than file no result path' {
        $row = [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{
                writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'snapshot'; check = 'root-config'; outputs = @('widgets/x.md') } }
            }).writers[0]
        $row.result_path | Should -BeNullOrEmpty
    }

    It 'gives a bare output its writer''s inputs, and a mapped output its own' {
        $row = [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{
                writers = [ordered]@{
                    'Build-Widget' = [ordered]@{
                        class = 'rollable'; inputs = @('widgets/a.yml', 'widgets/b.yml')
                        outputs = @('widgets/all.md', [ordered]@{ path = 'widgets/a.md'; inputs = @('widgets/a.yml') })
                    }
                }
            }).writers[0]
        @($row.outputs[0].inputs) | Should -Be @('widgets/a.yml', 'widgets/b.yml')
        @($row.outputs[1].inputs) | Should -Be @('widgets/a.yml')
        $row.outputs[1].path | Should -Be 'widgets/a.md'
    }

    It 'refuses <Case>' -ForEach @(
        @{ Case = 'an unknown key'; Raw = [ordered]@{ widgets = @() }; Message = "*unknown key 'widgets'*" }
        @{ Case = 'writers as a list'; Raw = [ordered]@{ writers = @('Build-Widget') }; Message = '*writers must be a mapping*' }
        @{ Case = 'a row that is no mapping'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = 'widgets/x.md' } }; Message = "*writer 'Build-Widget' must be a mapping*" }
        @{ Case = 'an unknown row key'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; outputs = @('w'); committed = $true } } }; Message = "*unknown key 'committed'*" }
        @{ Case = 'a row without a class'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ outputs = @('w') } } }; Message = '*must name one of: rollable*' }
        @{ Case = 'an unknown class'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'gadget'; outputs = @('w') } } }; Message = "*class 'gadget'*" }
        @{ Case = 'an unknown check'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; check = 'gadget'; outputs = @('w') } } }; Message = "*unknown check 'gadget'*" }
        @{ Case = 'a result path on another check'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; check = 'none'; result_path = 'Widget'; outputs = @('w') } } }; Message = '*sets result_path*' }
        @{ Case = 'no outputs'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable' } } }; Message = '*declares no outputs*' }
        @{ Case = 'empty outputs'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; outputs = @() } } }; Message = '*declares no outputs*' }
        @{ Case = 'outputs as one string'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; outputs = 'w' } } }; Message = '*declares no outputs*' }
        @{ Case = 'a backslash output'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; outputs = @('widgets\x.md') } } }; Message = "*'/'-separated*" }
        @{ Case = 'a rooted output'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; outputs = @('/widgets/x.md') } } }; Message = "*'/'-separated*" }
        @{ Case = 'a mapped output without a path'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; outputs = @([ordered]@{ inputs = @('w.yml') }) } } }; Message = "*output path ''*" }
        @{ Case = 'an unknown output key'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; outputs = @([ordered]@{ path = 'w'; gadget = 1 }) } } }; Message = "*output carries unknown key 'gadget'*" }
        @{ Case = 'a backslash input'; Raw = [ordered]@{ writers = [ordered]@{ 'Build-Widget' = [ordered]@{ class = 'rollable'; inputs = @('widgets\a.yml'); outputs = @('w') } } }; Message = "*input 'widgets\a.yml'*" }
    ) {
        { [Catzc.Base.Variants.GeneratedConfig]::new($Raw) } | Should -Throw -ExpectedMessage $Message
    }

    It 'refuses a row with no name' {
        { [Catzc.Base.Variants.GeneratedWriterRow]::new('', [ordered]@{ class = 'rollable'; outputs = @('w') }) } |
            Should -Throw -ExpectedMessage '*names no writer*'
    }
}
