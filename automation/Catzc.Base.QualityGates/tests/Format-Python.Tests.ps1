# Format-Python with its seams mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
# the Python test folders (Get-LanguageTestFolders), the tool probe (Resolve-ToolExecutable) finding a managed uv, and
# ruff through uv (Invoke-Executable). Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Format-Python' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:pythonRoot = Join-Path $script:repo 'python'
        $script:widget = Join-Path $script:pythonRoot 'tests/catzc-widget'
        $script:widgetFile = Join-Path $script:widget 'test_widget.py'
        $null = New-Item -ItemType File -Path $script:widgetFile -Force
        $script:uvPath = 'C:\widget\uv\uv.exe'
    }

    BeforeEach {
        $script:checkOutput = "Would reformat: tests\catzc-widget\test_widget.py`n1 file would be reformatted"
        $script:checkExit = 1
        $script:downloads = $null
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Widget'; Folder = 'C:\widget\go\tests\catzc-widget'; Name = 'catzc-widget' }
            [pscustomobject]@{ Language = 'python'; Module = 'Catzc.Widget'; Folder = $script:widget; Name = 'catzc-widget' }
        }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'uv' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = $script:uvPath; Version = '0.11.26'; Required = '0.11' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like '* ruff format --check *' } {
            $script:downloads = $env:UV_PYTHON_DOWNLOADS
            [Catzc.Base.Execution.CliResult]::new($script:checkOutput, '', $script:checkExit)
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -notlike '* --check *' } { }
    }

    It 'checks only the Python test folders from the Python root, then rewrites exactly the listed files' {
        $changed = Format-Python
        $changed | Should -Be @([System.IO.Path]::GetFullPath($script:widgetFile))
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq "`"$script:uvPath`" run --quiet ruff format --check `"$script:widget`"" -and $WorkingDirectory -eq $script:pythonRoot
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq "`"$script:uvPath`" run --quiet ruff format `"$([System.IO.Path]::GetFullPath($script:widgetFile))`""
        }
    }

    It 'never lets uv download an interpreter, and restores the variable' {
        $null = Format-Python -DryRun
        $script:downloads | Should -Be 'never'
        Test-Path Env:UV_PYTHON_DOWNLOADS | Should -BeFalse
    }

    It 'reports without writing under -DryRun' {
        $result = Format-Python -DryRun -PassThru
        $result.ChangedCount | Should -Be 1
        $result.DryRun | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Command -notlike '* --check *' }
    }

    It 'writes nothing when every file is formatted' {
        $script:checkOutput = '1 file already formatted'
        $script:checkExit = 0
        @(Format-Python) | Should -HaveCount 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Command -notlike '* --check *' }
    }

    It 'needs no uv when there are no Python test folders' {
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates { }
        (Format-Python -PassThru).ChangedCount | Should -Be 0
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'throws with "Run Install-Uv" when no uv at the pin is found' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'uv' } {
            [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '0.11' }
        }
        { Format-Python } | Should -Throw "*pin '0.11' (found: none)*Run Install-Uv*"
    }

    It 'refuses a file that is not .py, naming the generator' {
        $project = Join-Path $script:pythonRoot 'pyproject.toml'
        $null = New-Item -ItemType File -Path $project -Force
        { Format-Python -Path $project } | Should -Throw '*is not a .py file*Build-RootConfig*'
    }

    It 'throws with ruff''s message when a source does not parse' {
        $script:checkOutput = 'error: Failed to parse tests\catzc-widget\test_widget.py:3:1'
        $script:checkExit = 2
        { Format-Python } | Should -Throw '*ruff could not format the Python files (exit 2)*Failed to parse*'
    }
}
