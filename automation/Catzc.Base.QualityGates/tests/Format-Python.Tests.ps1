# Format-Python with its seams mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
# the scope (Get-PythonCheckScope) and ruff run from the workspace (Invoke-PythonWorkspaceTool). Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Format-Python' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:pythonRoot = Join-Path $script:repo 'python'
        $script:widget = Join-Path $script:pythonRoot 'tests/catzc-widget'
        $script:widgetFile = Join-Path $script:widget 'test_widget.py'
        $script:helper = Join-Path $script:repo '.claude/widget/gadget.py'
        $null = New-Item -ItemType File -Path $script:widgetFile, $script:helper -Force
    }

    BeforeEach {
        $script:checkOutput = "Would reformat: tests\catzc-widget\test_widget.py`n1 file would be reformatted"
        $script:checkExit = 1
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Get-PythonCheckScope -ModuleName Catzc.Base.QualityGates { $script:widget; $script:helper }
        Mock Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'ruff format --check' } {
            [Catzc.Base.Execution.CliResult]::new($script:checkOutput, '', $script:checkExit)
        }
        Mock Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'ruff format' } {
            [Catzc.Base.Execution.CliResult]::new('1 file reformatted', '', 0)
        }
    }

    It 'checks every Python path in scope, then rewrites exactly the listed files' {
        $changed = Format-Python
        $changed | Should -Be @([System.IO.Path]::GetFullPath($script:widgetFile))
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'ruff format --check' -and ($File -join '|') -eq "$script:widget|$script:helper"
        }
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'ruff format' -and ($File -join '|') -eq [System.IO.Path]::GetFullPath($script:widgetFile)
        }
    }

    It 'reports without writing under -DryRun' {
        $result = Format-Python -DryRun -PassThru
        $result.ChangedCount | Should -Be 1
        $result.DryRun | Should -BeTrue
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Tool -eq 'ruff format' }
    }

    It 'writes nothing when every file is formatted' {
        $script:checkOutput = '2 files already formatted'
        $script:checkExit = 0
        @(Format-Python) | Should -HaveCount 0
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Tool -eq 'ruff format' }
    }

    It 'runs nothing when the repository holds no Python' {
        Mock Get-PythonCheckScope -ModuleName Catzc.Base.QualityGates { }
        (Format-Python -PassThru).ChangedCount | Should -Be 0
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'formats an explicit .py file, and refuses a file that is not .py, naming the generator' {
        $null = Format-Python -Path $script:helper
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'ruff format --check' -and ($File -join '|') -eq $script:helper
        }
        $project = Join-Path $script:pythonRoot 'pyproject.toml'
        $null = New-Item -ItemType File -Path $project -Force
        { Format-Python -Path $project } | Should -Throw '*is not a .py file*Build-RootConfig*'
    }

    It 'throws with ruff''s message when a file does not parse' {
        $script:checkOutput = 'error: Failed to parse tests\catzc-widget\test_widget.py:3:1'
        $script:checkExit = 2
        { Format-Python } | Should -Throw '*ruff could not format the Python files (exit 2)*Failed to parse*'
    }
}
