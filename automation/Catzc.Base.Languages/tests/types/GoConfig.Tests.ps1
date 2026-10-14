Describe 'GoConfig' -Tag 'L0' {

    Context 'integrity (shipped go.yml)' -Tag 'integrity' {
        It 'loads the shipped go.yml as a GoConfig' {
            Get-Config -Config go | Should -BeOfType [Catzc.Base.Languages.GoConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'takes the declared defaults for an empty or absent file' {
            foreach ($raw in [ordered]@{}, $null) {
                $config = [Catzc.Base.Languages.GoConfig]::new($raw)
                $config.go_version | Should -Be ([Catzc.Base.Languages.GoConfig]::DefaultGoVersion)
                $config.module_root | Should -Be ([Catzc.Base.Languages.GoConfig]::DefaultModuleRoot)
                $config.dependencies.Count | Should -Be 0
            }
        }

        It 'treats a key set to null like an omitted key' {
            $config = [Catzc.Base.Languages.GoConfig]::new([ordered]@{ go_version = $null; module_root = $null; dependencies = $null })
            $config.go_version | Should -Be '1.24'
            $config.module_root | Should -Be 'catzc/go/tests'
        }

        It 'maps every key' {
            $config = [Catzc.Base.Languages.GoConfig]::new([ordered]@{
                    go_version   = '1.23.4'
                    module_root  = 'acme/go/tests'
                    dependencies = [ordered]@{ 'example.com/widget' = 'v1.2.3-rc.1' }
                })
            $config.go_version | Should -Be '1.23.4'
            $config.module_root | Should -Be 'acme/go/tests'
            $config.dependencies['example.com/widget'] | Should -Be 'v1.2.3-rc.1'
        }

        It 'keeps the dependencies in ordinal path order, whatever the file order' {
            $config = [Catzc.Base.Languages.GoConfig]::new([ordered]@{
                    dependencies = [ordered]@{ 'example.com/widget' = 'v1.0.0'; 'example.com/Gadget' = 'v2.0.0'; 'example.com/assert' = 'v0.1.0' }
                })
            @($config.dependencies.Keys) | Should -Be @('example.com/Gadget', 'example.com/assert', 'example.com/widget')
        }

        It 'throws on an unknown key' {
            { [Catzc.Base.Languages.GoConfig]::new([ordered]@{ gadget = '1.24' }) } | Should -Throw "*unknown key 'gadget'*"
        }

        It 'throws on a go_version that is not a quoted 1.N or 1.N.P' -ForEach @('2.0', '1', '1.24rc1', 'v1.24', 1.24) {
            { [Catzc.Base.Languages.GoConfig]::new([ordered]@{ go_version = $_ }) } | Should -Throw '*invalid go_version*'
        }

        It 'throws on a malformed module_root' -ForEach @('/acme/go', 'acme/go/', 'Acme/go', 'acme//go') {
            { [Catzc.Base.Languages.GoConfig]::new([ordered]@{ module_root = $_ }) } | Should -Throw '*invalid module_root*'
        }

        It 'throws on dependencies that are not a map' {
            { [Catzc.Base.Languages.GoConfig]::new([ordered]@{ dependencies = @('example.com/widget') }) } | Should -Throw '*invalid dependencies (must be a map*'
        }

        It 'throws on a dependency path without a dot in its first segment' {
            { [Catzc.Base.Languages.GoConfig]::new([ordered]@{ dependencies = @{ 'widget/gadget' = 'v1.0.0' } }) } |
                Should -Throw "*invalid dependencies key 'widget/gadget'*"
        }

        It 'throws on a dependency version that is not vX.Y.Z' -ForEach @('1.0.0', 'v1.0', 'latest') {
            { [Catzc.Base.Languages.GoConfig]::new([ordered]@{ dependencies = @{ 'example.com/widget' = $_ } }) } |
                Should -Throw "*invalid dependencies.example.com/widget '$_'*"
        }

        It 'reports every violation in one throw' {
            $err = { [Catzc.Base.Languages.GoConfig]::new([ordered]@{ nope = 1; go_version = '9'; module_root = '/x'; dependencies = @{ gadget = 'x' } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'nope'*"
            $err.Exception.Message | Should -BeLike "*invalid go_version '9'*"
            $err.Exception.Message | Should -BeLike "*invalid module_root '/x'*"
            $err.Exception.Message | Should -BeLike "*invalid dependencies key 'gadget'*"
            $err.Exception.Message | Should -BeLike "*invalid dependencies.gadget 'x'*"
        }
    }
}
