<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
    kind: test
---
#>

# Invoke-PythonWorkspaceTool with uv mocked (Resolve-ToolExecutable, Invoke-Executable) over a fixture workspace in
# $TestDrive. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Invoke-PythonWorkspaceTool' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:pythonRoot = Join-Path $script:repo 'python'
        $null = New-Item -ItemType File -Path (Join-Path $script:pythonRoot 'pyproject.toml') -Force
        $script:uvPath = 'C:\widget\uv\uv.exe'
    }

    BeforeEach {
        $script:syncExit = 0
        $script:seen = [System.Collections.Generic.List[object]]::new()
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'uv' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = $script:uvPath; Version = '0.11.26'; Required = '0.11' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            $script:seen.Add([pscustomobject]@{ Command = $Command; Directory = $WorkingDirectory; Downloads = $env:UV_PYTHON_DOWNLOADS })
            $exit = ($Command -like '* sync *') ? $script:syncExit : 0
            [Catzc.Base.Execution.CliResult]::new('ruff output', 'No interpreter found', $exit)
        }
    }

    It 'syncs the workspace, then runs the tool with the workspace config from the workspace root' {
        $result = InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'ruff check' -File 'C:\widget\a.py', 'C:\widget\b.py' }
        $result.Output | Should -Be 'ruff output'
        $script:seen.Command | Should -Be @(
            "`"$script:uvPath`" sync --all-packages --quiet"
            "`"$script:uvPath`" run --no-sync --quiet ruff check --config pyproject.toml `"C:\widget\a.py`" `"C:\widget\b.py`""
        )
        $script:seen.Directory | Sort-Object -Unique | Should -Be $script:pythonRoot
    }

    It 'never lets uv download an interpreter, and restores the variable' {
        $null = InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'ruff check' -File 'C:\widget\a.py' }
        @($script:seen.Downloads | Select-Object -Unique) | Should -Be @('never')
        Test-Path Env:UV_PYTHON_DOWNLOADS | Should -BeFalse
    }

    It 'throws with the remedy when the sync fails, running no tool' {
        $script:syncExit = 2
        { InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'ruff check' -File 'C:\widget\a.py' } } |
            Should -Throw '*uv sync failed*Run Install-Python*No interpreter found*'
        $script:seen.Count | Should -Be 1
    }

    It 'throws with "Run Install-Uv" when no uv at the pin is found' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'uv' } {
            [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '0.11' }
        }
        { InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'ruff check' -File 'C:\widget\a.py' } } |
            Should -Throw "*pin '0.11' (found: none)*Run Install-Uv*"
    }

    It 'throws with the remediation when the generated workspace is missing' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'empty' }
        $null = New-Item -ItemType Directory -Path (Join-Path $TestDrive 'empty/python') -Force
        { InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'ruff check' -File 'C:\widget\a.py' } } |
            Should -Throw '*python/pyproject.toml is missing*Build-RootConfig*'
    }
}
