<#
---
catzc:
  immutable:
    with_body_sha: "277c2ed3884b"
  edges:
    docs: "[Invoke-RuffFormat.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-RuffFormat.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Invoke-RuffFormat.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-AUTO-TEST-NOOVERMOCKING
---
#>

Describe 'Invoke-RuffFormat' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:pythonRoot = Join-Path $script:repo 'python'
        $script:widgetFile = [System.IO.Path]::GetFullPath((Join-Path $script:pythonRoot 'tests/catzc-widget/test_widget.py'))
        $script:helper = [System.IO.Path]::GetFullPath((Join-Path $script:repo '.claude/widget/gadget.py'))
        $null = New-Item -ItemType File -Path $script:widgetFile, $script:helper -Force
    }

    BeforeEach {
        $script:checkOutput = "Would reformat: tests\catzc-widget\test_widget.py`n1 file would be reformatted"
        $script:checkExit = 1
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'ruff format --check' } {
            [Catzc.Base.Execution.CliResult]::new($script:checkOutput, '', $script:checkExit)
        }
        Mock Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'ruff format' } {
            [Catzc.Base.Execution.CliResult]::new('1 file reformatted', '', 0)
        }
    }

    It 'checks every given file from the workspace, then rewrites exactly the listed files' {
        $changed = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widgetFile, $script:helper) } {
            param($Files)
            Invoke-RuffFormat -File $Files
        }
        $changed | Should -Be @($script:widgetFile)
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'ruff format --check' -and ($File -join '|') -eq "$script:widgetFile|$script:helper"
        }
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'ruff format' -and ($File -join '|') -eq $script:widgetFile
        }
    }

    It 'reports without writing under -DryRun, and writes nothing when every file is formatted' {
        $changed = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widgetFile) } {
            param($Files)
            Invoke-RuffFormat -File $Files -DryRun
        }
        $changed | Should -Be @($script:widgetFile)
        $script:checkOutput = '2 files already formatted'
        $script:checkExit = 0
        $none = InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widgetFile) } {
            param($Files)
            @(Invoke-RuffFormat -File $Files | ForEach-Object { $_ })
        }
        $none | Should -HaveCount 0
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Tool -eq 'ruff format' }
    }

    It 'runs nothing when there are no Python files' {
        $none = InModuleScope Catzc.Base.QualityGates { @(Invoke-RuffFormat -File @() | ForEach-Object { $_ }) }
        $none | Should -HaveCount 0
        Should -Invoke Invoke-PythonWorkspaceTool -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'throws with ruff''s message when a file does not parse' {
        $script:checkOutput = 'error: Failed to parse tests\catzc-widget\test_widget.py:3:1'
        $script:checkExit = 2
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Files = @($script:widgetFile) } { param($Files) Invoke-RuffFormat -File $Files } } |
            Should -Throw '*ruff could not format the Python files (exit 2)*Failed to parse*'
    }
}
