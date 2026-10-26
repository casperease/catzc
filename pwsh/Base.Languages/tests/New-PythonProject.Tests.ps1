<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/tests/New-PythonProject.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'New-PythonProject' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($file in 'python/tests/widget/test_widget.py', 'python/tests/gadget/nested/test_gadget.py',
            'python/tests/.cache/test_cache.py') {
            $path = Join-Path $script:root $file
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            Set-Content -LiteralPath $path -Value 'def test_widget(): pass'
        }
        # A folder left with only a generated file is not a member.
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'python/tests/leftover') -Force
        Set-Content -LiteralPath (Join-Path $script:root 'python/tests/leftover/pyproject.toml') -Value '[project]'
        # A module of the python track is a member too; a module folder without Python code, and a dot folder, are not.
        foreach ($file in 'python/widget_kit/kit.py', 'python/widget_empty/notes.md', 'python/.venv/lib/site.py') {
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
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'languages' } {
            [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{
                        python = [ordered]@{ extensions = @('.py'); no_formatter = 'never'; naming = [ordered]@{ folder = 'snake'; file = 'snake' } }
                    }
                })
        }
    }

    It 'renders the workspace root and one member per test folder and per module, root first, test folders then modules in order' {
        @(New-PythonProject -LineLength 140).Target | Should -Be @('python/pyproject.toml',
            'python/tests/gadget/pyproject.toml', 'python/tests/widget/pyproject.toml',
            'python/widget_kit/pyproject.toml')
    }

    It 'renders a virtual workspace root naming every member, with the ruff and pyright settings' {
        (New-PythonProject -LineLength 140 -Target 'python/pyproject.toml').Content | Should -BeExactly ((@(
                    '[tool.uv.workspace]'
                    'members = ['
                    '    "tests/gadget",'
                    '    "tests/widget",'
                    '    "widget_kit",'
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

    It 'renders the line length its caller passes as the ruff line-length' {
        (New-PythonProject -LineLength 99 -Target 'python/pyproject.toml').Content |
            Should -Match '(?m)^line-length = 99$'
    }

    It 'renders the declared type-checking mode for pyright' {
        $script:python['type_checking'] = 'strict'
        (New-PythonProject -LineLength 140 -Target 'python/pyproject.toml').Content |
            Should -Match '(?m)^typeCheckingMode = "strict"$'
    }

    It 'renders a module member named for its full name in kebab case, at the module root' -Tag 'DDR-TRACK-MODULENAMESPACE' {
        $content = (New-PythonProject -LineLength 140 -Target 'python/widget_kit/pyproject.toml').Content
        $content | Should -Match '(?m)^name = "catzc-widget-kit"$'
        $content | Should -Match '(?m)^package = true$'
    }

    It 'renders a module member as a package: the declared build backend, its import name mapped onto the short folder' -Tag 'DDR-TRACK-MODULENAMESPACE' {
        $content = (New-PythonProject -LineLength 140 -Target 'python/widget_kit/pyproject.toml').Content
        # -Match on the escaped text: a [section] header is a wildcard class to -BeLike.
        $content | Should -Match ('^' + [regex]::Escape((@(
                    '[build-system]'
                    "requires = [`"$([Catzc.Base.Languages.PythonConfig]::DefaultBuildDistribution)==$([Catzc.Base.Languages.PythonConfig]::DefaultBuildVersion)`"]"
                    "build-backend = `"$([Catzc.Base.Languages.PythonConfig]::DefaultBuildModule)`""
                    ''
                    '[project]'
                ) -join "`n")))
        $content | Should -Match ([regex]::Escape((@(
                        '[tool.setuptools]'
                        'packages = ["catzc.widget_kit"]'
                        ''
                        '[tool.setuptools.package-dir]'
                        '"catzc.widget_kit" = "."'
                        ''
                        '[tool.uv]'
                        'package = true'
                    ) -join "`n") + "`n") + '$')
    }

    It 'renders each member named for its full name, its folder under the namespace, at the python pin, with the pinned dependencies in name order' {
        (New-PythonProject -LineLength 140 -Target 'python/tests/widget/pyproject.toml').Content |
            Should -BeExactly ((@(
                        '[project]'
                        'name = "catzc_widget"'
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
        $null = New-Item -ItemType Directory -Path (Join-Path $declared 'test/py/tests/widget') -Force
        Set-Content -LiteralPath (Join-Path $declared 'test/py/tests/widget/test_widget.py') -Value 'def test_widget(): pass'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { Join-Path $TestDrive 'declared-repo' }
        $script:python['root'] = 'test/py'
        @(New-PythonProject -LineLength 140).Target | Should -Be @('test/py/pyproject.toml',
            'test/py/tests/widget/pyproject.toml')
    }

    It 'renders nothing when the repository has no Python test folder' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { Join-Path $TestDrive 'empty' }
        $null = New-Item -ItemType Directory -Path (Join-Path $TestDrive 'empty') -Force
        @(New-PythonProject -LineLength 140) | Should -HaveCount 0
    }

    It 'throws when the python pin is not a 3.N minor version' {
        $script:pin = '3.13.1'
        { New-PythonProject -LineLength 140 } | Should -Throw "*'3.13.1' is not a Python minor version*"
    }

    It 'throws when a test folder is not named in python''s folder case' -Tag 'ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM' {
        $bad = Join-Path $TestDrive 'bad-repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $bad 'python/tests/catzc-widget') -Force
        Set-Content -LiteralPath (Join-Path $bad 'python/tests/catzc-widget/test_widget.py') -Value 'def test_widget(): pass'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { Join-Path $TestDrive 'bad-repo' }
        { New-PythonProject -LineLength 140 } | Should -Throw '*python/tests/catzc-widget/*snake case*'
    }
}
