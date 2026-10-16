<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/tests/types/PythonConfig.Tests.ps1
    folder: tests/types
    name: python-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

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

        It 'resolves the Python root to python when the repository has a python/ folder, else to .python' {
            $config = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0' } })
            $withFolder = Join-Path $TestDrive 'with-python'
            $null = New-Item -ItemType Directory -Path (Join-Path $withFolder 'python') -Force
            $config.ResolveRoot($withFolder) | Should -Be 'python'
            $without = Join-Path $TestDrive 'without-python'
            $null = New-Item -ItemType Directory -Path $without -Force
            $config.ResolveRoot($without) | Should -Be '.python'
        }

        It 'resolves to the declared root whatever is on disk' {
            $config = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ root = 'test/py'; dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0' } })
            $config.root | Should -Be 'test/py'
            $config.ResolveRoot($TestDrive) | Should -Be 'test/py'
        }

        It 'rejects <Case>, naming it' -ForEach @(
            @{ Case = 'an unknown key'; Raw = [ordered]@{ dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0' }; gadget = 1 }; Message = "*unknown key 'gadget'*" }
            @{ Case = 'a missing pytest pin'; Raw = [ordered]@{ dependencies = [ordered]@{ ruff = '0.17.0' } }; Message = "*must pin 'pytest'*" }
            @{ Case = 'an empty file'; Raw = $null; Message = "*must pin 'pytest'*must pin 'ruff'*" }
            @{ Case = 'a version range'; Raw = [ordered]@{ dependencies = [ordered]@{ pytest = '>=9'; ruff = '0.17.0' } }; Message = "*dependencies.pytest '>=9'*exact version*" }
            @{ Case = 'a name that is not normalised'; Raw = [ordered]@{ dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0'; Widget_Kit = '1.0' } }; Message = "*'Widget_Kit'*normalised distribution name*" }
            @{ Case = 'dependencies that are not a map'; Raw = [ordered]@{ dependencies = 'pytest' }; Message = '*invalid dependencies*' }
            @{ Case = 'a root with a parent segment'; Raw = [ordered]@{ root = '../widget'; dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*invalid root '../widget'*" }
            @{ Case = 'a root with a leading slash'; Raw = [ordered]@{ root = '/widget'; dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*invalid root '/widget'*" }
        ) {
            { [Catzc.Base.Languages.PythonConfig]::new($Raw) } | Should -Throw $Message
        }
    }
}
