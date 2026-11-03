Describe 'Install-PythonWorkspace' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:pythonRoot = Join-Path $script:repo 'python'
        $null = New-Item -ItemType File -Path (Join-Path $script:pythonRoot 'pyproject.toml') -Force
        $script:uvPath = 'C:\widget\uv\uv.exe'
    }

    BeforeEach {
        $script:syncExit = 0
        $script:firstRunExit = 0
        $script:seen = [System.Collections.Generic.List[object]]::new()
        Mock Write-Message -ModuleName Catzc.Tooling.Python { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Python { $script:repo }
        Mock Get-Config -ModuleName Catzc.Tooling.Python -ParameterFilter { $Config -eq 'python' } {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } })
        }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Tooling.Python -ParameterFilter { $Tool -eq 'uv' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = $script:uvPath; Version = '0.11.26'; Required = '0.11' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Python {
            $script:seen.Add([pscustomobject]@{ Command = $Command; Directory = $WorkingDirectory; Downloads = $env:UV_PYTHON_DOWNLOADS
                    Username = $env:UV_INDEX_WIDGET_FEED_USERNAME; Password = $env:UV_INDEX_WIDGET_FEED_PASSWORD
                })
            $exit = ($Command -like '* sync *') ? $script:syncExit : $script:firstRunExit
            [Catzc.Base.Execution.CliResult]::new('', 'No interpreter found', $exit)
        }
    }

    It 'syncs the whole workspace, then makes pyright''s first run, from the workspace root' {
        Install-PythonWorkspace
        $script:seen.Command | Should -Be @(
            "`"$script:uvPath`" sync --all-packages --quiet"
            "`"$script:uvPath`" run --no-sync --quiet pyright --version"
        )
        $script:seen.Directory | Sort-Object -Unique | Should -Be $script:pythonRoot
    }

    It 'reinstalls each named package' {
        Install-PythonWorkspace -ReinstallPackage widget-sprockets, gadget-cogs
        $script:seen.Command[0] |
            Should -Be "`"$script:uvPath`" sync --all-packages --quiet --reinstall-package widget-sprockets --reinstall-package gadget-cogs"
    }

    It 'never lets uv download an interpreter, and restores the variable' {
        Install-PythonWorkspace
        @($script:seen.Downloads | Select-Object -Unique) | Should -Be @('never')
        Test-Path Env:UV_PYTHON_DOWNLOADS | Should -BeFalse
    }

    It 'exports no index credential variable for a source without a credential' {
        Install-PythonWorkspace
        @($script:seen | Where-Object { $_.Username -or $_.Password }) | Should -HaveCount 0
        @(Get-ChildItem Env: | Where-Object Name -like 'UV_INDEX_*') | Should -HaveCount 0
    }

    Context 'a source that names a credential variable' {
        BeforeEach {
            Mock Get-Config -ModuleName Catzc.Tooling.Python -ParameterFilter { $Config -eq 'python' } {
                [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'
                        dependencies                             = @{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' }
                        package_source                           = @{ name = 'widget-feed'; url = 'https://widget.example/simple'; credential_env = 'WIDGET_FEED_TOKEN' }
                    })
            }
        }

        AfterEach {
            Remove-Item -LiteralPath Env:WIDGET_FEED_TOKEN -ErrorAction Ignore
        }

        It 'exports the username and password pair during the sync and removes both after' {
            $env:WIDGET_FEED_TOKEN = 'widget-secret'
            Install-PythonWorkspace
            $script:seen[0].Username | Should -Be '__token__'
            $script:seen[0].Password | Should -Be 'widget-secret'
            Test-Path Env:UV_INDEX_WIDGET_FEED_USERNAME | Should -BeFalse
            Test-Path Env:UV_INDEX_WIDGET_FEED_PASSWORD | Should -BeFalse
        }

        It 'throws naming the variable and the source when the variable is unset, running nothing' {
            { Install-PythonWorkspace } | Should -Throw "*'widget-feed'*WIDGET_FEED_TOKEN*not set*"
            $script:seen.Count | Should -Be 0
        }
    }

    It 'throws with the remedy when the sync fails, running nothing more' {
        $script:syncExit = 2
        { Install-PythonWorkspace } | Should -Throw '*uv sync failed*Run Install-Python*No interpreter found*'
        $script:seen.Count | Should -Be 1
    }

    It 'throws with "Run Install-NodeJs" when pyright cannot start' {
        $script:firstRunExit = 1
        { Install-PythonWorkspace } | Should -Throw '*pyright could not start*Run Install-NodeJs*'
    }

    It 'throws with "Run Install-Uv" when no uv at the pin is found' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Tooling.Python -ParameterFilter { $Tool -eq 'uv' } {
            [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '0.11' }
        }
        { Install-PythonWorkspace } | Should -Throw "*pin '0.11' (found: none)*Run Install-Uv*"
        $script:seen.Count | Should -Be 0
    }

    It 'throws with the remediation when the generated workspace is missing' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Python { Join-Path $TestDrive 'empty' }
        $null = New-Item -ItemType Directory -Path (Join-Path $TestDrive 'empty/python') -Force
        { Install-PythonWorkspace } | Should -Throw '*python/pyproject.toml is missing*Build-RootConfig*'
    }
}
