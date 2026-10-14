Describe 'Invoke-PythonTest' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the seams ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): a
        # fixture repository root in $TestDrive, a mocked tool probe (Resolve-ToolExecutable) that finds a managed uv
        # at a fixture path with a space in it, and a mocked uv (Invoke-Executable) whose pytest writes a canned JUnit
        # report from tests/assets to the path the command names.
        $script:root = Join-Path $TestDrive 'repo'
        $script:pythonRoot = Join-Path $script:root 'python'
        $script:folder = Join-Path $script:pythonRoot 'tests/catzc-widget'
        $null = New-Item -ItemType Directory -Path $script:folder -Force
        Set-Content -LiteralPath (Join-Path $script:pythonRoot 'pyproject.toml') -Value '[project]'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:pythonRoot 'tests/catzc-gadget') -Force
        $script:buildEntry = Join-Path $TestDrive 'build/Import-Catzc.ps1'
        $null = New-Item -ItemType File -Path $script:buildEntry -Force
        $script:widgetReport = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/pytest-widget.xml')

        $script:uvPath = Join-Path $TestDrive 'managed uv/uv.exe'
        $script:uv = "`"$($script:uvPath)`""

        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
    }

    BeforeEach {
        $script:report = $script:widgetReport
        $script:testExit = 1
        $script:syncExit = 0
        $script:lintExit = 0
        $script:seen = [System.Collections.Generic.List[object]]::new()
        $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('uv', $script:uvPath, 'path', '0.11.26', '0.11', $true, 1, 0, 'Agent')
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Languages { $script:probe }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.Languages { 'C:\widget\engine\pwsh.exe' }
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages {
            $script:seen.Add([pscustomobject]@{
                    Command    = $Command
                    Directory  = $WorkingDirectory
                    Executable = $env:CATZC_ENGINE_EXECUTABLE
                    Start      = $env:CATZC_ENGINE_START
                    Root       = $env:CATZC_REPOSITORY_ROOT
                    Downloads  = $env:UV_PYTHON_DOWNLOADS
                })
            switch -Wildcard ($Command) {
                '* sync *' {
                    [Catzc.Base.Execution.CliResult]::new('', 'No interpreter found for Python ==3.13.*', $script:syncExit)
                }
                '* ruff check *' {
                    [Catzc.Base.Execution.CliResult]::new('tests/catzc-widget/test_widget.py:3:1: F401 unused import', '', $script:lintExit)
                }
                '* pytest *' {
                    if ($script:report) {
                        $path = [regex]::Match($Command, '--junitxml "([^"]+)"').Groups[1].Value
                        [System.IO.File]::WriteAllText($path, $script:report)
                    }
                    [Catzc.Base.Execution.CliResult]::new('pytest output', '', $script:testExit)
                }
            }
        }
    }

    Context 'the uv commands' {
        It 'runs uv sync, ruff check on the folder, then pytest on the folder from the Python root' {
            $null = Invoke-PythonTest Catzc.Widget
            $script:seen.Command[0] | Should -Be "$script:uv sync --quiet"
            $script:seen.Command[1] | Should -Be "$script:uv run --quiet ruff check `"tests/catzc-widget`""
            $script:seen.Command[2] | Should -BeLike "$script:uv run --quiet pytest `"tests/catzc-widget`" --rootdir `"tests/catzc-widget`" --import-mode=importlib -p no:cacheprovider --junitxml *"
            $script:seen.Directory | Sort-Object -Unique | Should -Be $script:pythonRoot
        }

        It 'runs the caller''s -UvExecutable without locating uv itself' {
            $callerUv = Join-Path $TestDrive 'caller uv/uv.exe'
            $null = New-Item -ItemType File -Path $callerUv -Force
            $null = Invoke-PythonTest Catzc.Widget -UvExecutable $callerUv
            Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Languages -Times 0 -Exactly
            $script:seen.Command[0] | Should -Be "`"$callerUv`" sync --quiet"
        }

        It 'throws with "Run Install-Uv" when no managed uv is found, before running anything' {
            $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('uv', $null, 'none', $null, '0.11', $false, 1, 0, 'Agent')
            { Invoke-PythonTest Catzc.Widget } | Should -Throw '*no managed uv found*Run Install-Uv*'
            $script:seen.Count | Should -Be 0
        }

        It 'throws when the module has no Python test folder' {
            { Invoke-PythonTest Catzc.Sprocket } | Should -Throw '*python/tests/catzc-sprocket/ does not exist*'
        }

        It 'never lets uv download an interpreter, and passes the engine contract loading the entry, and the root' {
            $null = Invoke-PythonTest Catzc.Widget -EntryScript $script:buildEntry
            $expected = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.StartArguments((Resolve-Path -LiteralPath $script:buildEntry).ProviderPath, '{command}')
            foreach ($call in $script:seen) {
                $call.Downloads | Should -Be 'never'
                $call.Executable | Should -Be 'C:\widget\engine\pwsh.exe'
                @($call.Start | ConvertFrom-Json) | Should -Be $expected
                $call.Root | Should -Be $script:root
            }
            Test-Path Env:UV_PYTHON_DOWNLOADS | Should -BeFalse
            Test-Path Env:CATZC_ENGINE_START | Should -BeFalse
        }

        It 'throws with the remedy when uv sync fails' {
            $script:syncExit = 2
            { Invoke-PythonTest Catzc.Widget } | Should -Throw '*uv sync failed*Run Install-Python*No interpreter found*'
        }

        It 'throws with the ruff output when ruff check fails' {
            $script:lintExit = 1
            { Invoke-PythonTest Catzc.Widget } | Should -Throw '*ruff check failed*F401*'
        }
    }

    Context 'the results' {
        It 'returns one record per test function, with outcomes and categories' {
            $results = @(Invoke-PythonTest Catzc.Widget)
            $results | Should -HaveCount 5
            ($results | Where-Object Name -EQ 'test_widget_sizes').Outcome | Should -Be 'fail'
            ($results | Where-Object Name -EQ 'test_integrity_gadget_ships').Category | Should -Be 'integrity'
        }

        It 'throws when pytest fails with no failing test (no report: a usage or collection error)' {
            $script:report = ''
            $script:testExit = 4
            { Invoke-PythonTest Catzc.Widget } | Should -Throw '*pytest failed*exit 4*no failing test*'
        }

        It 'throws when pytest collected no tests (exit 5)' {
            $script:report = '<testsuites><testsuite tests="0"></testsuite></testsuites>'
            $script:testExit = 5
            { Invoke-PythonTest Catzc.Widget } | Should -Throw '*exit 5*'
        }
    }
}
