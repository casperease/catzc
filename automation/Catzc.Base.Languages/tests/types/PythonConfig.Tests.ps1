Describe 'PythonConfig' -Tag 'L0' {

    Context 'integrity (shipped python.yml)' -Tag 'integrity' {
        It 'loads the shipped python.yml as a PythonConfig, pinning pytest and ruff' {
            $config = Get-Config -Config python
            $config | Should -BeOfType [Catzc.Base.Languages.PythonConfig]
            $config.dependencies.Keys | Should -Contain 'pytest'
            $config.dependencies.Keys | Should -Contain 'ruff'
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'keeps the dependencies in ordinal name order, whatever the file order' {
            $config = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{
                    dependencies = [ordered]@{ ruff = '0.17.0'; 'widget-kit' = '1.2'; pytest = '9.1.1' }
                })
            @($config.dependencies.Keys) | Should -Be @('pytest', 'ruff', 'widget-kit')
            $config.dependencies['widget-kit'] | Should -Be '1.2'
        }

        It 'names the Python root once, as a constant' {
            [Catzc.Base.Languages.PythonConfig]::Root | Should -Be 'python'
        }

        It 'rejects <Case>, naming it' -ForEach @(
            @{ Case = 'an unknown key'; Raw = [ordered]@{ dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0' }; gadget = 1 }; Message = "*unknown key 'gadget'*" }
            @{ Case = 'a missing pytest pin'; Raw = [ordered]@{ dependencies = [ordered]@{ ruff = '0.17.0' } }; Message = "*must pin 'pytest'*" }
            @{ Case = 'an empty file'; Raw = $null; Message = "*must pin 'pytest'*must pin 'ruff'*" }
            @{ Case = 'a version range'; Raw = [ordered]@{ dependencies = [ordered]@{ pytest = '>=9'; ruff = '0.17.0' } }; Message = "*dependencies.pytest '>=9'*exact version*" }
            @{ Case = 'a name that is not normalised'; Raw = [ordered]@{ dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0'; Widget_Kit = '1.0' } }; Message = "*'Widget_Kit'*normalised distribution name*" }
            @{ Case = 'dependencies that are not a map'; Raw = [ordered]@{ dependencies = 'pytest' }; Message = '*invalid dependencies*' }
        ) {
            { [Catzc.Base.Languages.PythonConfig]::new($Raw) } | Should -Throw $Message
        }
    }
}
