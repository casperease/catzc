Describe 'Invoke-GoTest' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the seams (ADR-AUTO-TEST#6): a fixture repository root in $TestDrive and a mocked go
        # (Invoke-Executable) that answers with canned `go test -json` streams from tests/assets.
        $script:root = Join-Path $TestDrive 'repo'
        $script:folder = Join-Path $script:root 'go/tests/catzc-widget'
        $null = New-Item -ItemType Directory -Path $script:folder -Force
        Set-Content -LiteralPath (Join-Path $script:folder 'go.mod') -Value 'module catzc/go/tests/catzc-widget'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'go/tests/catzc-gadget') -Force
        $script:buildEntry = Join-Path $TestDrive 'build/Import-Catzc.ps1'
        $null = New-Item -ItemType File -Path $script:buildEntry -Force

        $script:widgetStream = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/go-test-widget.jsonl')
        $script:buildFailedStream = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/go-test-gadget-build-failed.jsonl')

        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
    }

    BeforeEach {
        $script:testOutput = $script:widgetStream
        $script:testExit = 1
        $script:vetExit = 0
        $script:seen = [System.Collections.Generic.List[object]]::new()
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages {
            $script:seen.Add([pscustomobject]@{
                    Command   = $Command
                    Directory = $WorkingDirectory
                    Entry     = $env:CATZC_ENGINE_ENTRY
                    Root      = $env:CATZC_REPOSITORY_ROOT
                })
            switch -Wildcard ($Command) {
                'go vet*' {
                    $vetErrors = ''
                    if ($script:vetExit) {
                        $vetErrors = 'vet: widget_test.go:5:3: undefined: gadget'
                    }
                    [Catzc.Base.Execution.CliResult]::new('', $vetErrors, $script:vetExit)
                }
                'go test*' {
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
            $script:seen.Command | Should -Be @('go mod download', 'go vet ./...', 'go test -json -count=1 ./...')
            $script:seen.Directory | Sort-Object -Unique | Should -Be $script:folder
        }

        It 'throws when the module has no Go test folder' {
            { Invoke-GoTest Catzc.Nothing } | Should -Throw "*Module 'Catzc.Nothing' has no Go tests: go/tests/catzc-nothing/ does not exist*"
        }

        It 'throws with the remediation when the generated go.mod is missing' {
            { Invoke-GoTest Catzc.Gadget } | Should -Throw '*go/tests/catzc-gadget/go.mod is missing*Build-RootConfig*'
        }
    }

    Context 'the engine entry' {
        It 'passes the repository importer and root for a source run' {
            $null = Invoke-GoTest Catzc.Widget
            foreach ($call in $script:seen) {
                $call.Entry | Should -Be (Join-Path $script:root 'importer.ps1')
                $call.Root | Should -Be $script:root
            }
        }

        It 'passes -EntryScript for a build run' {
            $null = Invoke-GoTest Catzc.Widget -EntryScript $script:buildEntry
            foreach ($call in $script:seen) {
                $call.Entry | Should -Be (Resolve-Path -LiteralPath $script:buildEntry).ProviderPath
                $call.Root | Should -Be $script:root
            }
        }

        It 'restores the environment afterwards' {
            $env:CATZC_ENGINE_ENTRY = 'before'
            try {
                $null = Invoke-GoTest Catzc.Widget
                $env:CATZC_ENGINE_ENTRY | Should -Be 'before'
            }
            finally {
                Remove-Item Env:CATZC_ENGINE_ENTRY -ErrorAction Ignore
            }
            Test-Path Env:CATZC_REPOSITORY_ROOT | Should -BeFalse
        }

        It 'restores the environment when a go command throws' {
            $script:vetExit = 1
            { Invoke-GoTest Catzc.Widget } | Should -Throw
            Test-Path Env:CATZC_ENGINE_ENTRY | Should -BeFalse
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
            $script:seen.Command | Should -Not -Contain 'go test -json -count=1 ./...'
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
