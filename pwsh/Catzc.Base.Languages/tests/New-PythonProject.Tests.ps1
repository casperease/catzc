Describe 'New-PythonProject' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($file in 'python/tests/catzc-widget/test_widget.py', 'python/tests/catzc-gadget/nested/test_gadget.py', 'python/tests/.cache/test_cache.py') {
            $path = Join-Path $script:root $file
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            Set-Content -LiteralPath $path -Value 'def test_widget(): pass'
        }
        # A folder left with only a generated file is not a member.
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'python/tests/catzc-leftover') -Force
        Set-Content -LiteralPath (Join-Path $script:root 'python/tests/catzc-leftover/pyproject.toml') -Value '[project]'
        # A module of the python track is a member too; a module folder without Python code, and a dot folder, are not.
        foreach ($file in 'python/Widget.Kit/kit.py', 'python/Widget.Empty/notes.md', 'python/.venv/lib/site.py') {
            $path = Join-Path $script:root $file
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            Set-Content -LiteralPath $path -Value 'kit = 1'
        }
    }

    BeforeEach {
        $script:pin = '3.13'
        $script:python = @{ dependencies = [ordered]@{ ruff = '0.17.0'; pytest = '9.1.1'; pyright = '1.1.414'; 'widget-kit' = '1.2' } }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'python' } { [Catzc.Base.Languages.PythonConfig]::new($script:python) }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.python.version' } { $script:pin }
    }

    It 'renders the workspace root and one member per test folder and per module, root first, test folders then modules in order' {
        @(New-PythonProject).Target | Should -Be @('python/pyproject.toml', 'python/tests/catzc-gadget/pyproject.toml', 'python/tests/catzc-widget/pyproject.toml', 'python/Widget.Kit/pyproject.toml')
    }

    It 'renders a virtual workspace root naming every member, with the ruff and pyright settings' {
        (New-PythonProject -Target 'python/pyproject.toml').Content | Should -BeExactly ((@(
                    '[tool.uv.workspace]'
                    'members = ['
                    '    "tests/catzc-gadget",'
                    '    "tests/catzc-widget",'
                    '    "Widget.Kit",'
                    ']'
                    ''
                    '[tool.ruff]'
                    'line-length = 140'
                    'target-version = "py313"'
                    ''
                    '[tool.pyright]'
                    'pythonVersion = "3.13"'
                    'typeCheckingMode = "standard"'
                ) -join "`n") + "`n")
    }

    It 'renders the declared type-checking mode for pyright' {
        $script:python['type_checking'] = 'strict'
        (New-PythonProject -Target 'python/pyproject.toml').Content | Should -Match '(?m)^typeCheckingMode = "strict"$'
    }

    It 'renders a module member named for the module in kebab case, at the module root' {
        $content = (New-PythonProject -Target 'python/Widget.Kit/pyproject.toml').Content
        $content | Should -Match '(?m)^name = "widget-kit"$'
        $content | Should -Match '(?m)^package = false$'
    }

    It 'renders each member named for its folder, at the python pin, with the pinned dependencies in name order' {
        (New-PythonProject -Target 'python/tests/catzc-widget/pyproject.toml').Content | Should -BeExactly ((@(
                    '[project]'
                    'name = "catzc-widget"'
                    'version = "0.0.0"'
                    'requires-python = "==3.13.*"'
                    'dependencies = ['
                    '    "pyright==1.1.414",'
                    '    "pytest==9.1.1",'
                    '    "ruff==0.17.0",'
                    '    "widget-kit==1.2",'
                    ']'
                    ''
                    '[tool.uv]'
                    'package = false'
                ) -join "`n") + "`n")
    }

    It 'renders under the declared root' {
        $declared = Join-Path $TestDrive 'declared-repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $declared 'test/py/tests/catzc-widget') -Force
        Set-Content -LiteralPath (Join-Path $declared 'test/py/tests/catzc-widget/test_widget.py') -Value 'def test_widget(): pass'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { Join-Path $TestDrive 'declared-repo' }
        $script:python['root'] = 'test/py'
        @(New-PythonProject).Target | Should -Be @('test/py/pyproject.toml', 'test/py/tests/catzc-widget/pyproject.toml')
    }

    It 'renders nothing when the repository has no Python test folder' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { Join-Path $TestDrive 'empty' }
        $null = New-Item -ItemType Directory -Path (Join-Path $TestDrive 'empty') -Force
        @(New-PythonProject) | Should -HaveCount 0
    }

    It 'throws when the python pin is not a 3.N minor version' {
        $script:pin = '3.13.1'
        { New-PythonProject } | Should -Throw "*'3.13.1' is not a Python minor version*"
    }

    It 'throws when a test folder is not named in kebab case' {
        $bad = Join-Path $TestDrive 'bad-repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $bad 'python/tests/Catzc.Widget') -Force
        Set-Content -LiteralPath (Join-Path $bad 'python/tests/Catzc.Widget/test_widget.py') -Value 'def test_widget(): pass'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { Join-Path $TestDrive 'bad-repo' }
        { New-PythonProject } | Should -Throw '*python/tests/Catzc.Widget/*kebab case*'
    }
}
