Describe 'New-TestAutomationShardScript' {
    Context 'script generation' -Tag 'L0', 'logic' {
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
            # Pester is resolved inside the worker, after its import, from the worker's own code root.
            $script:content | Should -Match ([regex]::Escape("Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'"))
            $script:content | Should -Match ([regex]::Escape("@('C:\repo\a.Tests.ps1', 'C:\repo\b.Tests.ps1')"))
            $script:content | Should -Match ([regex]::Escape("'Normal'"))
            $script:content | Should -Match ([regex]::Escape($script:shard.ResultsPath))
            $script:content | Should -Match ([regex]::Escape($script:shard.RowsPath))
            $script:content | Should -Match 'ConvertTo-TestAutomationRowSet'
        }

        It 'builds its configuration through the one shared builder, strict off' {
            # The worker and Invoke-TestFile must share New-PesterRunConfiguration (one living copy of the
            # invocation config) and the worker turns strict mode off before Pester (ADR-AUTO-TEST:25).
            $script:content | Should -Match 'New-PesterRunConfiguration'
            $script:content | Should -Match ([regex]::Escape('Set-StrictMode -Off'))
        }

        It 'carries the exclude tags and exits with the not-passed flag' {
            $script:content | Should -Match ([regex]::Escape("@('L2', 'L3')"))
            $script:content | Should -Match ([regex]::Escape('exit ([int]($result.Result -ne ''Passed''))'))
        }

        It 'passes empty exclude and include tag literals when neither is given' {
            $bare = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 4 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir
            }
            # order: @(paths) @(excludeTag) @(includeTag) 'Verbosity' — both tag literals empty here.
            (Get-Content -LiteralPath $bare.ScriptPath -Raw) | Should -Match ([regex]::Escape("@() @() 'Detailed'"))
        }

        It 'threads the -Rule include tags into the worker configuration' {
            $ruled = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
                param($Dir)
                New-TestAutomationShardScript -ShardIndex 5 -TestPath @('C:\repo\a.Tests.ps1') -RunDirectory $Dir `
                    -ExcludeTag @('L3') -IncludeTag @('ADR-FAKE#1')
            }
            $content = Get-Content -LiteralPath $ruled.ScriptPath -Raw
            $content | Should -Match ([regex]::Escape("@('L3') @('ADR-FAKE#1')"))
            $content | Should -Match ([regex]::Escape('-IncludeTag $includeTag'))
        }
    }

    # greedy: spawns a full importer-loading pwsh worker — stacked on the parallel pool that
    # oversubscribes the box (see the test-automation ADR's greedy tag).
    # integrity + ADR-AUTO-ASSETDEP#3: the real worker imports the shipped, vendored Pester from its code root,
    # nothing mocked — the real-asset test, not source-only, so it runs in the source and the build suite.
    Context 'worker execution (real pwsh through PesterRunner)' -Tag 'L2', 'integrity', 'greedy', 'ADR-AUTO-ASSETDEP#3' {
        It 'runs a generated shard end to end: results.xml, rows sidecar, and a green exit code' {
            # The walking skeleton for the whole worker chain: generator → PesterRunner → importer →
            # Pester → row sidecar. One real worker; the per-case behaviour lives in the L0 tests above
            # and in ConvertTo-TestAutomationRowSet's own suite.
            $runDirectory = Join-Path $TestDrive 'live-run'
            [void][System.IO.Directory]::CreateDirectory($runDirectory)

            # A fixture suite exercising all row kinds: a pass, a self-skip, and a tag-excluded test — plus a
            # pass proving the worker's Pester is the vendored copy under the worker's own code root.
            $fixture = Join-Path $TestDrive 'ShardFixture.Tests.ps1'
            $fixtureContent = @'
Describe 'ShardFixture' -Tag 'L0', 'logic' {
    It 'passes' { 1 | Should -Be 1 }
    It 'passes with Pester from the code root' {
        $vendorRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'))
        [System.IO.Path]::GetFullPath((Get-Module Pester).ModuleBase) | Should -BeLike "$vendorRoot*"
    }
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
            $rows | Should -HaveCount 4
            $passed = @($rows | Where-Object Result -EQ 'Passed')
            $passed | Should -HaveCount 2 -Because "failed rows: $(($rows | Where-Object Result -EQ 'Failed').ErrorMessage)"
            $passed.ExpandedPath | Should -Match 'passes'
            ($rows | Where-Object Result -EQ 'Skipped').SkipReason | Should -Be 'tool_obj_missing'
            ($rows | Where-Object Result -EQ 'NotRun').Level | Should -Be 'L2'
        }
    }
}
