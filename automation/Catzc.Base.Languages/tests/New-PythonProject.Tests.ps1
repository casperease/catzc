# New-PythonProject with its two sources mocked: python.yml (Get-Config) and the python pin in tools.yml
# (Get-ConfigValue). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'New-PythonProject' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:pin = '3.13'
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new([ordered]@{ dependencies = [ordered]@{ ruff = '0.17.0'; pytest = '9.1.1'; 'widget-kit' = '1.2' } })
        }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.python.version' } { $script:pin }
    }

    It 'renders the generated header, the virtual project, the pinned dependencies in name order, and the ruff settings' {
        New-PythonProject | Should -BeExactly ((@(
                    '# GENERATED FILE — do not edit. Single source of truth:'
                    '#   automation/Catzc.Base.Languages/configs/python.yml (rendered by New-PythonProject)'
                    '#   requires-python: the python pin in automation/Catzc.Tooling.Core/configs/tools.yml'
                    '# Regenerated on import by Build-RootConfig; edit the yml, not this file.'
                    ''
                    '[project]'
                    'name = "catzc-python-tests"'
                    'version = "0.0.0"'
                    'requires-python = "==3.13.*"'
                    'dependencies = ['
                    '    "pytest==9.1.1",'
                    '    "ruff==0.17.0",'
                    '    "widget-kit==1.2",'
                    ']'
                    ''
                    '[tool.uv]'
                    'package = false'
                    ''
                    '[tool.ruff]'
                    'line-length = 140'
                    'target-version = "py313"'
                ) -join "`n") + "`n")
    }

    It 'throws when the python pin is not a 3.N minor version' {
        $script:pin = '3.13.1'
        { New-PythonProject } | Should -Throw "*'3.13.1' is not a Python minor version*"
    }
}
