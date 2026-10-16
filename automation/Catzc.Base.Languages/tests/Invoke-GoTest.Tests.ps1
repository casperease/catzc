<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
    folder: tests
    name: invoke-go-test-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-languages/tests/Invoke-GoTest.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#6
---
#>

Describe 'Invoke-GoTest' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $script:folder = Join-Path $script:root 'go/tests/catzc-widget'
        $null = New-Item -ItemType Directory -Path $script:folder -Force
        Set-Content -LiteralPath (Join-Path $script:folder 'go.mod') -Value 'module catzc/go/tests/catzc-widget'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'go/tests/catzc-gadget') -Force
        $script:buildEntry = Join-Path $TestDrive 'build/Import-Catzc.ps1'
        $null = New-Item -ItemType File -Path $script:buildEntry -Force

        $script:widgetStream = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/go-test-widget.jsonl')
        $script:buildFailedStream = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/go-test-gadget-build-failed.jsonl')

        $script:goPath = Join-Path $TestDrive 'managed go/bin/go.exe'
        $script:go = "`"$($script:goPath)`""

        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
    }

    BeforeEach {
        $script:testOutput = $script:widgetStream
        $script:testExit = 1
        $script:vetExit = 0
        $script:seen = [System.Collections.Generic.List[object]]::new()
        $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('go', $script:goPath, 'probe', '1.27.1', '1.27', $true, 1, 0, 'Agent')
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Languages { $script:probe }
        Mock Resolve-EngineExecutable -ModuleName Catzc.Base.Languages { 'C:\widget\engine\pwsh.exe' }
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages {
            $script:seen.Add([pscustomobject]@{
                    Command    = $Command
                    Directory  = $WorkingDirectory
                    Executable = $env:CATZC_ENGINE_EXECUTABLE
                    Start      = $env:CATZC_ENGINE_START
                    Root       = $env:CATZC_REPOSITORY_ROOT
                    Toolchain  = $env:GOTOOLCHAIN
                })
            switch -Wildcard ($Command) {
                '* vet *' {
                    $vetErrors = ''
                    if ($script:vetExit) {
                        $vetErrors = 'vet: widget_test.go:5:3: undefined: gadget'
                    }
                    [Catzc.Base.Execution.CliResult]::new('', $vetErrors, $script:vetExit)
                }
                '* test *' {
                    [Catzc.Base.Execution.CliResult]::new($script:testOutput, '', $script:testExit)
                }
                default {
                    [Catzc.Base.Execution.CliResult]::new('', '', 0)
                }
            }
        }
    }

    Context 'the go commands' {
        It 'runs go mod download, go vet, then go test -json -count=1 in the module''s kebab folder' {
            $null = Invoke-GoTest Catzc.Widget
            $script:seen.Command | Should -Be @("$go mod download", "$go vet ./...", "$go test -json -count=1 ./...")
            $script:seen.Directory | Sort-Object -Unique | Should -Be $script:folder
        }

        It 'runs the managed go by its quoted path from the tools.yml probe, never a bare go' {
            $null = Invoke-GoTest Catzc.Widget
            Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Languages -ParameterFilter { $Tool -eq 'go' }
            foreach ($command in $script:seen.Command) {
                [Catzc.Base.Execution.CliRunner]::ExecutableName($command) | Should -Be $script:goPath
            }
        }

        It 'runs the caller''s -GoExecutable by its quoted path without locating go itself' {
            $callerGo = Join-Path $TestDrive 'caller go/bin/go.exe'
            $null = New-Item -ItemType File -Path $callerGo -Force
            $null = Invoke-GoTest Catzc.Widget -GoExecutable $callerGo
            Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Languages -Times 0 -Exactly
            foreach ($command in $script:seen.Command) {
                [Catzc.Base.Execution.CliRunner]::ExecutableName($command) | Should -Be $callerGo
            }
        }

        It 'throws when -GoExecutable does not exist, before running anything' {
            { Invoke-GoTest Catzc.Widget -GoExecutable (Join-Path $TestDrive 'absent/go.exe') } | Should -Throw
            $script:seen.Count | Should -Be 0
        }

        It 'throws with "Run Install-Go" when no managed go is found, before running anything' {
            $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('go', $null, 'none', $null, '1.27', $false, 1, 0, 'Agent')
            { Invoke-GoTest Catzc.Widget } | Should -Throw '*no managed go found*Run Install-Go*'
            $script:seen.Count | Should -Be 0
        }

        It 'throws with "Run Install-Go" when the go found does not match the tools.yml pin' {
            $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('go', $script:goPath, 'path', '1.22.5', '1.27', $false, 1, 3, 'Agent')
            { Invoke-GoTest Catzc.Widget } | Should -Throw "*reports version '1.22.5', but tools.yml pins '1.27'. Run Install-Go*"
            $script:seen.Count | Should -Be 0
        }

        It 'runs in the module''s folder under .go/tests/ when the repository has no go/ folder' {
            $dotRoot = Join-Path $TestDrive 'dot-repo'
            $dotFolder = Join-Path $dotRoot '.go/tests/catzc-widget'
            $null = New-Item -ItemType Directory -Path $dotFolder -Force
            Set-Content -LiteralPath (Join-Path $dotFolder 'go.mod') -Value 'module catzc/go/tests/catzc-widget'
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { Join-Path $TestDrive 'dot-repo' }
            $null = Invoke-GoTest Catzc.Widget
            $script:seen.Directory | Sort-Object -Unique | Should -Be $dotFolder
            { Invoke-GoTest Catzc.Nothing } | Should -Throw '*has no Go tests: .go/tests/catzc-nothing/ does not exist*'
        }

        It 'throws when the module has no Go test folder' {
            { Invoke-GoTest Catzc.Nothing } | Should -Throw "*Module 'Catzc.Nothing' has no Go tests: go/tests/catzc-nothing/ does not exist*"
        }

        It 'throws with the remediation when the generated go.mod is missing' {
            { Invoke-GoTest Catzc.Gadget } | Should -Throw '*go/tests/catzc-gadget/go.mod is missing*Build-RootConfig*'
        }
    }

    Context 'the engine contract' {
        It 'passes the engine, its start arguments loading the repository importer, and the root for a source run' {
            $null = Invoke-GoTest Catzc.Widget
            $expected = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.StartArguments((Join-Path $script:root 'importer.ps1'), '{command}')
            foreach ($call in $script:seen) {
                $call.Executable | Should -Be 'C:\widget\engine\pwsh.exe'
                @($call.Start | ConvertFrom-Json) | Should -Be $expected
                $call.Root | Should -Be $script:root
            }
        }

        It 'loads -EntryScript for a build run' {
            $null = Invoke-GoTest Catzc.Widget -EntryScript $script:buildEntry
            $expected = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.StartArguments((Resolve-Path -LiteralPath $script:buildEntry).ProviderPath, '{command}')
            foreach ($call in $script:seen) {
                @($call.Start | ConvertFrom-Json) | Should -Be $expected
                $call.Root | Should -Be $script:root
            }
        }

        It 'runs every go command with GOTOOLCHAIN=local, so go never switches to a downloaded toolchain' {
            $null = Invoke-GoTest Catzc.Widget
            $script:seen.Count | Should -BeGreaterThan 0
            foreach ($call in $script:seen) {
                $call.Toolchain | Should -Be 'local'
            }
            Test-Path Env:GOTOOLCHAIN | Should -BeFalse
        }

        It 'restores the environment afterwards' {
            $env:CATZC_ENGINE_START = 'before'
            try {
                $null = Invoke-GoTest Catzc.Widget
                $env:CATZC_ENGINE_START | Should -Be 'before'
            }
            finally {
                Remove-Item Env:CATZC_ENGINE_START -ErrorAction Ignore
            }
            Test-Path Env:CATZC_REPOSITORY_ROOT | Should -BeFalse
            Test-Path Env:CATZC_ENGINE_EXECUTABLE | Should -BeFalse
        }

        It 'restores the environment when a go command throws' {
            $script:vetExit = 1
            { Invoke-GoTest Catzc.Widget } | Should -Throw
            Test-Path Env:CATZC_ENGINE_START | Should -BeFalse
        }

        It 'throws when -EntryScript does not exist' {
            { Invoke-GoTest Catzc.Widget -EntryScript (Join-Path $TestDrive 'missing.ps1') } | Should -Throw
            $script:seen.Count | Should -Be 0
        }
    }

    Context 'the results' {
        It 'returns one record per top-level test, in run order, with outcomes and categories' {
            $results = @(Invoke-GoTest Catzc.Widget)
            $results.Name | Should -Be @('TestPass', 'TestFail', 'TestSkip', 'TestIntegrityTable')
            $results.Outcome | Should -Be @('pass', 'fail', 'skip', 'fail')
            $results.Category | Should -Be @('logic', 'logic', 'logic', 'integrity')
            $results | ForEach-Object { $_ | Should -BeOfType [Catzc.Base.Languages.GoTestResult] }
            $results[0].Package | Should -Be 'catzc/go/tests/catzc-widget'
        }

        It 'returns a passing run without throwing' {
            $script:testExit = 0
            $script:testOutput = @(
                '{"Action":"run","Package":"catzc/go/tests/catzc-widget","Test":"TestPass"}'
                '{"Action":"pass","Package":"catzc/go/tests/catzc-widget","Test":"TestPass","Elapsed":0.25}'
                '{"Action":"pass","Package":"catzc/go/tests/catzc-widget","Elapsed":0.3}'
            ) -join "`n"
            $result = Invoke-GoTest Catzc.Widget
            $result.Outcome | Should -Be 'pass'
            $result.DurationSeconds | Should -Be 0.25
        }
    }

    Context 'failures outside the tests' {
        It 'throws with the go output when go vet fails' {
            $script:vetExit = 1
            { Invoke-GoTest Catzc.Widget } | Should -Throw '*go vet failed in go/tests/catzc-widget/*undefined: gadget*'
            $script:seen.Command | Should -Not -Contain "$go test -json -count=1 ./..."
        }

        It 'throws with the compiler output when the test package does not build' {
            $script:testOutput = $script:buildFailedStream
            { Invoke-GoTest Catzc.Widget } | Should -Throw '*did not build*undefined: undefinedThing*'
        }

        It 'throws when go fails with no failing test' {
            $script:testOutput = ''
            { Invoke-GoTest Catzc.Widget } | Should -Throw '*with no failing test*'
        }
    }
}
