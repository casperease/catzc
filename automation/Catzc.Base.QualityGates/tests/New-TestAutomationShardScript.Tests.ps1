Describe 'New-TestAutomationShardScript' -Tag 'logic' {
    Context 'script generation' -Tag 'L0' {
        BeforeAll {
            $script:runDirectory = Join-Path $TestDrive 'run'
            [void][System.IO.Directory]::CreateDirectory($script:runDirectory)

            $script:shard = InModuleScope Catzc.Base.QualityGates -Parameters @{
                Dir = $script:runDirectory
            } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 3 `
                    -TestPath @('C:\repo\a.Tests.ps1', 'C:\repo\b.Tests.ps1') `
                    -RunDirectory $Dir -ExcludeTag @('L2', 'L3') -Verbosity Normal
            }
            $script:content = Get-Content -LiteralPath $script:shard.ScriptPath -Raw
        }

        It 'returns the shard descriptor with index-derived paths' {
            $script:shard.ShardIndex | Should -Be 3
            $script:shard.Label | Should -Be 'shard-3'
            $script:shard.ScriptPath | Should -Be (Join-Path $script:runDirectory 'shard-3.ps1')
            $script:shard.ResultsPath | Should -Be (Join-Path $script:runDirectory 'results-shard-3.xml')
            $script:shard.RowsPath | Should -Be (Join-Path $script:runDirectory 'rows-shard-3.json')
            $script:shard.ScriptPath | Should -Exist
        }

        It 'imports the repository, runs the shard files, and writes the run artifacts' {
            $script:content | Should -Match ([regex]::Escape("importer.ps1' -SkipJanitors"))
            $script:content | Should -Match ([regex]::Escape('.vendor/Pester'))
            $script:content | Should -Match ([regex]::Escape("@('C:\repo\a.Tests.ps1', 'C:\repo\b.Tests.ps1')"))
            $script:content | Should -Match ([regex]::Escape("'Normal'"))
            $script:content | Should -Match ([regex]::Escape($script:shard.ResultsPath))
            $script:content | Should -Match ([regex]::Escape($script:shard.RowsPath))
            $script:content | Should -Match 'ConvertTo-TestAutomationRowSet'
        }

        It 'builds its configuration through the one shared builder, strict off' {
            # The worker and Invoke-TestFile must share New-PesterRunConfiguration (one living copy of the
            # invocation config) and the worker turns strict mode off before Pester (ADR-TEST:25).
            $script:content | Should -Match 'New-PesterRunConfiguration'
            $script:content | Should -Match ([regex]::Escape('Set-StrictMode -Off'))
        }

        It 'carries the exclude tags and exits with the not-passed flag' {
            $script:content | Should -Match ([regex]::Escape("@('L2', 'L3')"))
            $script:content | Should -Match ([regex]::Escape('exit ([int]($result.Result -ne ''Passed''))'))
        }

        It 'passes an empty tag literal when no tags are excluded' {
            $bare = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 4 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir
            }
            (Get-Content -LiteralPath $bare.ScriptPath -Raw) | Should -Match ([regex]::Escape("@() 'Detailed'"))
        }
    }

    # serial: spawns a full importer-loading pwsh worker — stacked on the parallel pool that
    # oversubscribes the box (see the test-automation ADR's serial tag).
    Context 'worker execution (real pwsh through PesterRunner)' -Tag 'L2', 'serial' {
        It 'runs a generated shard end to end: results.xml, rows sidecar, and a green exit code' {
            # The walking skeleton for the whole worker chain: generator → PesterRunner → importer →
            # Pester → row sidecar. One real worker; the per-case behaviour lives in the L0 tests above
            # and in ConvertTo-TestAutomationRowSet's own suite.
            $runDirectory = Join-Path $TestDrive 'live-run'
            [void][System.IO.Directory]::CreateDirectory($runDirectory)

            # A fixture suite exercising all row kinds: a pass, a self-skip, and a tag-excluded test.
            $fixture = Join-Path $TestDrive 'ShardFixture.Tests.ps1'
            $fixtureContent = @'
Describe 'ShardFixture' -Tag 'L0', 'logic' {
    It 'passes' { 1 | Should -Be 1 }
    It 'skips itself' { Set-ItResult -Skipped -Because 'tool_obj_missing'; return }
}
Describe 'ShardFixtureWide' -Tag 'L2', 'logic' {
    It 'is excluded by tag' { 1 | Should -Be 1 }
}
'@
            [System.IO.File]::WriteAllText($fixture, $fixtureContent)

            $shard = InModuleScope Catzc.Base.QualityGates -Parameters @{
                Dir = $runDirectory; Fixture = $fixture
            } {
                param($Dir, $Fixture)
                New-TestAutomationShardScript -ShardIndex 0 -TestPath @($Fixture) -RunDirectory $Dir `
                    -ExcludeTag @('L2') -Verbosity Minimal
            }

            $runner = [Catzc.Base.QualityGates.PesterRunner]::Run(
                @($shard.ScriptPath), @($shard.Label), 1, $null, 300, $true)

            $runner.Results[0].ExitCode | Should -Be 0 -Because "worker stderr: $($runner.Results[0].Stderr)"
            $shard.ResultsPath | Should -Exist
            $shard.RowsPath | Should -Exist

            $rows = @(Get-Content -LiteralPath $shard.RowsPath -Raw | ConvertFrom-Json)
            $rows | Should -HaveCount 3
            ($rows | Where-Object Result -EQ 'Passed').ExpandedPath | Should -Match 'passes'
            ($rows | Where-Object Result -EQ 'Skipped').SkipReason | Should -Be 'tool_obj_missing'
            ($rows | Where-Object Result -EQ 'NotRun').Level | Should -Be 'L2'
        }
    }
}
