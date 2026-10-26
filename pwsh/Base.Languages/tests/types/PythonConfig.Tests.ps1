Describe 'PythonConfig' -Tag 'L0' {

    Context 'integrity (shipped python.yml)' -Tag 'integrity' {
        It 'loads the shipped python.yml as a PythonConfig, pinning pyright, pytest and ruff' {
            $config = Get-Config -Config python
            $config | Should -BeOfType [Catzc.Base.Languages.PythonConfig]
            $config.dependencies.Keys | Should -Contain 'pyright'
            $config.dependencies.Keys | Should -Contain 'pytest'
            $config.dependencies.Keys | Should -Contain 'ruff'
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        BeforeAll {
            $script:pins = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' }
        }

        It 'keeps the dependencies in ordinal name order, whatever the file order' {
            $config = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{
                    dependencies = [ordered]@{ ruff = '0.17.0'; 'widget-kit' = '1.2'; pytest = '9.1.1'; pyright = '1.1.414' }
                })
            @($config.dependencies.Keys) | Should -Be @('pyright', 'pytest', 'ruff', 'widget-kit')
            $config.dependencies['widget-kit'] | Should -Be '1.2'
        }

        It 'resolves the Python root to python when the repository has a python/ folder, else to .python' {
            $config = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = $script:pins })
            $withFolder = Join-Path $TestDrive 'with-python'
            $null = New-Item -ItemType Directory -Path (Join-Path $withFolder 'python') -Force
            $config.ResolveRoot($withFolder) | Should -Be 'python'
            $without = Join-Path $TestDrive 'without-python'
            $null = New-Item -ItemType Directory -Path $without -Force
            $config.ResolveRoot($without) | Should -Be '.python'
        }

        It 'resolves to the declared root whatever is on disk' {
            $config = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ root = 'test/py'; dependencies = $script:pins })
            $config.root | Should -Be 'test/py'
            $config.ResolveRoot($TestDrive) | Should -Be 'test/py'
        }

        It 'type-checks in standard mode unless the file names another' {
            ([Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = $script:pins })).type_checking |
                Should -Be 'standard'
            ([Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = $script:pins; type_checking = 'strict' })).type_checking | Should -Be 'strict'
        }

        It 'keeps the pytest and bytecode caches in their default folders unless the file names others' {
            $default = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = $script:pins })
            $default.pytest_cache | Should -Be ([Catzc.Base.Languages.PythonConfig]::DefaultPytestCache)
            $default.pycache | Should -Be ([Catzc.Base.Languages.PythonConfig]::DefaultPycache)
            $moved = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = $script:pins; pytest_cache = 'widget/cache'; pycache = 'gadget' })
            $moved.pytest_cache | Should -Be 'widget/cache'
            $moved.pycache | Should -Be 'gadget'
        }

        It 'builds with the declared backend unless the file names another, filling an omitted field from its default' {
            $default = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = $script:pins })
            $default.build_distribution | Should -Be ([Catzc.Base.Languages.PythonConfig]::DefaultBuildDistribution)
            $default.build_version | Should -Be ([Catzc.Base.Languages.PythonConfig]::DefaultBuildVersion)
            $default.build_module | Should -Be ([Catzc.Base.Languages.PythonConfig]::DefaultBuildModule)
            $moved = [Catzc.Base.Languages.PythonConfig]::new([ordered]@{
                    dependencies = $script:pins; build_backend = [ordered]@{ distribution = 'widget-build'; version = '1.2' }
                })
            $moved.build_distribution | Should -Be 'widget-build'
            $moved.build_version | Should -Be '1.2'
            $moved.build_module | Should -Be ([Catzc.Base.Languages.PythonConfig]::DefaultBuildModule)
        }

        It 'rejects <Case>, naming it' -ForEach @(
            @{ Case = 'a build backend version range'; Raw = [ordered]@{ build_backend = [ordered]@{ version = '>=80' }; dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*build_backend.version '>=80'*exact version*" }
            @{ Case = 'a build backend module that is no module name'; Raw = [ordered]@{ build_backend = [ordered]@{ module = 'widget build' }; dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*build_backend.module 'widget build'*" }
            @{ Case = 'an unknown build backend key'; Raw = [ordered]@{ build_backend = [ordered]@{ gadget = 1 }; dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*build_backend: unknown key 'gadget'*" }
            @{ Case = 'a build backend that is not a map'; Raw = [ordered]@{ build_backend = 'setuptools'; dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = '*invalid build_backend*' }
            @{ Case = 'an unknown key'; Raw = [ordered]@{ dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' }; gadget = 1 }; Message = "*unknown key 'gadget'*" }
            @{ Case = 'a missing pytest pin'; Raw = [ordered]@{ dependencies = [ordered]@{ pyright = '1.1.414'; ruff = '0.17.0' } }; Message = "*must pin 'pytest'*" }
            @{ Case = 'a missing pyright pin'; Raw = [ordered]@{ dependencies = [ordered]@{ pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*must pin 'pyright'*" }
            @{ Case = 'an empty file'; Raw = $null; Message = "*must pin 'pyright'*must pin 'pytest'*must pin 'ruff'*" }
            @{ Case = 'a version range'; Raw = [ordered]@{ dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '>=9'; ruff = '0.17.0' } }; Message = "*dependencies.pytest '>=9'*exact version*" }
            @{ Case = 'a name that is not normalised'; Raw = [ordered]@{ dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0'; Widget_Kit = '1.0' } }; Message = "*'Widget_Kit'*normalised distribution name*" }
            @{ Case = 'dependencies that are not a map'; Raw = [ordered]@{ dependencies = 'pytest' }; Message = '*invalid dependencies*' }
            @{ Case = 'a root with a parent segment'; Raw = [ordered]@{ root = '../widget'; dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*invalid root '../widget'*" }
            @{ Case = 'a root with a leading slash'; Raw = [ordered]@{ root = '/widget'; dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*invalid root '/widget'*" }
            @{ Case = 'an unknown type-checking mode'; Raw = [ordered]@{ type_checking = 'gadget'; dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*invalid type_checking 'gadget'*off, basic, standard, strict*" }
            @{ Case = 'a cache folder with a parent segment'; Raw = [ordered]@{ pycache = '../widget'; dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*invalid pycache '../widget'*" }
            @{ Case = 'the retired extra_paths key'; Raw = [ordered]@{ extra_paths = @('.widget'); dependencies = [ordered]@{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } }; Message = "*unknown key 'extra_paths'*" }
        ) {
            { [Catzc.Base.Languages.PythonConfig]::new($Raw) } | Should -Throw $Message
        }
    }
}
