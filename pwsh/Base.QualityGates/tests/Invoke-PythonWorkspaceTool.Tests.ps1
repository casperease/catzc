Describe 'Invoke-PythonWorkspaceTool' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:pythonRoot = Join-Path $script:repo 'python'
        $null = New-Item -ItemType File -Path (Join-Path $script:pythonRoot 'pyproject.toml') -Force
        $null = New-Item -ItemType File -Path (Join-Path $script:pythonRoot '.venv/pyvenv.cfg') -Force
        $script:uvPath = 'C:\widget\uv\uv.exe'
        $script:offline = 'UV_PYTHON_DOWNLOADS', 'UV_OFFLINE', 'PYRIGHT_PYTHON_USE_BUNDLED_PYRIGHT', 'PYRIGHT_PYTHON_IGNORE_WARNINGS',
        'npm_config_offline', 'PYRIGHT_PYTHON_FORCE_VERSION'
    }

    BeforeEach {
        $script:seen = [System.Collections.Generic.List[object]]::new()
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'uv' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = $script:uvPath; Version = '0.11.26'; Required = '0.11' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            $values = [ordered]@{}
            foreach ($name in $script:offline) {
                $values[$name] = [System.Environment]::GetEnvironmentVariable($name)
            }
            $script:seen.Add([pscustomobject]@{ Command = $Command; Directory = $WorkingDirectory; Environment = $values })
            [Catzc.Base.Execution.CliResult]::new('ruff output', '', 0)
        }
    }

    It 'runs the tool with the workspace config from the workspace root, and never syncs' {
        $result = InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'ruff check' -File 'C:\widget\a.py', 'C:\widget\b.py' }
        $result.Output | Should -Be 'ruff output'
        $script:seen.Command | Should -Be @(
            "`"$script:uvPath`" run --no-sync --quiet ruff check --config pyproject.toml `"C:\widget\a.py`" `"C:\widget\b.py`""
        )
        $script:seen.Directory | Should -Be $script:pythonRoot
    }

    It 'names the workspace config with the option the tool takes' {
        $null = InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'pyright --outputjson' -File 'C:\widget\a.py' -ConfigOption '--project' }
        $script:seen[-1].Command |
            Should -Be "`"$script:uvPath`" run --no-sync --quiet pyright --outputjson --project pyproject.toml `"C:\widget\a.py`""
    }

    It 'holds uv and pyright''s wrapper offline at the pinned, bundled pyright, and restores every variable' {
        $null = InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'pyright --outputjson' -File 'C:\widget\a.py' }
        $seen = $script:seen[0].Environment
        $seen['UV_PYTHON_DOWNLOADS'] | Should -Be 'never'
        $seen['UV_OFFLINE'] | Should -Be '1'
        $seen['PYRIGHT_PYTHON_USE_BUNDLED_PYRIGHT'] | Should -Be '1'
        $seen['PYRIGHT_PYTHON_IGNORE_WARNINGS'] | Should -Be '1'
        $seen['npm_config_offline'] | Should -Be 'true'
        $seen['PYRIGHT_PYTHON_FORCE_VERSION'] | Should -Be '1.1.414'
        foreach ($name in $script:offline) {
            [System.Environment]::GetEnvironmentVariable($name) | Should -BeNullOrEmpty -Because "$name is set for the tool only"
        }
    }

    It 'throws naming the sync command, running nothing, when the workspace environment is missing' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'unsynced' }
        $null = New-Item -ItemType File -Path (Join-Path $TestDrive 'unsynced/python/pyproject.toml') -Force
        { InModuleScope Catzc.Base.QualityGates { Invoke-PythonWorkspaceTool -Tool 'ruff check' -File 'C:\widget\a.py' } } |
            Should -Throw '*python/.venv is not synced*Install-PythonWorkspace*'
        $script:seen.Count | Should -Be 0
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
